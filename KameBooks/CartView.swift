//
//  CartView.swift
//  KameBooks
//
//  Created by Jorge Suárez on 20/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import SwiftUI

struct CartView: View {
    
    @ObservedObject var cartVM = CartViewModel()
    @Binding var tabBarSelection: Int
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient.mainGradient, startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            if !cartVM.basketBooks.isEmpty {
                VStack {
                    SimpleButton(text: "Realizar pedido", foregroundColor: .blackLight, backroundColor: .gold) {
                        Task {
                            await cartVM.createBooksOrder()
                        }
                    }
                    .padding(.top)
                    List {
                        ForEach(cartVM.basketBooks, id: \.book.id) { book in
                            HStack(alignment: .center) {
                                AsyncImage(url: book.book.cover) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                } placeholder: {
                                    Image("img_placeholder")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                }
                                VStack(spacing: 8) {
                                    Text(book.book.title)
                                        .bold()
                                    Text(book.author)
                                    Spacer()
                                    Button(role: .destructive) {
                                        cartVM.removeBasketBook(bookId: book.book.id)
                                    } label: {
                                        Image(systemName: "trash.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 30, height: 30)
                                    }
                                    .frame(maxWidth: .infinity,alignment: .trailing)
                                }
                                .padding()
                            }
                            .padding()
                        }
                        .onDelete(perform: cartVM.removeBasketBookOffset)
                    }
                    .scrollContentBackground(.hidden)
                }
                .padding()
            } else {
                Text("Tu cesta está vacía")
            }
        }
        .onAppear {
            cartVM.basketBooks = cartVM.persistence.loadBasketBooks()
        }
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView(tabBarSelection: .constant(2))
    }
}
