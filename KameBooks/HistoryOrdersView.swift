//
//  HistoryOrdersView.swift
//  KameBooks
//
//  Created by Jorge Suárez on 19/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import SwiftUI

struct HistoryOrdersView: View {
    
    @EnvironmentObject var homeVM: HomeViewModel
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient.mainGradient, startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack {
                Text("MYORDERS_TITLE".localized)
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                    .textCase(.uppercase)
                List(homeVM.orderedList, id: \.orderData.orderNumber) { order in
                    VStack(alignment: .leading, spacing: 16) {
                        HeaderOrderRow(orderNumber: order.orderData.orderNumber, orderState: order.orderData.orderState, state: order.orderData.state)
                        
                        ForEach(order.book, id: \.book.id) { purchased in
                            BookOrderedRow(cover: purchased.book.cover, bookTitle: purchased.book.title)
                        }
                        Text(String(format: "MYORDERS_ORDER_DATE".localized, order.orderData.formatDate))
                            .font(.caption)
                    }
                }
                .scrollContentBackground(.hidden)
                .overlay {
                    if homeVM.orderedList.isEmpty {
                        Text("MYORDERS_NO_ORDERS".localized)
                            .bold()
                    }
                }
                .refreshable {
                    homeVM.orderedList.removeAll()
                    await homeVM.userOrderHistory()
                }
            }
            .padding(.top)
        }
        .alert("ERROR_TITLE".localized, isPresented: $homeVM.showErrorAlert) {
            Button(action: {}) {
                Text("CLOSE".localized)
                    .textCase(.uppercase)
            }
        } message: {
            Text(homeVM.errorMsg)
        }
        .overlay {
            if homeVM.loading {
                LoaderView()
                    .transition(.opacity)
            }
        }
    }
    
    struct HeaderOrderRow: View {
        
        let orderNumber: String
        let orderState: OrderState?
        let state: String
        
        var body: some View {
            Text(orderNumber)
                .font(.caption)
            HStack {
                Image(systemName: "smallcircle.filled.circle.fill")
                    .foregroundColor(orderState == .recived ? Color.green : Color.lightGray)
                Text(state.capitalized)
                    .font(.caption)
            }
        }
    }
    
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
        }
    }
}

struct HistoryOrdersView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryOrdersView()
            .environmentObject(HomeViewModel())
    }
}
