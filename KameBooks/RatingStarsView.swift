//
//  RatingStarsView.swift
//  KameBooks
//
//  Created by Jorge Suárez on 18/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import SwiftUI

struct RatingStarsView: View {
    
    let rating: Double
    
    var body: some View {
        HStack {
            ForEach(1...5, id:\.self) { index in
                Image("")
                    .setImageScore(rating: rating, tag: index)
                    .foregroundColor(.yellow)
            }
        }
    }
}

struct RatingStarsView_Previews: PreviewProvider {
    static var previews: some View {
        RatingStarsView(rating: 3.0)
    }
}
