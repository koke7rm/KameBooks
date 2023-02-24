//
//  ProfileViewModel.swift
//  KameBooks
//
//  Created by Jorge Suárez on 16/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import SwiftUI
import PhotosUI

final class ProfileViewModel: ObservableObject {
    
    let networkPersistance = NetworkPersistence.shared
    let persistence = ModelPersistence()
    
    @Published var userData = KameBooksKeyChain.shared.user
    @Published var name = ""
    @Published var mail = ""
    @Published var address = ""
    @Published var loading = false
    @Published var errorMsg = ""
    @Published var showErrorAlert = false
    @Published var showSuccessAlert = false
    @Published var newPhoto: UIImage?
    @Published var userHistory: UserHistoryModel?
    @Published var photoItem: PhotosPickerItem? {
        didSet {
            Task { await transferPhoto() }
        }
    }
    
    init() {
        name = KameBooksKeyChain.shared.user?.name ?? ""
        mail = KameBooksKeyChain.shared.user?.email ?? ""
        address = KameBooksKeyChain.shared.user?.location ?? ""
        newPhoto = persistence.loadCover(mail: userData?.email ?? "")
    }
    
    @MainActor func updateUser() async {
        loading = true
        let task = Task(priority: .utility) {
            try await networkPersistance.updateUser(user: UserModel(name: name, email: mail, location: address) )
        }
        switch await task.result {
        case .success(_):
            KameBooksKeyChain.shared.user = UserModel(name: name, email: mail, location: address)
            userData = KameBooksKeyChain.shared.user
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
    
    @MainActor func userHistory() async {
        guard let email = KameBooksKeyChain.shared.user?.email else { return }
        loading = true
        do {
            userHistory = try await networkPersistance.userHistory(mail: email)
        } catch let error as APIErrors {
            errorMsg = error.description
            showErrorAlert.toggle()
        } catch {
            errorMsg = error.localizedDescription
            showErrorAlert.toggle()
        }
        loading = false
    }
    
    func saveData() async {
            await updateUser()
            guard let image = newPhoto, let mail = userData?.email else { return }
            persistence.saveCover(image: image, mail: mail)
    }
    
    /// Método para validar los campos del formulario
    func validateFields() -> Bool {
        if name.isEmpty || address.isEmpty {
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
    
    
    /// Método para cargar una imagen de la galería
    func transferPhoto() async {
        guard let photoItem else { return }
        do {
            if let result = try await photoItem.loadTransferable(type: Data.self),
               let image = UIImage(data: result) {
                let scale = 300 / image.size.width
                let height = image.size.height * scale
                let resized = await image.byPreparingThumbnail(ofSize: CGSize(width: 300, height: height))
                await MainActor.run {
                    newPhoto = resized
                }
            }
        } catch {
            print("Error en la carga de la imagen \(error)")
        }
    }
}
