//
//  HomeView.swift
//  KameBooks
//
//  Created by Jorge Suárez on 12/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var homeVM: HomeViewModel
    
    @State var userName = ""
    
    var body: some View {
        VStack {
            CustomSearchBar(searchText: $homeVM.searchText, showSearch: $homeVM.showSearch, placeHolder: "HOME_SEARCH_PLACEHOLDER".localized) {
                Task(priority: .userInitiated) {
                    await homeVM.searchBook(word: homeVM.searchText)
                }
            }
            Text(String(format: "HOME_WELLCOME_USER".localized, userName))
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            featuredBooksSection
            
            List(homeVM.filteredList, id: \.book.id) { bookList in
                NavigationLink(value: bookList) {
                    BookCell(homeVM: homeVM, bookList: bookList)
                }
            }
            .listStyle(.sidebar)
            .background(Color.blackLight)
            .scrollContentBackground(.hidden)
            .overlay {
                noResults
            }
        }
        .navigationDestination(for: BooksList.self) { book in
            BookDetailView(bookVM: BookDetailViewModel(book: book))
        }
        .onAppear {
            userName = KameBooksKeyChain.shared.user?.name ?? "GUEST".localized
        }
        .alert("ERROR_TITLE".localized, isPresented: $homeVM.showErrorAlert) {
            Button(action: {}) {
                Text("CLOSE".localized)
                    .textCase(.uppercase)
            }
        } message: {
            Text(homeVM.errorMsg)
        }
        .overlay {
            if homeVM.loading {
                LoaderView()
                    .transition(.opacity)
            }
        }
    }
    
    var featuredBooksSection: some View {
        VStack {
            Text("HOME_FEATURE_LIST_TITLE".localized)
                .textCase(.uppercase)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(homeVM.featuredList, id: \.book.id) { featuredList in
                        NavigationLink(value: featuredList) {
                            LazyHGrid(rows: [GridItem(.adaptive(minimum: 180))]) {
                                AsyncImage(url: featuredList.book.cover) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .cornerRadius(8)
                                        .frame(width: 110, height: 140)
                                    
                                } placeholder: {
                                    Image("img_placeholder")
                                        .resizable()
                                        .scaledToFit()
                                        .cornerRadius(8)
                                        .frame(width: 110, height: 140)
                                }
                            }
                        }
                    }
                }
                .padding(.leading)
            }
            .frame(height: 150)
            .background(Color.gold)
        }
    }
    
    var noResults: some View {
        VStack {
            Image(systemName: "magnifyingglass")
            Text("HOME_NO_RESULTS".localized)
        }
        .opacity(homeVM.showNoResults ? 1 : 0)
    }
}

struct HomeView_Previews: PreviewProvider {
    static let vm = HomeViewModel()
    static var previews: some View {
        HomeView()
            .environmentObject(vm)
            .task {
                await vm.getBooksList()
            }
    }
}
