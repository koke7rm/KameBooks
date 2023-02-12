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
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                CustomTextField(text: $authVM.name, field: "Name", placeholder: "Bruce Wayne", validation: authVM.validateEmpty)
                    .textInputAutocapitalization(.words)
                    .textContentType(.name)
                CustomTextField(text: $authVM.mail, field: "Email", placeholder: "user@example.com", validation: RegexValidations.shared.validateEmail)
                    .textContentType(.emailAddress)
                CustomTextField(text: $authVM.address, field: "Address", placeholder: "Calle Central, Madrid", validation: authVM.validateEmpty)
                    .textContentType(.streetAddressLine1)
                
                HStack {
                    SimpleButton(text: "Registrarme", foregroundColor: .black, bacgkroundColor: .gold) {
                        Task {
                            await authVM.createUser()
                        }
                    }
                    .opacity(authVM.validateFields() ? 1 : 0.6)
                    .disabled(!authVM.validateFields())
                    
                    SimpleButton(text: "Cancelar", foregroundColor: .black, bacgkroundColor: .gold) {
                        screen = .auth
                    }
                }
                .padding()
            }
            .padding()
        }
        .alert("Registro completado", isPresented: $authVM.showSuccessAlert) {
            Button(action: {
                screen = .auth
            }) {
                Text("CLOSE".localized)
                    .textCase(.uppercase)
            }
        } message: {
            Text("Ya puedes acceder a las ventajas de usuario")
        }
        .alert("Error de registro", isPresented: $authVM.showErrorAlert) {
            Button(action: {}) {
                Text("CLOSE".localized)
                    .textCase(.uppercase)
            }
        } message: {
            Text("No se ha podido completar el registro")
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
        RegisterView(screen: .constant(.register))
    }
}
