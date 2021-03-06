//
//  ProfileView.swift
//  DubDubGrub
//
//  Created by Steve Plavetzky on 4/4/22.
//

import SwiftUI

struct ProfileView: View {
    
    @StateObject var vm : ProfileVM
    @FocusState private var focusedTextField: ProfileTextField?
    
    enum ProfileTextField {
        case firstName, lastName, companyName, bio
    }
    var body: some View {
        ZStack {
            VStack{
                HStack(spacing: 16){
                    ProfileImageView(avatar: vm.avatar)
                        .onTapGesture {
                            vm.isShowingPhotoPicker = true
                        }
                    
                    VStack(spacing: 1){
                        TextField("First Name", text: $vm.firstName)
                            .profileNameStyle()
                            .focused($focusedTextField, equals: .firstName)
                            .onSubmit {focusedTextField = .lastName}
                            .submitLabel(.next)
                        TextField("Last Name", text: $vm.lastName)
                            .profileNameStyle()
                            .focused($focusedTextField, equals: .lastName)
                            .onSubmit {focusedTextField = .companyName}
                            .submitLabel(.next)
                        TextField("Company Name", text: $vm.companyName)
                            .focused($focusedTextField, equals: .companyName)
                            .onSubmit {focusedTextField = .bio}
                            .submitLabel(.next)
                    }
                    .padding(.trailing, 16)
                }
                .padding(.vertical)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 8){
                    HStack{
                        CharactersRemainView(currentCount: vm.bio.count)
                            .accessibilityAddTraits(.isHeader)
                        
                        Spacer()
                        if vm.isCheckedIn{
                            Button {
                                vm.checkOut()
                            } label: {
                                CheckOutButton()
                            }
                        }
                    }
                    BioTextEditor(text: $vm.bio)
                        .focused($focusedTextField, equals: .bio)
                }
                .padding(.horizontal, 16)
                
                Spacer()
                
                Button{
                    vm.determinButtonAction()
                } label: {
                    DDGButton(title:  vm.buttonTitle)
                }
                .disabled(vm.isLoading)
                .padding(.bottom)
            }
            .toolbar{
                ToolbarItemGroup(placement: .keyboard) {
                    Button("Dismiss") {focusedTextField = nil}
                }
            }
            if vm.isLoading{
                LoadingView()
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(DeviceTypes.isiPhone8Standard ? .inline : .automatic)
        .ignoresSafeArea(.keyboard)
        .task{
            vm.getProfile()
            vm.getCheckedInStatus()
        }
        .alert(item: $vm.alertItem, content: { $0.alert})
        .sheet(isPresented: $vm.isShowingPhotoPicker) {
            PhotoPicker(image: $vm.avatar)
        }
    }
}


//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView{
//            ProfileView()
//        }
//    }
//}



fileprivate struct NameBackgroundView: View {
    
    var body: some View {
        Color(.secondarySystemBackground)
            .frame(height: 130)
            .cornerRadius(12)
            .padding(.horizontal)
    }
}


fileprivate struct ProfileImageView: View {
    
    var avatar: UIImage
    
    var body: some View {
        ZStack{
            AvatarView(image: avatar, size: 84)
            Image(systemName: "square.and.pencil")
                .resizable()
                .scaledToFit()
                .frame(width: 14, height: 14)
                .foregroundColor(.white)
                .offset(y: 30)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityAddTraits(.isButton)
        .accessibilityLabel(Text("Profile Photo"))
        .accessibilityHint(Text("Opens the iPhone's photo picker."))
        .padding(.leading, 12)
    }
}


fileprivate struct CharactersRemainView: View{
    
    var currentCount: Int
    
    var body: some View{
        Text("Bio: ")
            .font(.callout)
            .foregroundColor(.secondary)
        +
        Text("\(100 - currentCount)")
            .bold()
            .font(.callout)
            .foregroundColor(currentCount <= 100 ? .brandPrimary : Color(.systemPink))
        +
        Text(" Characters remain")
            .font(.callout)
            .foregroundColor(.secondary)
    }
}


fileprivate struct CheckOutButton: View{
    
    var body: some View{
        Label("Check Out", systemImage: "mappin.and.ellipse")
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(.white)
            .padding(10)
            .frame(height: 28)
            .background(Color.grubRed)
            .cornerRadius(8)
            .accessibilityLabel(Text("Check out of current location."))
    }
}


fileprivate struct BioTextEditor: View{
    
    var text: Binding<String>
    
    var body: some View{
        TextEditor(text: text)
            .frame(height: 100)
            .overlay{
                RoundedRectangle(cornerRadius: 8)
                .stroke(Color.secondary, lineWidth: 1)
            }
            .accessibilityHint(Text("This TextField is for your bio and has a 100 character maximum."))
    }
}
