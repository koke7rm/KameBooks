//
//  HomeView.swift
//  KameBooks
//
//  Created by Jorge Suárez on 12/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var homeVM = HomeViewModel()
    @State var searchText = ""
    @State var showCancel = false
    @FocusState var focusField: Bool
    
    let user = KameBooksKeyChain.shared.user
    
    var body: some View {
            VStack {
                HStack {
                    TextField("Buscar...", text: $searchText)
                        .textFieldStyle(CustomRounderedTextFieldStyle())
                        .focused($focusField)
                        .onChange(of: searchText) { text in
                            if text.isEmpty {
                                showCancel = false
                                homeVM.showNoResults = false
                                homeVM.filteredList = homeVM.completeList
                            } else if text.count >= 3 {
                                withAnimation {
                                    showCancel = true
                                }
                                Task {
                                    await homeVM.searchBook(word: text)
                                }
                            }
                        }
                    if showCancel {
                        Button {
                            withAnimation {
                                focusField = false
                                searchText = ""
                            }
                            
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gold)
                                .frame(width: 30, height: 30)
                        }
                    }
                }
                .padding()
                .background(Color.blackLight)
                
                Text("Hola \(user?.name ?? "Invitado")")
                    .font(.headline)
                    .padding(.bottom)
                Text("Libros destacados")
  
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
                
                List(homeVM.filteredList, id: \.book.id) { bookList in
                    NavigationLink(value: bookList) {
                        HStack {
                            Rectangle()
                                .foregroundColor(.gold)
                                .frame(width: 130, height: 200)
                                .overlay {
                                    AsyncImage(url: bookList.book.cover) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 110, height: 200)
                                    } placeholder: {
                                        Image("img_placeholder")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 100, height: 100)
                                    }
                                }
                            
                            VStack(alignment: .leading) {
                                Text(bookList.book.title)
                                    .font(.headline)
                                Text(bookList.author)
                                    .font(.callout)
                                Spacer()
                                Text("Publicado en: \(bookList.book.year?.formatted().replaceDecimal ?? "-")")
                                    .padding(.bottom)
                                
                            }
                            .padding(.top)
                        }
                    }
                }
                .navigationTitle("Scores")
                .listStyle(.sidebar)
                            .background(Color.blackLight)
                           .scrollContentBackground(.hidden)
                .overlay {
                    VStack {
                        Image(systemName: "magnifyingglass")
                        Text("No se encontraron resultados")
                    }
                    .opacity(homeVM.showNoResults ? 1 : 0)
                }
            }
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
