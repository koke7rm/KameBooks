//
//  Extensions.swift
//  KameBooks
//
//  Created by Jorge Suárez on 11/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
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
    
    func toDate(withFormat format: String = "yyyy-MM-dd'T'HH:mm:ssZ") -> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        return date
    }
}

// MARK: - Color
// MARK: -
extension Color {
    static let blueMain = Color("blue_main")
    static let gold = Color("gold")
    static let lightGray = Color("lightGray")
    static let blackLight = Color("blackLight")
}

extension Gradient {
    static let mainGradient = Gradient(colors: [.blackLight, .gold, .white])
}

// MARK: - UIApplication
// MARK: -
extension UIApplication {
    static var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
}

extension Date {
    var showOnlyYear: String {
        self.formatted(.dateTime.year())
    }
    
    var formatDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy, HH:mm"
        return formatter.string(from: self)
    }
}

extension Image {
    func setImageScore(rating: Double, tag: Int) -> Image {
        if tag > Int(rating) {
            return Image(systemName: "star")
        } else {
            return Image(systemName: "star.fill")
        }
    }
}
