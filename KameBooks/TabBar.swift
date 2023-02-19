//
//  TabBar.swift
//  KameBooks
//
//  Created by Jorge Suárez on 12/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import SwiftUI

struct TabBar: View {
    
    @Binding var screen: Screens
    @State var selection = 0
    
    init(screen: Binding<Screens>) {
        self._screen = screen
        UITabBar.appearance().backgroundColor = UIColor(Color.gold)
    }
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selection) {
                HomeView()
                    .tabItem {
                        Label("TABBAR_HOME".localized, systemImage: "house")
                    }
                    .tag(0)
                Profile(screen: $screen)
                    .tabItem {
                        Label("TABBAR_PROFILE".localized, systemImage: "person.fill")
                            .foregroundColor(.red)
                    }
                    .tag(1)
            }
            .tint(.black)
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar(screen: .constant(.home))
    }
}
