//
//  KameBooksApp.swift
//  KameBooks
//
//  Created by Jorge Suárez on 11/2/23.
//

import SwiftUI

@main
struct KameBooksApp: App {
    var body: some Scene {
        WindowGroup {
           SplashView()
                .environment(\.colorScheme, .light)
        }
    }
}
