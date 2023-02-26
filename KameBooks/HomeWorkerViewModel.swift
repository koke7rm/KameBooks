//
//  HomeWorkerViewModel.swift
//  KameBooks_Workers
//
//  Created by Jorge Suárez on 26/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import Foundation

final class HomeWorkerViewModel: ObservableObject {
    
    let networkPersistance = NetworkPersistence.shared
    
    @Published var loading = false
    @Published var errorMsg = ""
    @Published var showErrorAlert = false
    @Published var showSuccessAlert = false
    @Published var orderedList: [OrderList] = []
    @Published var completeList: [BooksList] = []
    
    init(completeList: [BooksList]) {
        self.completeList = completeList
        Task {
            await getAllOrders()
        }
    }
    
    @MainActor func getAllOrders() async {
         guard let email = KameBooksKeyChain.shared.user?.email else { return }
        orderedList.removeAll()
        loading = true
        do {
            let orderHistoryList = try await networkPersistance.getAllOrders(mail: email)
            orderedList = orderHistoryList.map { userHistory in
                let booksList = completeList.filter { userHistory.books.contains($0.book.id) }
                return OrderList(book: booksList, orderData: userHistory)
            }
            .sorted {$0.orderData.date > $1.orderData.date}
        } catch let error as APIErrors {
            errorMsg = error.description
            showErrorAlert.toggle()
        } catch {
            errorMsg = error.localizedDescription
            showErrorAlert.toggle()
        }
        loading = false
    }
    
    @MainActor func modifyOrderState(id: String, state: String) async {
        guard let email = KameBooksKeyChain.shared.user?.email else { return }
        loading = true
        let task = Task(priority: .utility) {
            return try await networkPersistance.modifyOrderState(requestData: OrderStateRequest(id: id, state: state, admin: email))
        }
        switch await task.result {
        case .success(_):
            showSuccessAlert.toggle()
        case .failure(let error as APIErrors):
            errorMsg = error.description
            showErrorAlert.toggle()
        case .failure(let error):
            errorMsg = error.localizedDescription
            showErrorAlert.toggle()
        }
        loading = false
    }
    
}
