//
//  TabBar.swift
//  KameBooks
//
//  Created by Jorge Suárez on 12/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import SwiftUI

struct TabBar: View {
    
    @StateObject var homeVM = HomeViewModel()
    
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
                    .environmentObject(homeVM)
                    .tabItem {
                        Label("TABBAR_HOME".localized, systemImage: "house")
                    }
                    .tag(0)
                HistoryOrdersView()
                    .environmentObject(homeVM)
                    .tabItem {
                        Label("TABBAR_ORDERS".localized, systemImage: "shippingbox.fill")
                    }
                    .tag(1)
                Profile(screen: $screen, booksOrderCount: homeVM.orderedList.count)
                    .tabItem {
                        Label("TABBAR_PROFILE".localized, systemImage: "person.fill")
                            .foregroundColor(.red)
                    }
                    .tag(2)
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
