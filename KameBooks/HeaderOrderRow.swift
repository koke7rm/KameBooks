//
//  HeaderOrderRow.swift
//  KameBooks
//
//  Created by Jorge Suárez on 26/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import SwiftUI

struct HeaderOrderRow<Content:View>: View {
    
    let orderNumber: String
    let orderState: OrderState?
    let state: String
    @ViewBuilder var email: () -> Content
    
    var body: some View {
        Text(orderNumber)
            .font(.caption)
        email()
        HStack {
            Image(systemName: "smallcircle.filled.circle.fill")
                .foregroundColor(orderState?.color)
            Text(state.capitalized)
                .font(.caption)
        }
    }
}

struct HeaderOrderRow_Previews: PreviewProvider {
    static var previews: some View {
        HeaderOrderRow(orderNumber: "1234", orderState: .returned, state: "", email: {})
    }
}
