//
//  ProfileVM.swift
//  DubDubGrub
//
//  Created by Steve Plavetzky on 4/11/22.
//

import CloudKit

enum ProfileContext {
    case create, update
}

final class ProfileVM: ObservableObject{
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var companyName = ""
    @Published var bio = ""
    @Published var avatar = PlaceholderImage.avatar
    @Published var isShowingPhotoPicker = false
    @Published var alertItem: AlertItem?
    @Published var isLoading = false
    
    private var existingProfileRecord: CKRecord? {
        didSet{
            profileContext = .update
        }
    }
    var profileContext: ProfileContext = .create
    
    func isValidProfile() -> Bool{
        guard !firstName.isEmpty,
              !lastName.isEmpty,
              !companyName.isEmpty,
              !bio.isEmpty,
              avatar != PlaceholderImage.avatar,
              bio.count <= 100 else {return false}
        
        return true
    }
    
    
    func createProfile(){
        guard isValidProfile() else {
            alertItem = AlertContext.invalidProfile
            return
        }
        //Create our CKRecord from the profile view
        let profileRecord = createProfileRecord()
        
        guard let userRecord = CloudKitManager.shared.userRecord else {
            alertItem = AlertContext.noUserRecord
            return
        }
        userRecord["userProfile"] = CKRecord.Reference(recordID: profileRecord.recordID, action: .none)
        showLoadingView()
        CloudKitManager.shared.batchSave(records: [userRecord, profileRecord]) { result in
            DispatchQueue.main.async { [self] in
                hideLoadingView()
                switch result{
                case .success(let records):
                    alertItem = AlertContext.createProfileSuccess
                    for record in records where record.recordType == RecordType.profile{
                        existingProfileRecord = record
                    }
                    
                case .failure(_):
                    alertItem = AlertContext.createProfileFailure
                    break
                }
            }
        }
    }
    
    
    func getProfile(){
        guard let userRecord = CloudKitManager.shared.userRecord else {
            alertItem = AlertContext.noUserRecord
            return
        }
        
        guard let profileReference = userRecord["userProfile"] as? CKRecord.Reference else { return }
        
        let profileRecordID = profileReference.recordID
        showLoadingView()
        CloudKitManager.shared.fetchRecord(with: profileRecordID) { result in
            DispatchQueue.main.async {[self] in
                hideLoadingView()
                switch result{
                case .success(let profileRecord):
                    let profile = DDGProfile(record: profileRecord)
                    firstName = profile.firstName
                    lastName = profile.lastName
                    companyName = profile.companyName
                    bio = profile.bio
                    avatar = profile.createAvatarImage()
                    existingProfileRecord = profileRecord
                case .failure(_):
                    alertItem = AlertContext.unableToGetProfile
                }
            }
        }
    }
    
    
    func updateProfile() {
        guard isValidProfile() else {
            alertItem = AlertContext.invalidProfile
            return
        }
        guard let profileRecord = existingProfileRecord else {
            alertItem = AlertContext.unableToGetProfile
            return
        }
        
        profileRecord[DDGProfile.kFirstName] = firstName
        profileRecord[DDGProfile.kLastName] = lastName
        profileRecord[DDGProfile.kCompanyName] = companyName
        profileRecord[DDGProfile.kBio] = bio
        profileRecord[DDGProfile.kAvatar] = avatar.convertToCKAsset()
        
        showLoadingView()
        CloudKitManager.shared.save(record: profileRecord) { result in
            DispatchQueue.main.async { [self] in
                hideLoadingView()
                switch result{
                case .success(_):
                    alertItem = AlertContext.updateProfileSuccess
                case .failure(_):
                    alertItem = AlertContext.updateProfileFailure
                }
            }
        }
    }
    
    
    private func createProfileRecord() -> CKRecord{
        let profileRecord = CKRecord(recordType: RecordType.profile)
        profileRecord[DDGProfile.kFirstName] = firstName
        profileRecord[DDGProfile.kLastName] = lastName
        profileRecord[DDGProfile.kCompanyName] = companyName
        profileRecord[DDGProfile.kBio] = bio
        profileRecord[DDGProfile.kAvatar] = avatar.convertToCKAsset()
        return profileRecord
    }
    
    
    private func showLoadingView(){ isLoading = true}
    private func hideLoadingView(){isLoading = false}
}
