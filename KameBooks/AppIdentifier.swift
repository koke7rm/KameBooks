//
//  AppIdentifier.swift
//  KameBooks
//
//  Created by Jorge Suárez on 26/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import Foundation

class AppIdentifier: NSObject {
    
    enum AppIdentifierEnum: String {
        case users = "KameBooks"
        case workers = "KameWorkers"
    }
    
    var identifier: AppIdentifierEnum = .users
    
    static let shared = AppIdentifier()
    
    // método de inicio con el que comprobaremos en que app estamos
    func initAppIdentifier() {
        self.identifier = AppIdentifierEnum.init(rawValue: InfoKey.app)!
    }
}
