//
//  ProfileView.swift
//  DubDubGrub
//
//  Created by Steve Plavetzky on 4/4/22.
//

import SwiftUI

struct ProfileView: View {
    
    @StateObject private var vm = ProfileVM()
    
    var body: some View {
        ZStack {
            VStack{
                ZStack{
                    NameBackgroundView()
                    
                    HStack(spacing: 16){
                        ZStack{
                            AvatarView(image: vm.avatar, size: 84)
                            EditImageView()
                        }
                        .padding(.leading, 12)
                        .onTapGesture {
                            vm.isShowingPhotoPicker = true
                        }
                        
                        VStack(spacing: 1){
                            TextField("First Name", text: $vm.firstName)
                                .profileNameStyle()
                            TextField("Last Name", text: $vm.lastName)
                                .profileNameStyle()
                            TextField("Company Name", text: $vm.companyName)
                            
                        }
                        .padding(.trailing, 16)
                    }
                    .padding()
                }
                VStack(alignment: .leading, spacing: 8){
                    HStack{
                        CharactersRemainView(currentCount: vm.bio.count)
                        Spacer()
                        if vm.isCheckedIn{
                            Button {
                                vm.checkOut()
                                playHaptic()
                            } label: {
                                Label("Check Out", systemImage: "mappin.and.ellipse")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .frame(height: 28)
                                    .background(Color.grubRed)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    TextEditor(text: $vm.bio)
                        .frame(height: 100)
                        .overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.secondary, lineWidth: 1))
                }
                .padding(.horizontal, 16)
                
                Spacer()
                
                Button{
                    vm.profileContext == .create ? vm.createProfile() : vm.updateProfile()
                } label: {
                    DDGButton(title:  vm.profileContext == .create ? "Create Profile": "Update Profile")
                }
                .padding(.bottom)
            }
            if vm.isLoading{
                LoadingView()
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(DeviceTypes.isiPhone8Standard ? .inline : .automatic)
        
        .toolbar(content: {
            Button {
                dismissKeyboard()
            } label: {
                Image(systemName: "keyboard.chevron.compact.down")
            }
        })
        .onAppear{
            vm.getProfile()
            vm.getCheckedInStatus()
        }
        .alert(item: $vm.alertItem, content: { alertItem in
            Alert(title: alertItem.title,
                  message: alertItem.message,
                  dismissButton: alertItem.dismissButton)
        })
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


struct NameBackgroundView: View {
    var body: some View {
        Color(.secondarySystemBackground)
            .frame(height: 130)
            .cornerRadius(12)
            .padding(.horizontal)
    }
}


struct EditImageView: View {
    var body: some View {
        Image(systemName: "square.and.pencil")
            .resizable()
            .scaledToFit()
            .frame(width: 14, height: 14)
            .foregroundColor(.white)
            .offset(y: 30)
    }
}


struct CharactersRemainView: View{
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


