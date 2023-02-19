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
            List(homeVM.orderHistoryList, id: \.self) { order in
                Text(order.orderNumber)
            }
            .refreshable {
              await homeVM.userOrderHistory()
            }
            if homeVM.orderHistoryList.isEmpty {
                Text("no hay pedidos realizados")
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
