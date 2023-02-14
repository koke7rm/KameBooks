//
//  BookDetailViewModel.swift
//  KameBooks
//
//  Created by Jorge Suárez on 14/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import Foundation


final class BookDetailViewModel: ObservableObject {
    
    let bookDetail: BooksList
    
    init(book: BooksList) {
        self.bookDetail = book
    }
}
