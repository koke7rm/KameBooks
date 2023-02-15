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
    @State var navTitle = ["Home", "Favorites"]
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selection) {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                //                .onAppear {
                //                    showSearch = true
                //                }
                    .tag(0)
                Profile()
                    .tabItem {
                        Label("Favorites", systemImage: "heart")
                    }
                //                .onAppear {
                //                    showSearch = false
                //                }
                    .tag(1)
            }
           /// .navigationTitle(navTitle[selection])
            .navigationDestination(for: BooksList.self) { book in
                BookDetailView(bookVM: BookDetailViewModel(book: book))
            }
            .navigationBarTitleDisplayMode(.inline)
                            .toolbarBackground(.red, for: .navigationBar)
                            .toolbarBackground(.visible, for: .navigationBar)
        }

    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}
