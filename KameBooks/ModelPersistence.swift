//
//  ModelPersistence.swift
//  KameBooks
//
//  Created by Jorge Suárez on 16/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import SwiftUI

final class ModelPersistence {
    
    func saveCover(image: UIImage, mail: String) {
        let url = URL.documentsDirectory.appending(path: "cover\(mail).jpg")
        if let data = image.jpegData(compressionQuality: 0.7) {
            do {
                try data.write(to: url, options: [.atomic, .completeFileProtection])
            } catch {
                print("Error grabando la imagen \(mail) \(error)")
            }
        }
    }
    
    func loadCover(mail: String) -> UIImage? {
        let url = URL.documentsDirectory.appending(path: "cover\(mail).jpg")
        if FileManager.default.fileExists(atPath: url.path()) {
            do {
                let data = try Data(contentsOf: url)
                return UIImage(data: data)
            } catch {
                print("Error en la carga de la imagen \(mail) \(error)")
            }
        }
        return nil
    }
}
