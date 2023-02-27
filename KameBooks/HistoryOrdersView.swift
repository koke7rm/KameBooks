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
                ordersList
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
        .onAppear {
            Task {
                await homeVM.userOrderHistory()
            }
        }
    }
    
    var ordersList: some View {
        List(homeVM.orderedList, id: \.orderData.orderNumber) { order in
            VStack(alignment: .leading, spacing: 16) {
                HeaderOrderRow(orderNumber: order.orderData.orderNumber, orderState: order.orderData.orderState, state: order.orderData.state) {}
                
                ForEach(order.book, id: \.book.id) { purchased in
                    BookOrderedRow(cover: purchased.book.cover, bookTitle: purchased.book.title)
                        .disabled(true)
                }
                Text(String(format: "MYORDERS_ORDER_DATE".localized, order.orderData.date.dateFormatHistory))
                    .font(.caption)
            }
            .padding(.vertical)
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
}

struct HistoryOrdersView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryOrdersView()
            .environmentObject(HomeViewModel())
    }
}
