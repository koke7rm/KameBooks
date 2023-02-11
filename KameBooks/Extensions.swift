//
//  Extensions.swift
//  KameBooks
//
//  Created by Jorge Suárez on 11/2/23.
//

import SwiftUI

// MARK: - String
// MARK: -
extension String {
    // Variable calculada para copies
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
    
    /// Metodo para quitar los espacios de un String
    func removingWhiteSpaces() -> String {
        components(separatedBy: .whitespaces).joined()
    }

}

// MARK: - UIApplication
// MARK: -
extension UIApplication {
    static var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
}
