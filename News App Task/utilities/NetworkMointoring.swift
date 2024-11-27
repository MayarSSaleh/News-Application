//
//  NetworkMointoring.swift
//  News App Task
//
//  Created by mayar on 26/11/2024.
//

import Foundation
import Combine
import Reachability

class NetworkMonitor {

        static let shared = NetworkMonitor()

        private(set) var networkStatusPublisher = PassthroughSubject<Bool, Never>()
        
        private var reachability: Reachability?
        private(set) var isConnected: Bool = false {
            didSet {
                print("Network status updated: \(isConnected)")
                networkStatusPublisher.send(isConnected)
            }
        }

        private init() {
            setupReachability()
              startMonitoring()
        }

        deinit {
            stopMonitoring()
        }

        private func setupReachability() {
            do {
                reachability = try Reachability()
            } catch {
                print("Unable to start Reachability: \(error.localizedDescription)")
            }
        }

        func startMonitoring() {
            reachability?.whenReachable = { [weak self] reachability in
                self?.updateConnectionStatus(isConnected: true)
            }

            reachability?.whenUnreachable = { [weak self] _ in
                self?.updateConnectionStatus(isConnected: false)
            }

            do {
                try reachability?.startNotifier()
            } catch {
                print("Error starting Reachability notifier: \(error.localizedDescription)")
            }
        }

        func stopMonitoring() {
            reachability?.stopNotifier()
        }

        private func updateConnectionStatus(isConnected: Bool) {
            DispatchQueue.main.async { [weak self] in
                self?.isConnected = isConnected
            }
        }
    }
