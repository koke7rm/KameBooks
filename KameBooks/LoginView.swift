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
                CustomTextField(text: $authVM.mail, field: "", placeholder: "user@example.com", validation: RegexValidations.shared.validateEmail)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                HStack {
                    SimpleButton(text: "Iniciar", foregroundColor: .black, bacgkroundColor: .gold) {
                        Task {
                            await authVM.checkUser()
                        }
                    }
                    .opacity(authVM.validateMail() ? 1 : 0.6)
                    .disabled(!authVM.validateMail())
                    
                    SimpleButton(text: "Cancelar", foregroundColor: .black, bacgkroundColor: .gold) {
                        authStep = .auth
                    }
                }
                .padding()
            }
        }
        .alert("¡Hola de nuevo!", isPresented: $authVM.showSuccessAlert) {
            Button(action: {
                authStep = .auth
                screen = .home
            }) {
                Text("CLOSE".localized)
                    .textCase(.uppercase)
            }
        } message: {
            Text("Te estabamos esperando")
        }
        .alert("Error de sesión", isPresented: $authVM.showErrorAlert) {
            Button(action: {}) {
                Text("CLOSE".localized)
                    .textCase(.uppercase)
            }
        } message: {
            Text("No se ha podido completar el login")
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
