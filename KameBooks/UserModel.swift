//
//  UserModel.swift
//  KameBooks
//
//  Created by Jorge Suárez on 12/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import SwiftUI

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

struct UserBookIsReader: Codable {
    let readed: Bool
}

struct UserOrderHistoryModel: Codable, Hashable {
    let orderNumber: String
    let books: [Int]
    let state: String
    let date: String
    
    var orderState: OrderState? {
        OrderState(rawValue: state)
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
    case delivered = "entregado"
    
    var color: Color {
        switch self {
        case .sent:
            return Color.gold
        case .recived:
            return Color.lightGray
        case .delivered:
            return Color.green
        }
    }
}
