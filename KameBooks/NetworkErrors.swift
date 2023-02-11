//
//  NetworkErrors.swift
//  KameBooks
//
//  Created by Jorge Suárez on 11/2/23.
//

import Foundation

enum APIErrors: Error {
    case general
    case json
    case nonHTTP
    case status(Int)
    case invalidData
    
    var description: String {
        switch self {
        case .general:
            return "\("ERROR_GENERAL".localized) \("ERROR_MESSAGE_DEFAULT".localized)"
        case .json:
            return "\("ERROR_JSON".localized) \("ERROR_MESSAGE_DEFAULT".localized)"
        case .nonHTTP:
            return "\("ERROR_HTTP".localized) \("ERROR_MESSAGE_DEFAULT".localized)"
        case .status(let int):
            return "\("ERROR_STATUS".localized) \(int)"
        case .invalidData:
            return "ERROR_INVALID_DATA".localized
        }
    }
}

struct DefaultError: LocalizedError {
    var messageDefault: String
}

struct APIErrorCodeMessage: LocalizedError, Codable {
    var code: String?
    var message: String?
}

