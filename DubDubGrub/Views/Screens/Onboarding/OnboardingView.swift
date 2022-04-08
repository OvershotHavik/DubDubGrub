//
//  OnboardingView.swift
//  DubDubGrub
//
//  Created by Steve Plavetzky on 4/8/22.
//

import SwiftUI

struct OnboardingView: View {
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Button {
                    
                } label: {
                    XDismissButton()
                }
            }
            Spacer()
            LogoView(frameWidth: 250)
                .padding(.bottom)
            VStack(alignment: .leading, spacing: 32){
                OnboardInfoView(sfSymbol: "building.2.crop.circle",
                                title: "Restaurant Locations",
                                description: "Find places to dine around the convention center")
                OnboardInfoView(sfSymbol: "checkmark.circle",
                                title: "Check In",
                                description: "Let other iOS Devs know where you are")
                OnboardInfoView(sfSymbol: "person.2.circle",
                                title: "Find Friends",
                                description: "See where other iOS Devs are and join the party")
            }
            .padding(.horizontal, 30)
            Spacer()
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}

struct OnboardInfoView: View {
    var sfSymbol: String
    var title: String
    var description: String
    
    var body: some View {
        HStack(spacing: 26){
            Image(systemName: sfSymbol)
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.brandPrimary)
            VStack(alignment: .leading, spacing: 4){
                Text(title)
                    .bold()
                Text(description)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.75)
            }
        }
    }
}
