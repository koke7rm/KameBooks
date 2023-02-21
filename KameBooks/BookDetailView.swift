//
//  BookDetailView.swift
//  KameBooks
//
//  Created by Jorge Suárez on 14/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import SwiftUI

struct BookDetailView: View {
    
    @ObservedObject var bookVM: BookDetailViewModel
    
    @Environment (\.dismiss) var dismiss
    @AppStorage("isGuest") var isGuest = false
    
    @State var seeAllText = false
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient.mainGradient, startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                header
                
                ScrollView(showsIndicators: false) {
                    detailCard
                    
                    if !isGuest {
                        VStack {
                            HStack {
                                SimpleButton(text: "BOOKDETAIL_PLACE_ORDER".localized, foregroundColor: .blackLight, backroundColor: .gold) {
                                    Task {
                                        await bookVM.createBooksOrder()
                                    }
                                }
                                SimpleButton(text: "Añadir a la cesta".localized, foregroundColor: .blackLight, backroundColor: .gold) {
                                    bookVM.addBookInBasket(book: bookVM.bookDetail)
                                }
                            }
                            if !bookVM.asReaded {
                                SimpleButton(text: "BOOKDETAIL_MARK_READ".localized, foregroundColor: .blackLight, backroundColor: .gold) {
                                    Task {
                                        await bookVM.bookReaded()
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .padding()
        }
        .overlay {
            SuccessOrderAlert(isPresented: $bookVM.showSuccessAlert, bookTitle: [bookVM.bookDetail], orderNumber: bookVM.orderNumber) {
                Text(String(format: "BOOKDETAIL_TITLE".localized, bookVM.bookDetail.book.title))
                    .foregroundColor(.black)
                    .font(.system(size: 18))
            } action: {
                bookVM.showSuccessAlert = false
            }
            SimpleCustomAlert(isPresented: $bookVM.showBasketAlert, title: "Libro añadido a la cesta", description: "El libro \(bookVM.bookDetail.book.title) ha sido añadido a la cesta") {
                bookVM.showBasketAlert = false
            }
            
            if bookVM.loading {
                LoaderView()
                    .transition(.opacity)
            }
        }
        .alert(bookVM.errorTitle, isPresented: $bookVM.showErrorAlert) {
            Button(action: {}) {
                Text("CLOSE".localized)
                    .textCase(.uppercase)
            }
        } message: {
            Text(bookVM.errorMsg)
        }
    }
    
    var header: some View {
        VStack {
            Text(bookVM.bookDetail.book.title)
                .font(.title)
                .bold()
                .foregroundColor(.white)
            
            AsyncImage(url: bookVM.bookDetail.book.cover) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
            } placeholder: {
                Image("img_placeholder")
            }
        }
    }
    
    var detailCard: some View {
        VStack {
            RatingStarsView(rating: bookVM.bookDetail.book.rating ?? 0)
                .padding()
            
            VStack(alignment: .leading, spacing: 8) {
                Image(systemName: bookVM.asReaded ? "bookmark.fill" : "bookmark.slash.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25)
                    .foregroundColor(bookVM.asReaded ? .green : .lightGray)
                InfoField(sectionTitle: "BOOKDETAIL_AUTHOR".localized, sectionInfo: bookVM.bookDetail.author)
                InfoField(sectionTitle: "BOOKDETAIL_YEAR".localized, sectionInfo: "\(bookVM.bookDetail.book.year ?? 0)")
                InfoField(sectionTitle: "BOOKDETAIL_PAGES".localized, sectionInfo: "\(bookVM.bookDetail.book.pages ?? 0)")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            
            plotInfo
        }
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.8))
        .cornerRadius(20)
    }
    
    var plotInfo: some View {
        VStack {
            Text(bookVM.bookDetail.book.plot ?? "BOOKDETAIL_NO_INFORMATION".localized)
                .lineLimit(seeAllText ? .max : 8)
                .padding()
            if bookVM.bookDetail.book.plot != nil {
                Button {
                    seeAllText.toggle()
                } label: {
                    Label(seeAllText ? "BOOKDETAIL_SEE_LESS".localized : "BOOKDETAIL_SEE_MORE".localized, image: seeAllText ? "ic_arrowUp" : "ic_arrowDown")
                }
                .padding(.bottom)
            }
        }
    }
    
    struct InfoField: View {
        
        let sectionTitle: String
        let sectionInfo: String
        
        var body: some View {
            HStack {
                Text(sectionTitle)
                    .font(.title2)
                    .bold()
                Text(sectionInfo)
            }
        }
    }
}

struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BookDetailView(bookVM: BookDetailViewModel(book: .init(book: .bookTest, author: "H. G. Wells")))
    }
}
