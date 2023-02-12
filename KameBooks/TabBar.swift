//
//  TabBar.swift
//  KameBooks
//
//  Created by Jorge Suárez on 12/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import SwiftUI

struct TabBar: View {
    
    @State var selection = 0
    
    var body: some View {
        TabView(selection: $selection) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
//                .onAppear {
//                    showSearch = true
//                }
                .tag(0)
            HomeView()
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                }
//                .onAppear {
//                    showSearch = false
//                }
                .tag(1)
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}
