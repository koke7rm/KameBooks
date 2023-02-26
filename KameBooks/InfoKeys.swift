//
//  InfoKeys.swift
//  KameBooks
//
//  Created by Jorge Suárez on 11/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import Foundation

final class InfoKey {
    static let baseUrl: String = infoForKey("baseUrl")!
    static let app: String = infoForKey("app")!
}

func infoForKey(_ key: String) -> String? {
    return (Bundle.main.infoDictionary?[key] as? String)?
        .replacingOccurrences(of: "\\", with: "")
}

