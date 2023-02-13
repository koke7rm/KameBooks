//
//  BookModel.swift
//  KameBooks
//
//  Created by Jorge Suárez on 11/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import Foundation

struct BookModel: Codable, Identifiable, Hashable {
    let id: Int
    let title: String
    let cover: URL?
    let year: Int?
    let rating: Double?
    let summary: String?
    let author: String?
    
}
