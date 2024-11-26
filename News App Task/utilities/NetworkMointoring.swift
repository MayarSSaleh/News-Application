//
//  NetworkMointoring.swift
//  News App Task
//
//  Created by mayar on 26/11/2024.
//

import Foundation
import Network
import Combine

class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private(set) var networkStatusPublisher = PassthroughSubject<Bool, Never>()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    
    private(set) var isConnected: Bool = false {
        didSet {
            networkStatusPublisher.send(isConnected)
        }
    }
    
    private init() {
        startMonitoring()
    }
    
    deinit {
        stopMonitoring()
    }
    
    // Start monitoring network status
    private func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            let connected = path.status == .satisfied
            DispatchQueue.main.async {
                self.isConnected = connected
            }
        }
        monitor.start(queue: queue)
    }
    
    // Stop monitoring network status
    func stopMonitoring() {
        monitor.cancel()
    }
}

//import Combine

class ViewModel {
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Subscribe to network status changes
        NetworkMonitor.shared.networkStatusPublisher
            .sink { isConnected in
                print("Network is \(isConnected ? "connected" : "disconnected")")
            }
            .store(in: &cancellables)
    }
}

