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
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient.mainGradient, startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack {
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
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(bookVM.bookDetail.book.title)
                        .foregroundColor(.white)
                        .bold()
                }
            }
        }
    }
    
    var detailCard: some View {
        VStack {
            //topSelector
//            Image(decorative: chapterDetailVM.image)
//                .resizable()
//                .scaledToFit()
//            HStack {
//                ForEach(1...5, id:\.self) { index in
//                    chapterDetailVM.setImageScore(id: chapterDetailVM.id, tag: index)
//                        .font(.largeTitle)
//                        .foregroundColor(.newYellow)
//                        .onTapGesture {
//                            chapterDetailVM.toggleScore(id: chapterDetailVM.id, starNumber: index)
//                        }
//                }
//            }
//            .frame(maxWidth: .infinity)
//            .background(Color.white)
            Text(bookVM.bookDetail.book.plot ?? "-")
                .padding()

        }
        .background(Color.white.opacity(0.8))
        .cornerRadius(20)
        .padding()
    }
}

struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BookDetailView(bookVM: BookDetailViewModel(book: .init(book: .bookTest, author: "H. G. Wells")))
    }
}
