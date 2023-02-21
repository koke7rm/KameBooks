//
//  BasketBookCell.swift
//  KameBooks
//
//  Created by Jorge Suárez on 21/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import SwiftUI

struct BasketBookCell: View {
    
    let bookCover: URL?
    let bookTitle: String
    let author: String
    let action: () -> ()
    
    var body: some View {
        HStack(alignment: .center) {
            AsyncImage(url: bookCover) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 150)
            } placeholder: {
                Image("img_placeholder")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
            }
            .cornerRadius(8)
            bookInfo
        }
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.blackLight, lineWidth: 4)
        }
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.6), radius: 6, x: 0, y: 4)
        .padding(.top)
    }
    
    var bookInfo: some View {
        VStack(spacing: 8) {
            Text(bookTitle)
                .bold()
            Text(author)
            Spacer()
            Button(role: .destructive) {
                action()
            } label: {
                Image(systemName: "trash.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.trailing)
        }
        .padding(.vertical)
    }
}

struct BasketBookCell_Previews: PreviewProvider {
    static var previews: some View {
        BasketBookCell(bookCover: URL(string: "https://images.gr-assets.com/books/1327942880l/2493.jpg"), bookTitle: "The Time Machine", author: "H.G. Wells", action: {})
            .previewLayout(.fixed(width: 450, height: 150))
    }
}
