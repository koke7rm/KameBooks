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
    @Published var featuredList: [BooksList] = []
    @Published var searchText = ""
    var authorsList: [AuthorModel] = []
    
    init() {
        Task {
            await getBooksList()
            await getFeaturedBooks()
        }
    }
    
    var filterBooks: [BooksList] {
        if searchText.isEmpty {
            return completeList
        } else {
            return completeList.filter {
                $0.book.title.lowercased().hasPrefix(searchText.lowercased())
            }
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
}
