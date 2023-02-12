//
//  KameBooksKeyChain.swift
//  KameBooks
//
//  Created by Jorge Suárez on 12/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import Foundation
import KeychainAccess


protocol ApplicationKeyChain {
    var user: UserModel? { get set }
}

final class KameBooksKeyChain {
    
    private enum Keys {
        static let user = "kameBooks_user"
    }
    
    private let keyChain: Keychain
    static let shared: KameBooksKeyChain = .init()
    
    init() {
        self.keyChain = Keychain(service: "com.kameBooks").accessibility(.whenPasscodeSetThisDeviceOnly)
    }
    
    func deleteUser() {
        try? keyChain.remove(Keys.user)
    }
}

extension KameBooksKeyChain: ApplicationKeyChain {
    
    var user: UserModel? {
        get {
            guard let userData = try? keyChain.getData(Keys.user) else { return nil }
            return try? JSONDecoder().decode(UserModel.self, from: userData)
        }
        set {
            guard let userData = try? JSONEncoder().encode(newValue) else { return }
            try? keyChain.set(userData, key: Keys.user)
        }
    }
}
