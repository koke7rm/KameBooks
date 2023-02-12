//
//  SplashView.swift
//  KameBooks
//
//  Created by Jorge Suárez on 12/2/23.
//

import SwiftUI

enum Screens {
    case splash
    case onboarding
    case auth
    case register
    case login
}

struct SplashView: View {
    
    @StateObject var monitorNetwork = NetworkStatus()
    
    @State var screen: Screens = .splash
    @State var splashAnimation = false
    @AppStorage("isFirstLaunch") var isFirstLaunch = true
    
    var body: some View {
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
            case .register:
                RegisterView(screen: $screen)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            case .login:
                RegisterView(screen: $screen)
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
    
    var splash: some View {
        ZStack {
            Color.black
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
                } else {
                    screen = .auth
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
