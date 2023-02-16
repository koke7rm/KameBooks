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
    
    let networkPersistence = NetworkPersistence.shared
    let persistence = ModelPersistence()

    @Published var userData = KameBooksKeyChain.shared.user
    @Published var name = ""
    @Published var mail = ""
    @Published var address = ""
    @Published var showSuccessAlert = false
    @Published var newPhoto: UIImage?
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
    
    @MainActor func updateuser() async {
 
        Task {
            let task = Task(priority: .utility) {
                try await networkPersistence.updateUser(user: UserModel(name: name, email: mail, location: address) )
            }
            switch await task.result {
            case .success():
                KameBooksKeyChain.shared.user = UserModel(name: name, email: mail, location: address)
                userData = KameBooksKeyChain.shared.user
                showSuccessAlert.toggle()
            case .failure(let error as APIErrors):
                print(error)
            case .failure(let error):
print(error)
            }

        }
    }
    
    func saveData() {
        
        Task {
            await updateuser()
            guard let image = newPhoto, let mail = userData?.email else { return }
            persistence.saveCover(image: image, mail: mail)
        }
    }
    
    /// Método para validar los campos del formulario
    func validateFields() -> Bool {
        if name.isEmpty || address.isEmpty {
            return false
        } else {
            return true
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
