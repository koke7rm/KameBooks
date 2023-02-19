//
//  SplashView.swift
//  KameBooks
//
//  Created by Jorge Suárez on 12/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import SwiftUI

enum Screens {
    case splash
    case onboarding
    case auth
    case home
}

struct SplashView: View {
    
    @StateObject var monitorNetwork = NetworkStatus()
    
    @AppStorage("isFirstLaunch") var isFirstLaunch = true
    
    @State var screen: Screens = .splash
    @State var splashAnimation = false
    let user = KameBooksKeyChain.shared.user
    
    var body: some View {
        ZStack {
            Color.blackLight
                .ignoresSafeArea()
            Group {
                switch screen {
                case .splash:
                    splash
                        .transition(.move(edge: .leading))
                case .onboarding:
                    OnboardingView(screen: $screen)
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                case .auth:
                    AuthView(screen: $screen)
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                case .home:
                    TabBar(screen: $screen)
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                }
            }
            .animation(.default, value: screen)
            .overlay {
                if monitorNetwork.status == .offline {
                    AppOfflineView()
                        .transition(.opacity)
                }
            }
        }
    }
    
    var splash: some View {
        ZStack {
            LinearGradient(gradient: Gradient.mainGradient, startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            Image(decorative: "img_logoName")
                .resizable()
                .scaledToFit()
                .padding()
                .offset(y: splashAnimation ? 0.0 : 500)
        }
        .onAppear {
            splashAnimation = true
            Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { _ in
                if isFirstLaunch {
                    screen = .onboarding
                } else if user == nil{
                    screen = .auth
                } else {
                    screen = .home
                }
            }
        }
        .animation(.easeOut(duration: 1), value: splashAnimation)
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
