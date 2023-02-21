//
//  SuccessOrderAlert.swift
//  KameBooks
//
//  Created by Jorge Suárez on 19/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import SwiftUI

struct SuccessOrderAlert<Content:View>: View {
    
    @Binding var isPresented: Bool
    let bookTitle: [BooksList]
    let orderNumber: String
    @ViewBuilder var bookFields: () -> Content
    let action: () -> ()
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.black.opacity(isPresented ? 0.8 : 0))
                .ignoresSafeArea()
                .gesture(TapGesture().onEnded({ _ in
                    isPresented = false
                }))
            VStack(spacing: 16) {
                infoSection
                SimpleButton(text: "ACCEPT".localized, foregroundColor: .white, backroundColor: .gold) {
                    action()
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .opacity(isPresented ? 1.0 : 0.0)
            .offset(y: isPresented ? 0.0 : 500)
            .padding(.horizontal, 30)
        }
        .animation(.default, value: isPresented)
    }
    
    var infoSection: some View {
        VStack {
            Text("BOOKDETAIL_ORDER_SUCCESS_TITLE".localized)
                .foregroundColor(.black)
                .font(.system(size: 18))
                .bold()
                .textCase(.uppercase)
            Text("BOOKDETAIL_ORDER_SUCCESS_MESSAGE".localized)
                .foregroundColor(.black)
                .font(.system(size: 18))
                .multilineTextAlignment(.center)
            VStack(alignment: .leading, spacing: 8) {
                bookFields()
                Text(String(format: "BOOKDETAIL_ORDER_NUMBER".localized, orderNumber))
                    .foregroundColor(.black)
                    .font(.system(size: 18))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct SuccessOrderAlert_Previews: PreviewProvider {
    static var previews: some View {
        SuccessOrderAlert(isPresented: .constant(true), bookTitle: [BooksList(book: BookModel.bookTest, author: "H.G. Wells")], orderNumber: "123", bookFields: {}, action: {})
    }
}
