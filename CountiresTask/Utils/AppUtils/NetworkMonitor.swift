//
//  NetworkMonitor.swift
//  CountiresTask
//
//  Created by Ahmed Abdelraouf on 09/04/2026.
//

import Network
import Combine

protocol NetworkMonitorContract {
    var isConnected: Bool { get }
}

enum NetworkState {
    case online
    case offline
}

class NetworkMonitor: ObservableObject, NetworkMonitorContract {
    static let shared: NetworkMonitor = .init()
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "NetworkMonitor")
    @Published var isConnected = true
    
    private var state: NetworkState = .online
    private init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async { [weak self] in
                let isNetworkConnected = path.status == .satisfied
                self?.isConnected = isNetworkConnected
                let network: NetworkState = isNetworkConnected ? .online : .offline
                self?.didChangeNetworkReachability(network)
            }
        }
        monitor.start(queue: queue)
    }
    
    private func didChangeNetworkReachability(_ network: NetworkState) {
        guard state != network else { return }
        state = network
    }
}
