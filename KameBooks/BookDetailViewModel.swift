//
//  BookDetailViewModel.swift
//  KameBooks
//
//  Created by Jorge Suárez on 14/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import SwiftUI


final class BookDetailViewModel: ObservableObject {
    
    let networkPersistence = NetworkPersistence.shared
    
    // MARK: - Overlays properties
    @Published var loading = false
    @Published var errorMsg = ""
    @Published var showErrorAlert = false
    @Published var showSuccessAlert = false
    @Published var orderNumber = ""
    
    let bookDetail: BooksList
    
    init(book: BooksList) {
        self.bookDetail = book
    }
    
    @MainActor func createBooksOrder() async {
        loading = true
        guard let email = KameBooksKeyChain.shared.user?.email else { return }
        Task {
            let task = Task(priority: .utility) {
                return try await networkPersistence.createBooksOrder(order: OrderModel(email: email, order: [bookDetail.book.id]))
            }
            switch await task.result {
            case .success(let res):
                orderNumber = res.orderNumber
                showSuccessAlert.toggle()
            case .failure(let error as APIErrors):
                print(error)
                errorMsg = error.description
                showErrorAlert.toggle()
            case .failure(let error):
                errorMsg = error.localizedDescription
                showErrorAlert.toggle()
            }
            loading = false
        }
    }
    
    @MainActor func bookReaded() async {
        loading = true
        guard let email = KameBooksKeyChain.shared.user?.email else { return }
        do {
            try await networkPersistence.postBooksReaded(booksReaded: OrderModel(email: email, order: [bookDetail.book.id]))
        } catch let error as APIErrors {
            errorMsg = error.description
            showErrorAlert.toggle()
        } catch {
            errorMsg = error.localizedDescription
            showErrorAlert.toggle()
        }
        loading = false
    }
}
