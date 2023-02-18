//
//  RegisterView.swift
//  KameBooks
//
//  Created by Jorge Suárez on 12/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import SwiftUI

struct RegisterView: View {
    
    @ObservedObject var authVM = AuthViewModel()
    
    @Binding var screen: Screens
    @Binding var authStep: AuthStep
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                CustomTextField(text: $authVM.name, field: "NAME".localized, placeholder: "AUTH_NAME_PLACEHOLDER".localized, validation: authVM.validateEmpty)
                    .textInputAutocapitalization(.words)
                    .textContentType(.name)
                CustomTextField(text: $authVM.mail, field: "EMAIL".localized, placeholder: "AUTH_MAIL_PLACEHOLDER".localized, validation: RegexValidations.shared.validateEmail)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                CustomTextField(text: $authVM.address, field: "ADDRESS".localized, placeholder: "AUTH_ADDRESS_PLACEHOLDER".localized, validation: authVM.validateEmpty)
                    .textContentType(.streetAddressLine1)
                
                HStack {
                    SimpleButton(text: "CONTINUE".localized, foregroundColor: .white, backroundColor: .blackLight) {
                        Task {
                            await authVM.createUser()
                        }
                    }
                    .opacity(authVM.validateFields() ? 1 : 0.6)
                    .disabled(!authVM.validateFields())
                    
                    SimpleButton(text: "CANCEL".localized, foregroundColor: .white, backroundColor: .blackLight) {
                        authStep = .auth
                    }
                }
                .padding()
            }
            .padding()
        }
        .alert("AUTH_REGISTER_SUCCESS".localized, isPresented: $authVM.showSuccessAlert) {
            Button(action: {
                authStep = .login
            }) {
                Text("CLOSE".localized)
                    .textCase(.uppercase)
            }
        } message: {
            Text("AUTH_REGISTER_SUCCESS_MESSAGE".localized)
        }
        .alert("AUTH_REGISTER_ERROR".localized, isPresented: $authVM.showErrorAlert) {
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

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(screen: .constant(.auth), authStep: .constant(.register))
    }
}
