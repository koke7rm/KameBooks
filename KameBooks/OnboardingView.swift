//
//  OnboardingView.swift
//  KameBooks
//
//  Created by Jorge Suárez on 12/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import SwiftUI


struct OnboardingView: View {
    
    @State var selection = 0
    @Binding var screen: Screens
    @AppStorage("isFirstLaunch") var isFirstLaunch = true
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea(edges: .bottom)
            VStack {
                TabView(selection: $selection) {
                    OnboardingPage(title: "ONBOARDING_FIRST_TITLE".localized, image: "img_decision", description: "ONBOARDING_FIRST_DESCRIPTION".localized)
                        .tag(0)
                    OnboardingPage(title: "ONBOARDING_SECOND_TITLE".localized, image: "img_reading", description: "ONBOARDING_SECOND_DESCRIPTION".localized)
                        .tag(1)
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                .animation(.easeInOut, value: selection) // 2
                
                Button {
                    if selection == 0 {
                        selection = 1
                    } else {
                        screen = .auth
                        isFirstLaunch = false
                    }
                } label: {
                    Text("NEXT".localized)
                        .foregroundColor(.black)
                        .bold()
                        .textCase(.uppercase)
                }
                .buttonStyle(.bordered)
                .tint(.gold)
            }
            .background(Color.white)
            .padding()
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(screen: .constant(.auth))
    }
}

