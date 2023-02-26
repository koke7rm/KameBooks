//
//  LoginWorker.swift
//  KameBooks_Workers
//
//  Created by Jorge Suárez on 26/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import SwiftUI

struct LoginWorker: View {
    
    @ObservedObject var authVM = AuthViewModel()
    
    @Binding var screen: Screens
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient.mainGradient, startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack {
                CustomTextField(text: $authVM.mail, field: "", placeholder: "AUTH_MAIL_PLACEHOLDER".localized, validation: RegexValidations.shared.validateEmail)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                HStack {
                    SimpleButton(text: "CONTINUE".localized, foregroundColor: .white, backroundColor: .blackLight) {
                        Task {
                            await authVM.checkWorker()
                        }
                    }
                    .opacity(authVM.validateMail() ? 1 : 0.6)
                    .disabled(!authVM.validateMail())
                }
                .padding()
            }
            .padding()
        }
        .alert("AUTH_LOGIN_SUCCESS".localized, isPresented: $authVM.showSuccessAlert) {
            Button(action: {
                screen = .homeWorker
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

struct LoginWorker_Previews: PreviewProvider {
    static var previews: some View {
        LoginWorker(screen: .constant(.loginWorker))
    }
}
