//
//  NetworkStatus.swift
//  KameBooks
//
//  Created by Jorge Suárez on 12/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import Foundation
import Network

final class NetworkStatus: ObservableObject {
    // MARK: - Network status cases
    enum Status {
        case offline, online, unknow
    }
    
    // MARK: - Properties
    @Published var status: Status = .unknow
    
    var monitor: NWPathMonitor
    var queue = DispatchQueue(label: "MonitorNet")
    
    // MARK: - init
    init() {
        monitor = NWPathMonitor()
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.status = path.status == .satisfied ? .online : .offline
            }
        }
        status = monitor.currentPath.status == .satisfied ? .online : .offline
    }
}
