//
//  InfoKeys.swift
//  KameBooks
//
//  Created by Jorge Suárez on 11/2/23.
//

import Foundation

final class InfoKey {
    static let baseUrl: String = infoForKey("baseUrl")!
}

func infoForKey(_ key: String) -> String? {
    return (Bundle.main.infoDictionary?[key] as? String)?
        .replacingOccurrences(of: "\\", with: "")
}

