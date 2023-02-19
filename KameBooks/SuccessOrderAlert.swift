//
//  SuccessOrderAlert.swift
//  KameBooks
//
//  Created by Jorge Suárez on 19/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import SwiftUI

struct SuccessOrderAlert: View {
    
    @Binding var isPresented: Bool
    let bookTitle: String
    let orderNumber: String
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.black.opacity(isPresented ? 0.8 : 0))
                .ignoresSafeArea()
                .gesture(TapGesture().onEnded({ _ in
                    isPresented = false
                }))
            VStack(spacing: 16) {
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
                    Text(String(format: "BOOKDETAIL_TITLE".localized, bookTitle))
                        .foregroundColor(.black)
                        .font(.system(size: 18))
                        .multilineTextAlignment(.center)
                    Text(String(format: "BOOKDETAIL_ORDER_NUMBER".localized, orderNumber))
                        .foregroundColor(.black)
                        .font(.system(size: 18))
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                SimpleButton(text: "ACCEPT".localized, foregroundColor: .white, backroundColor: .gold) {
                    isPresented = false
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
}

struct SuccessOrderAlert_Previews: PreviewProvider {
    static var previews: some View {
        SuccessOrderAlert(isPresented: .constant(true), bookTitle: "Test", orderNumber: "123")
    }
}
