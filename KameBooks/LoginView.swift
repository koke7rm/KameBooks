//
//  LoginView.swift
//  KameBooks
//
//  Created by Jorge Suárez on 12/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    
    @ObservedObject var authVM = AuthViewModel()
    
    @Binding var screen: Screens
    @Binding var authStep: AuthStep
    
    var body: some View {
        ZStack {
            VStack {
                CustomTextField(text: $authVM.mail, field: "", placeholder: "AUTH_MAIL_PLACEHOLDER".localized, validation: RegexValidations.shared.validateEmail)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                HStack {
                    SimpleButton(text: "CONTINUE".localized, foregroundColor: .white, bacgkroundColor: .blackLight) {
                        Task {
                            await authVM.checkUser()
                        }
                    }
                    .opacity(authVM.validateMail() ? 1 : 0.6)
                    .disabled(!authVM.validateMail())
                    
                    SimpleButton(text: "CANCEL".localized, foregroundColor: .white, bacgkroundColor: .blackLight) {
                        authStep = .auth
                    }
                }
                .padding()
            }
        }
        .alert("AUTH_LOGIN_SUCCESS".localized, isPresented: $authVM.showSuccessAlert) {
            Button(action: {
                authStep = .auth
                screen = .home
            }) {
                Text("CLOSE".localized)
                    .textCase(.uppercase)
            }
        } message: {
            Text("AUTH_LOGIN_SUCCESS_MESSAGE".localized)
        }
        .alert("AUTH_LOGIN_ERROR".localized, isPresented: $authVM.showErrorAlert) {
            Button(action: {}) {
                Text("CLOSE".localized)
                    .textCase(.uppercase)
            }
        } message: {
            Text(authVM.errorMsg)
        }
        .overlay {
            if authVM.loading {
                LoaderView()
                    .transition(.opacity)
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(screen: .constant(.auth), authStep: .constant(.login))
    }
}
