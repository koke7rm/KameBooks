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
    let role: String
    
    var roleType: RoleType {
        RoleType(rawValue: role)!
    }
}

enum RoleType: String {
    case user = "usuario"
    case admin = "admin"
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
    let email: String
    
    var orderState: OrderState? {
        OrderState(rawValue: state)
    }
    
    enum CodingKeys: String, CodingKey {
        case books, date, email
        case orderNumber = "npedido"
        case state = "estado"
    }
}

enum OrderState: String, CaseIterable {
    case recived = "recibido"
    case processed = "procesando"
    case sent = "enviado"
    case delivered = "entregado"
    case returned = "devuelto"
    case cancelled = "anulado"
    
    var color: Color {
        switch self {
        case .sent, .processed:
            return Color.gold
        case .recived:
            return Color.lightGray
        case .delivered:
            return Color.green
        case .cancelled, .returned:
            return Color.red
        }
    }
}

struct OrderStateRequest: Codable {
    let id: String
    let state: String
    let admin: String
    
    enum CodingKeys: String, CodingKey {
        case id, admin
        case state = "estado"
    }
}
