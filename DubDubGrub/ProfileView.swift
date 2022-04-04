//
//  ProfileView.swift
//  DubDubGrub
//
//  Created by Steve Plavetzky on 4/4/22.
//

import SwiftUI

struct ProfileView: View {
    
    @State var bioText: String = ""
    @State var characterCount: Int = 100
    
    var body: some View {
        VStack{
            ZStack{
                Color(.secondarySystemBackground)
                    .frame(height: 130)
                    .cornerRadius(12)
                    .padding(.horizontal)
                
                HStack(spacing: 20){
                    ZStack{
                        AvatarView(size: 84)
                        VStack{
                            Spacer()
                            Image(systemName: "square.and.pencil")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 25)
                                .foregroundColor(.white)
                                .padding(.vertical, 4)
                        }
                    }
                    .frame(height: 90)
                    
                    VStack(alignment: .leading, spacing: 10){
                        Text("First Name")
                            .font(.title)
                            .bold()
                        Text("Last Name")
                            .font(.title)
                            .bold()
                        Text("Description")
                            .font(.headline)
                    }
                    Spacer()
                }
                .padding()
                
            }
            HStack{
                HStack{
                    Text("Bio:")
                    Text("\(characterCount)")
                        .foregroundColor(characterCount > 0 ? .green : .red)
                    Text("characters remain")
                }
                Spacer()
                Button {
                    
                } label: {
                    Label("Check Out", systemImage: "mappin.and.ellipse")
                        .padding()
                        .foregroundColor(.white)
                        .background(.pink)
                        .cornerRadius(10)
                }
            }
            TextEditor(text: $bioText)
                .frame(height: 100)
                .border(Color(uiColor: UIColor.systemGray), width: 2)
                .onAppear{
                    characterCount -= characterCount - bioText.count
                }
            Spacer()
            Button{
                
            } label: {
                Text("Save Profile")
                    .bold()
                    .foregroundColor(.white)
                    .frame(width: 300, height: 50)
                    .background(Color.brandPrimary)
                    .cornerRadius(10)
            }
        }
        .padding()
        .navigationTitle("Profile")
        
        
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            ProfileView()
        }
    }
}
