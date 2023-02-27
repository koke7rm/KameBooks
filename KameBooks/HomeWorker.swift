//
//  HomeWorker.swift
//  KameBooks_Workers
//
//  Created by Jorge Suárez on 26/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import SwiftUI

struct HomeWorker: View {
    
    @EnvironmentObject var homeWorkerVM: HomeWorkerViewModel
    
    @Binding var screen: Screens
    @State var showChangeState = false
    @State var orderState = ""
    @State var showLogoutAlert = false
    @State var orderId = ""
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient.mainGradient, startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack {
                HStack {
                    Text("HOMEWORKER_HEADER_TITLE".localized)
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                        .textCase(.uppercase)
                    Spacer()
                    Button {
                        showLogoutAlert.toggle()
                    } label: {
                        Image(systemName: "rectangle.portrait.and.arrow.right.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40)
                            .foregroundColor(.gold)
                    }
                }
                .padding()
                
                CustomSearchBar(searchText: $homeWorkerVM.search, showSearch: .constant(false), placeHolder: "HOMEWORKER_SEARCH_PLACEHOLDER".localized, action: {})
                
                ordersList
            }
            .padding(.vertical)
        }
        .sheet(isPresented: $showChangeState) {
            ChangeOrderStateView(setState: $orderState) {
                Task {
                    await homeWorkerVM.modifyOrderState(id: orderId, state: orderState)
                }
            }
        }
        .overlay {
            if homeWorkerVM.loading {
                LoaderView()
                    .transition(.opacity)
            }
            SimpleCustomAlert(isPresented: $homeWorkerVM.showSuccessAlert, title: "APP_NAME".localized, description: "HOMEWORKER_SUCCESS_DESCRIPTION".localized) {
                homeWorkerVM.showSuccessAlert.toggle()
                Task {
                    await homeWorkerVM.getAllOrders()
                }
            }
        }
        .alert("ERROR_TITLE".localized, isPresented: $homeWorkerVM.showErrorAlert) {
            Button(action: {}) {
                Text("CLOSE".localized)
                    .textCase(.uppercase)
            }
        } message: {
            Text(homeWorkerVM.errorMsg)
        }
        .alert("APP_NAME".localized, isPresented: $showLogoutAlert) {
            Button(role: .destructive) {
                screen = .loginWorker
                KameBooksKeyChain.shared.deleteUser()
            } label: {
                Text("ACCEPT".localized)
                    .textCase(.uppercase)
            }
            
            Button(role: .cancel, action: {}) {
                Text("CANCEL".localized)
                    .textCase(.uppercase)
            }
        } message: {
            Text("LOGOUT_MESSAGE".localized)
        }
    }
    
    var ordersList: some View {
        List(homeWorkerVM.filterOrders, id: \.orderData.orderNumber) { order in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(.white)
                    .onTapGesture {
                        showChangeState.toggle()
                        orderState = order.orderData.orderState?.rawValue ?? ""
                        orderId = order.orderData.orderNumber
                    }
                VStack(alignment: .leading, spacing: 16) {
                    HeaderOrderRow(orderNumber: order.orderData.orderNumber, orderState: order.orderData.orderState, state: order.orderData.state) {
                        Text(order.orderData.email)
                            .font(.caption)
                    }
                    ForEach(order.book, id: \.book.id) { purchased in
                        BookOrderedRow(cover: purchased.book.cover, bookTitle: purchased.book.title)
                    }
                    Text(String(format: "MYORDERS_ORDER_DATE".localized, order.orderData.date.dateFormatHistory))
                        .font(.caption)
                }
                .padding(.vertical)
                .frame(maxHeight: .infinity)
            }
        }
        .scrollContentBackground(.hidden)
        .overlay {
            if homeWorkerVM.orderedList.isEmpty {
                Text("MYORDERS_NO_ORDERS".localized)
                    .bold()
            }
            if homeWorkerVM.filterOrders.isEmpty {
                Text("Usuario no encontrado")
                    .bold()
            }
        }
        .refreshable {
            await homeWorkerVM.getAllOrders()
        }
    }
}

struct HomeWorker_Previews: PreviewProvider {
    static var previews: some View {
        HomeWorker(screen: .constant(.homeWorker))
            .environmentObject(HomeWorkerViewModel(completeList: []))
        
    }
}
