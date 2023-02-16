//
//  NetworkInterface.swift
//  KameBooks
//
//  Created by Jorge Suárez on 11/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import SwiftUI

enum NetworkInterface {
    case getBooksList
    case createUser(user: UserModel)
    case updateUser(user: UserModel)
    case checkUser(mail: String)
    case getAuthors
    case getFeaturedBooks
    case searchbook(word: String)
    case createBookOrer(orderData: OrderModel)
    case postBooksRead(readsData: OrderModel)
}

extension NetworkInterface {
    
    var baseURL: String {
        switch self {
        case .getBooksList,
                .createUser,
                .checkUser,
                .getAuthors,
                .getFeaturedBooks,
                .searchbook,
                .createBookOrer,
                .postBooksRead,
                .updateUser:
            return InfoKey.baseUrl
        }
    }
    
    var path: String {
        switch self {
        case .getBooksList:
            return "/api/books/list"
        case .createUser, .updateUser:
            return "/api/client"
        case .checkUser:
            return "/api/client/query"
        case .getAuthors:
            return "/api/books/authors"
        case .getFeaturedBooks:
            return "/api/books/latest"
        case .searchbook(let word):
            return "/api/books/find/\(word)"
        case .createBookOrer:
            return "/api/shop/newOrder"
        case .postBooksRead:
            return "/api/client/readQuery"

        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getBooksList,
                .getAuthors,
                .getFeaturedBooks,
                .searchbook:
            return .get
        case .createUser,
                .checkUser,
                .createBookOrer,
                .postBooksRead:
            return .post
        case .updateUser:
            return .put
        }
    }
    
    var query: [URLQueryItem]? {
        switch self {
        default:
            return nil
        }
    }
    
    var body: Data? {
        switch self {
        case .createUser(let user), .updateUser(let user):
            let dto = user
            return try? JSONEncoder().encode(dto)
        case .checkUser(let mail):
            return try? JSONEncoder().encode(["email" : mail])
        case .createBookOrer(let orderData):
            let dto = orderData
            return try? JSONEncoder().encode(dto)
        case .postBooksRead(let readsData):
            let dto = readsData
            return try? JSONEncoder().encode(dto)
        default:
            return nil
        }
    }
    
    var headers: [String: String]? {
        var header = NetworkInterface.defaultHeaders
        if let body {
            header["Content-Length"] = "\(body.count)"
        }
        switch self {
            
        default: ()
        }
        return header
    }
    
    private static var defaultHeaders: [String: String] {
        let device = UIDevice.current
        return [
            "Accept": "application/json",
            "Content-Type": "application/json",
            "appVersion": UIApplication.appVersion ?? "",
            "brand": device.model,
            "model": device.type.rawValue,
            "os": device.systemName,
            "osVersion": device.systemVersion
        ]
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

extension URLRequest {
    static func request(networkRequest: NetworkInterface) -> URLRequest {
        var bodyString = ""
        var comps = URLComponents(string: networkRequest.baseURL)
        comps?.path = networkRequest.path
        var request = URLRequest(url: (comps?.url)!)
        if let query = networkRequest.query {
            comps?.queryItems = query
        }
        if let body = networkRequest.body {
            request.httpBody = body
            bodyString = String(data: networkRequest.body!, encoding: .utf8) ?? ""
        }
        request.httpMethod = networkRequest.method.rawValue
        request.allHTTPHeaderFields = networkRequest.headers
        print("💡 Headers: \(request.allHTTPHeaderFields ?? ["":""])")
        print("🚀", networkRequest.method.rawValue, comps?.url ?? "", networkRequest.query ?? "", bodyString)
        return request
    }
}

