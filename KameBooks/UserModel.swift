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

struct UserReadedHistoryModel: Codable {
    let books: [Int]
}

struct UserOrderHistoryModel: Codable, Hashable {
    let orderNumber: String
    let books: [Int]
    let state: String
    let date: String
    
    var orderState: OrderState? {
        OrderState(rawValue: state)
    }
    
    var formatDate: String {
        date.toDate()?.formatDateString ?? "-"
    }
    
    enum CodingKeys: String, CodingKey {
        case books, date
        case orderNumber = "npedido"
        case state = "estado"
    }
}

enum OrderState: String {
    case sent = "enviado"
    case recived = "recibido"
}
