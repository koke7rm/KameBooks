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
                basketBooksList
            } else {
                Text("CART_EMPTY_MESSAGE".localized)
            }
        }
        .onAppear {
            cartVM.basketBooks = cartVM.persistence.loadBasketBooks()
        }
        .overlay {
            SuccessOrderAlert(isPresented: $cartVM.showSuccessAlert, bookTitle: cartVM.basketBooks, orderNumber: cartVM.orderNumber) {
                ForEach(cartVM.basketBooks, id: \.self) { book in
                    Text(String(format: "BOOKDETAIL_TITLE".localized, book.book.title))
                        .foregroundColor(.black)
                        .font(.system(size: 18))
                }
            } action: {
                cartVM.finalizePurchase()
                tabBarSelection = 0
            }
            if cartVM.loading {
                LoaderView()
                    .transition(.opacity)
            }
        }
        .alert("ERROR_TITLE".localized, isPresented: $cartVM.showErrorAlert) {
            Button(action: {}) {
                Text("CLOSE".localized)
                    .textCase(.uppercase)
            }
        } message: {
            Text(cartVM.errorMsg)
        }
    }
    
    var basketBooksList: some View {
        VStack {
            SimpleButton(text: "\("CART_PLACE_ORDER".localized) (\(cartVM.basketBooks.count)producto/s)", foregroundColor: .blackLight, backroundColor: .gold) {
                Task {
                    await cartVM.createBooksOrder()
                }
            }
            .padding([.top, .horizontal])
            
            Text(String(format: "CART_ORDER_AMOUNT".localized, cartVM.basketPrice))
                .foregroundColor(.white)
                .bold()
            
            List {
                ForEach(cartVM.basketBooks, id: \.book.id) { basketBook in
                    BasketBookCell(bookCover: basketBook.book.cover, bookTitle: basketBook.book.title, author: basketBook.author, price: basketBook.price) {
                        cartVM.removeBasketBook(bookId: basketBook.book.id)
                    }
                }
                .onDelete(perform: cartVM.removeBasketBookOffset)
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
            .scrollContentBackground(.hidden)
        }
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView(tabBarSelection: .constant(2))
    }
}
