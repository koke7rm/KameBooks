//
//  AuthView.swift
//  KameBooks
//
//  Created by Jorge Suárez on 12/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import SwiftUI

enum AuthStep {
    case register
    case login
    case auth
}

struct AuthView: View {
    
    @Binding var screen: Screens
    @State var authStep: AuthStep = .auth
    @AppStorage("isGuest") var isGuest = false
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient.mainGradient, startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack {
                headerSection
                Spacer()
                
                Group {
                    switch authStep {
                    case .auth:
                        auth
                            .transition(.move(edge: .leading))
                    case .register:
                        RegisterView(screen: $screen, authStep: $authStep)
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    case .login:
                        LoginView(screen: $screen, authStep: $authStep)
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    }
                }
                .animation(.default, value: authStep)
                Spacer()
            }
        }
    }
    
    var auth: some View {
        VStack(spacing: 21) {
            SimpleButton(text: "AUTH_CREATE_ACCOUNT".localized, foregroundColor: .white, backroundColor: .blackLight) {
                authStep = .register
                isGuest = false
            }
            SimpleButton(text: "AUTH_LOGIN".localized, foregroundColor: .white, backroundColor: .blackLight) {
                authStep = .login
                isGuest = false
            }
            SimpleButton(text: "AUTH_GUEST".localized, foregroundColor: .white, backroundColor: .blackLight) {
                isGuest = true
                KameBooksKeyChain.shared.deleteUser()
                screen = .home
            }
        }
        .padding(.horizontal, 50)
    }
    
    var headerSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Image("img_logoText")
                .resizable()
                .scaledToFit()
            Text("AUTH_HEADER_SUBTITLE".localized)
                .font(.title2)
                .bold()
                .foregroundColor(.white)
                .frame(maxWidth: UIScreen.main.bounds.width / 2)
        }
        .padding()
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView(screen: .constant(.auth))
    }
}
