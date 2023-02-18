//
//  BookCell.swift
//  KameBooks
//
//  Created by Jorge Suárez on 18/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import SwiftUI

struct BookCell: View {
    
    @EnvironmentObject var homeVM: HomeViewModel
    
    let bookList: BooksList
    
    var body: some View {
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
                HStack {
                    ForEach(1...5, id:\.self) { index in
                        homeVM.setImageScore(id: bookList.book.id, tag: index)
                            .foregroundColor(.yellow)
                    }
                }
                .padding(.top, 8)
                
                Spacer()
                
                Text(String(format: "BOOKINFO_PUBLISHED", bookList.book.year?.formatted().replaceDecimal ?? "-"))
                    .padding(.bottom)
            }
            .padding(.top)
        }
    }
}

struct BookCell_Previews: PreviewProvider {
    static var previews: some View {
        BookCell(bookList: BooksList(book: .bookTest, author: "1"))
            .environmentObject(HomeViewModel())
    }
}
