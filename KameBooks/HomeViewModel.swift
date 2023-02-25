//
//  HomeViewModel.swift
//  KameBooks
//
//  Created by Jorge Suárez on 13/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import SwiftUI

final class HomeViewModel: ObservableObject {
    
    let networkPersistance = NetworkPersistence.shared
    
    @Published var completeList: [BooksList] = []
    @Published var orderedList: [OrderList] = []
    @Published var filteredList: [BooksList] = []
    @Published var featuredList: [BooksList] = []
    @Published var showNoResults = false
    @Published var showSearch = false
    @Published var loading = false
    @Published var errorMsg = ""
    @Published var showErrorAlert = false
    @Published var searchText = "" {
        didSet {
            searchTextActions(searchText)
        }
    }
    
    var authorsList: [AuthorModel] = []
    
    init() {
        completeList.reserveCapacity(1000)
        Task {
            await getBooksList()
            await getFeaturedBooks()
            await userOrderHistory()
        }
    }
    
    func searchTextActions(_ text: String) {
        if text.isEmpty {
            showNoResults = false
            filteredList = completeList
            showSearch = false
        } else {
            withAnimation {
                showSearch = true
            }
        }
    }
    
    @MainActor func getBooksList() async {
        loading = true
        do {
            let booksList = try await networkPersistance.getBooksList()
            authorsList = try await networkPersistance.getAuthors()
            
            let bookAuthor = booksList.compactMap { book in
                authorsList.first { $0.id == book.author }.map { author in
                    BooksList(book: book, author: author.name)
                }
            }
            self.completeList = bookAuthor.sorted(by: {$0.book.id < $1.book.id})
            self.filteredList = self.completeList
            
        } catch let error as APIErrors {
            errorMsg = error.description
            showErrorAlert.toggle()
        } catch {
            errorMsg = error.localizedDescription
            showErrorAlert.toggle()
        }
        loading = false
    }
    
    @MainActor func getFeaturedBooks() async {
        loading = true
        do {
            let booksList = try await networkPersistance.getFeaturedBooks().sorted { $0.title < $1.title }
            
            let bookAuthor = booksList.compactMap { book in
                authorsList.first { $0.id == book.author }.map { author in
                    BooksList(book: book, author: author.name)
                }
            }
            featuredList = bookAuthor
            
        } catch let error as APIErrors {
            errorMsg = error.description
            showErrorAlert.toggle()
        } catch {
            errorMsg = error.localizedDescription
            showErrorAlert.toggle()
        }
        loading = false
    }
    
    @MainActor func searchBook(word: String) async {
        loading = true
        showNoResults = false
        filteredList.removeAll(keepingCapacity: true)
        do {
            let booksList = try await networkPersistance.searchBook(word: word)
            if booksList.isEmpty {
                showNoResults = true
            }
            let bookAuthor = booksList.compactMap { book in
                authorsList.first { $0.id == book.author }.map { author in
                    BooksList(book: book, author: author.name)
                }
            }
            filteredList = bookAuthor
            
        } catch let error as APIErrors {
            errorMsg = error.description
            showErrorAlert.toggle()
        } catch {
            errorMsg = error.localizedDescription
            showErrorAlert.toggle()
        }
        loading = false
    }
    
    @MainActor func userOrderHistory() async {
        guard let email = KameBooksKeyChain.shared.user?.email else { return }
        loading = true
        do {
            let orderHistoryList = try await networkPersistance.userOrderHistory(mail: email)
            
            orderedList = orderHistoryList.map { userHistory in
                let booksList = completeList.filter { userHistory.books.contains($0.book.id) }
                return OrderList(book: booksList, orderData: userHistory)
            }
            .reversed()
            
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
