//
//  BookOrderedRow.swift
//  KameBooks
//
//  Created by Jorge Suárez on 26/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import SwiftUI

struct BookOrderedRow: View {
    
    let cover: URL?
    let bookTitle: String
    
    var body: some View {
        HStack(alignment: .center) {
            AsyncImage(url: cover) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
            } placeholder: {
                Image("img_placeholder")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
            }
            Text(bookTitle)
        }
        .frame(maxHeight: .infinity)
    }
}

struct BookOrderedRow_Previews: PreviewProvider {
    static var previews: some View {
        BookOrderedRow(cover: URL(string: ""), bookTitle: "Test")
    }
}
