//
//  File.swift
//  KameBooks
//
//  Created by Jorge Suárez on 11/2/23.
//

import Foundation


final class HomeVM: ObservableObject {
    let persistance = NetworkPersistence.shared
    
    init() {
        Task {
            await getBooksList()
        }
    }
    
    @MainActor func getBooksList() async {
        do {
            let list = try await persistance.getBooksList()
           
        } catch let error as APIErrors {
            print("error \(error.description)")
        } catch {
           print("error")
        }
    }
    
}
