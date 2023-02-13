//
//  AuthorModel.swift
//  KameBooks
//
//  Created by Jorge Suárez on 13/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import Foundation

struct AuthorModel: Codable, Identifiable, Hashable {
    let id: String
    let name: String
}
