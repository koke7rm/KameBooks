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
                ScrollView {
                    
                    detailCard
                    if !isGuest {
                        HStack {
                            Button {
                                Task {
                                    await bookVM.createBooksOrder()
                                }
                            } label: {
                                Text("Realizar pedido")
                            }
                            .buttonStyle(.bordered)
                            
                            Button {
                                Task {
                                    await bookVM.createBooksOrder()
                                }
                            } label: {
                                Text("Marcar como leido")
                            }
                            .buttonStyle(.bordered)
                            
                        }
                        .padding()
                    }
                }
            }
            .padding()
            //            .navigationBarTitleDisplayMode(.inline)
            //            .toolbar {
            //                ToolbarItem(placement: .principal) {
            //                    Text(bookVM.bookDetail.book.title)
            //                        .foregroundColor(.white)
            //                        .bold()
            //                }
            //            }
        }
    }
    
    var detailCard: some View {
        VStack {
            Text(bookVM.bookDetail.book.plot ?? "-")
                .lineLimit(seeAllText ? .max : 8)
                .padding()
            Button {
                seeAllText.toggle()
            } label: {
                Label(seeAllText ? "Ver Menos" : "Ver más", image: seeAllText ? "ic_arrowUp" : "ic_arrowDown")
            }
            .padding(.bottom)
            
        }
        .background(Color.white.opacity(0.8))
        .cornerRadius(20)
    }
}

struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BookDetailView(bookVM: BookDetailViewModel(book: .init(book: .bookTest, author: "H. G. Wells")))
    }
}
