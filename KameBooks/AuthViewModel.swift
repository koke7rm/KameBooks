//
//  AuthViewModel.swift
//  KameBooks
//
//  Created by Jorge Suárez on 12/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import Foundation


final class AuthViewModel: ObservableObject {
    
    let networkPersistance = NetworkPersistence.shared
    
    @Published var name = ""
    @Published var mail = ""
    @Published var address = ""
    
    // MARK: - Overlays properties
    @Published var loading = false
    @Published var errorMsg = ""
    @Published var showErrorAlert = false
    @Published var showSuccessAlert = false
    
    /// Método para validar los campos del formulario
    func validateFields() -> Bool {
        if name.isEmpty || mail.isEmpty || address.isEmpty || !validateMail() {
            return false
        } else {
            return true
        }
    }
    
    func validateEmpty(value: String) -> String? {
        if value.isEmpty {
            return "ERROR_FIELD_EMPTY".localized
        } else {
            return nil
        }
    }
    
    /// Método para validar campo email del formulario
    func validateMail() -> Bool {
        if RegexValidations.shared.validateEmail(email: mail) == nil {
            return true
        }
        return false
    }
    
    /// Método para crear un usuario
    @MainActor func createUser() async {
        loading = true
        Task {
            let task = Task(priority: .utility) {
                return try await networkPersistance.createUser(user:UserModel(name: name, email: mail, location: address))
            }
            switch await task.result {
            case .success():
                showSuccessAlert.toggle()
            case .failure(let error as APIErrors):
                errorMsg = error.description
                showErrorAlert.toggle()
            case .failure(let error):
                errorMsg = error.localizedDescription
                showErrorAlert.toggle()
            }
            loading = false
        }
    }
    
    /// Método para comprobar si el usuario existe y obtener sus datos
    @MainActor func checkUser() async {
        loading = true
        Task {
            let task = Task(priority: .utility) {
                return try await networkPersistance.checkUser(mail: mail)
            }
            switch await task.result {
            case .success(let response):
                print(response)
                KameBooksKeyChain.shared.user = response
                showSuccessAlert.toggle()
            case .failure(let error as APIErrorCodeMessage):
                errorMsg = error.reason ?? "No hemos podido"
                showErrorAlert.toggle()
            case .failure(let error):
                errorMsg = error.localizedDescription
                showErrorAlert.toggle()
            }
            loading = false
        }
    }
}
