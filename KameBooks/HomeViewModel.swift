//
//  HomeViewModel.swift
//  KameBooks
//
//  Created by Jorge Suárez on 13/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import Foundation

struct BooksList: Hashable {
    let book: BookModel
    let author: String
}

final class HomeViewModel: ObservableObject {
    
    let networkPersistance = NetworkPersistence.shared
    
    @Published var completeList: [BooksList] = []
    @Published var filteredList: [BooksList] = []
    @Published var featuredList: [BooksList] = []
    @Published var showNoResults = false
    var authorsList: [AuthorModel] = []
    
    init() {
        Task {
            await getBooksList()
            await getFeaturedBooks()
        }
    }

    @MainActor func getBooksList() async {
        do {
            let booksList = try await networkPersistance.getBooksList()
            authorsList = try await networkPersistance.getAuthors()
            
            booksList.forEach { book in
                let authors = authorsList.filter { $0.id == book.author }.map { $0 }
                authors.forEach { author in
                    completeList.append(BooksList(book: book, author: author.name))
                }
            }
            self.filteredList = self.completeList
        } catch let error as APIErrors {
            print("error \(error.description)")
        } catch {
            print("error")
        }
    }
    
    @MainActor func getFeaturedBooks() async {
        do {
            let booksList = try await networkPersistance.getFeaturedBooks()
            
            booksList.forEach { book in
                let authors = authorsList.filter { $0.id == book.author }.map { $0 }
                authors.forEach { author in
                    featuredList.append(BooksList(book: book, author: author.name))
                }
            }
        } catch let error as APIErrors {
            print("error \(error.description)")
        } catch {
            print("error")
        }
    }
    
    @MainActor func searchBook(word: String) async {
        filteredList.removeAll()
        do {
            let booksList = try await networkPersistance.searchBook(word: word)
            if booksList.isEmpty {
                showNoResults = true
            }
            booksList.forEach { book in
                let authors = authorsList.filter { $0.id == book.author }.map { $0 }
                authors.forEach { author in
                    filteredList.append(BooksList(book: book, author: author.name))
                }
            }
        } catch let error as APIErrors {
            print("error \(error.description)")
        } catch {
            print("error")
        }
    }
}
