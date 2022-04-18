//
//  ProfileSheetView.swift
//  DubDubGrub
//
//  Created by Steve Plavetzky on 4/15/22.
//

import SwiftUI


//Alternative profile modal view for larger dynamic type sizes
//This is presented as a sheet instead of a small pop up

struct ProfileSheetView: View {
    var profile: DDGProfile
    
    var body: some View {
        ScrollView{
            VStack(spacing: 20){
                Image(uiImage: profile.avatarImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 6)
                    .accessibilityHidden(true)
                Text(profile.firstName + " " + profile.lastName)
                    .bold()
                    .font(.title2)
                Text(profile.companyName)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                    .accessibilityLabel(Text("Works at \(profile.companyName)"))
                Text(profile.bio)
                    .accessibilityLabel(Text("Bio, \(profile.bio)"))
            }
            .padding()
        }

    }
}

struct ProfileSheetView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSheetView(profile: DDGProfile(record: MockData.profile))
            .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
    }
}
