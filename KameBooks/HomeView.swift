//
//  HomeView.swift
//  KameBooks
//
//  Created by Jorge Suárez on 12/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var homeVM = HomeViewModel()
    
    let user = KameBooksKeyChain.shared.user
    var body: some View {
        VStack {
            Text(user?.name ?? "")
            
            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    ForEach(homeVM.featuredList, id: \.book.id) { featuredList in
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
                .padding(.leading)
            }
            .frame(height: 150)
            .background(Color.gold)
            
            List(homeVM.completeList, id: \.book.id) { bookList in
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
            .background(Color.clear)
            .scrollContentBackground(.hidden)
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
