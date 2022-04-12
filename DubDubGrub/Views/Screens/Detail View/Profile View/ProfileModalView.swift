//
//  ProfileModalView.swift
//  DubDubGrub
//
//  Created by Steve Plavetzky on 4/12/22.
//

import SwiftUI

struct ProfileModalView: View {
    var body: some View {
        ZStack{
            VStack{
                Spacer().frame(height: 60)
                Text("Steve Plavetzky")
                    .bold()
                    .font(.title2)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                Text("Company Name")
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                    .foregroundColor(.secondary)
                Text("This is my sample bio, lets keep updating this so it keeps going and see if it goes onto three lines before it stopps working ")
                    .lineLimit(3)
                    .padding()
            }
            .frame(width: 300, height: 230)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(16)
            .overlay(
                Button(action: {
                    //dismiss
                }, label: {
                    XDismissButton()
                }), alignment: .topTrailing
            )
            
            Image(uiImage: PlaceholderImage.avatar)
                .resizable()
                .scaledToFill()
                .frame(width: 110, height: 110)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 6)
                .offset(y: -120)
        }
    }
}

struct ProfileModalView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileModalView()
    }
}
