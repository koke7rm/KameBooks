//
//  BookCell.swift
//  KameBooks
//
//  Created by Jorge Suárez on 18/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import SwiftUI

struct BookCell: View {
    
    @ObservedObject var homeVM: HomeViewModel
    @State var price = Int.random(in: 15...80)
    
    let bookList: BooksList
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 8)
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
                    .padding(.bottom, 2)
                RatingStarsView(rating: bookList.book.rating ?? 0)

                Spacer()
                
                Text("\(bookList.book.price.formatted(.number.precision(.fractionLength(2)))) €")
                    .font(.title)
                    .bold()
                    .frame(maxWidth: .infinity)
                Spacer()
                
                Text(String(format: "BOOKINFO_PUBLISHED".localized, "\(bookList.book.year ?? 0)"))
                    .padding(.bottom)
            }
            .padding(.top)
        }
        .frame(maxHeight: 200)
    }
}

struct BookCell_Previews: PreviewProvider {
    static var previews: some View {
        BookCell(homeVM: HomeViewModel(), bookList: BooksList(book: .bookTest, author: "531EDFA6-A361-4E15-873F-45E4EA0AF120"))
            .previewLayout(.fixed(width: 450, height: 120))
           
    }
}
