//
//  KameBooksApp.swift
//  KameBooks
//
//  Created by Jorge Suárez on 11/2/23.
//

import SwiftUI

@main
struct KameBooksApp: App {
    
    @StateObject var homeVM = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
           SplashView()
                .environment(\.colorScheme, .light)
        }
    }
}
