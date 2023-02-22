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
    let persistence = ModelPersistence()
    
    // MARK: - Overlays properties
    @Published var loading = false
    @Published var errorMsg = ""
    @Published var errorTitle = ""
    @Published var showErrorAlert = false
    @Published var showSuccessAlert = false
    @Published var showBasketAlert = false
    @Published var orderNumber = ""
    @Published var asReaded = false
    
    let bookDetail: BooksList
    var basketBooks: [BooksList] = []
    
    init(book: BooksList) {
        self.bookDetail = book
        self.basketBooks = persistence.loadBasketBooks()
        Task {
            await userHistory()
        }
    }
    
    @MainActor func createBooksOrder() async {
        guard let email = KameBooksKeyChain.shared.user?.email else { return }
        loading = true
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
            errorTitle = "ERROR_TITLE".localized
            showErrorAlert.toggle()
        case .failure(let error):
            errorTitle = "ERROR_TITLE".localized
            errorMsg = error.localizedDescription
            showErrorAlert.toggle()
        }
        loading = false
        
    }
    
    @MainActor func bookReaded() async {
        guard let email = KameBooksKeyChain.shared.user?.email else { return }
        loading = true
        do {
           _ = try await networkPersistence.postBooksReaded(booksReaded: ReadModel(email: email, books: [bookDetail.book.id]))
            asReaded = true
        } catch let error as APIErrors {
            errorTitle = "ERROR_TITLE".localized
            errorMsg = error.description
            showErrorAlert.toggle()
        } catch {
            errorTitle = "ERROR_TITLE".localized
            errorMsg = error.localizedDescription
            showErrorAlert.toggle()
        }
        loading = false
    }
    
    @MainActor func userHistory() async {
        guard let email = KameBooksKeyChain.shared.user?.email else { return }
        loading = true
        do {
            let userHistory = try await networkPersistence.userHistory(mail: email)
            
            asReaded = userHistory.readed.contains(bookDetail.book.id)

        } catch let error as APIErrors {
            errorTitle = "ERROR_TITLE".localized
            errorMsg = error.description
            showErrorAlert.toggle()
        } catch {
            errorTitle = "ERROR_TITLE".localized
            errorMsg = error.localizedDescription
            showErrorAlert.toggle()
        }
        loading = false
    }
    
    func addBookInBasket(book: BooksList) {
        if !basketBooks.contains(where: { $0.book.id == book.book.id }) {
            basketBooks.append(book)
            persistence.saveBasketBooks(basketBooks: basketBooks)
            showBasketAlert.toggle()
        } else {
            errorTitle = "APP_NAME".localized
            errorMsg = "ERROR_BASKET_BOOK_EXIST".localized
            showErrorAlert.toggle()
        }
    }
}
