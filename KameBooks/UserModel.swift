//
//  UserModel.swift
//  KameBooks
//
//  Created by Jorge Suárez on 12/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import Foundation

struct UserModel: Codable {
    let name: String
    let email: String
    let location: String
}

struct UserHistoryModel: Codable {
    let readed: [Int]
    let ordered: [Int]
}
