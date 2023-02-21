//
//  CartViewModel.swift
//  KameBooks
//
//  Created by Jorge Suárez on 20/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import Foundation

final class CartViewModel: ObservableObject {
    
    let networkPersistence = NetworkPersistence.shared
    let persistence = ModelPersistence()
    
    @Published var basketBooks: [BooksList] = []
    @Published var loading = false
    @Published var errorMsg = ""
    @Published var showErrorAlert = false
    @Published var showSuccessAlert = false
    @Published var orderNumber = ""
    
    init() {
        self.basketBooks = persistence.loadBasketBooks()
    }
    
    @MainActor func createBooksOrder() async {
        loading = true
        guard let email = KameBooksKeyChain.shared.user?.email else { return }
        
        let booksIds = basketBooks.map { $0.book.id }
        
        let task = Task(priority: .utility) {
            return try await networkPersistence.createBooksOrder(order: OrderModel(email: email, order: booksIds))
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
    
    func removeBasketBook(bookId: Int) {
        basketBooks.removeAll(where: { $0.book.id == bookId })
        persistence.saveBasketBooks(basketBooks: basketBooks)
    }
    
    func removeBasketBookOffset(offsets: IndexSet) {
        let booksToDelete = offsets.map { basketBooks[$0] }
        booksToDelete.forEach { book in
            removeBasketBook(bookId: book.book.id)
        }
        persistence.saveBasketBooks(basketBooks: basketBooks)
    }
    
    func finalizePurchase() {
        basketBooks.removeAll()
        persistence.saveBasketBooks(basketBooks: basketBooks)
        showSuccessAlert = false
    }
}
