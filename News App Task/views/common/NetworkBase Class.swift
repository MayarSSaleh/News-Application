//
//  NetworkBase Class.swift
//  News App Task
//
//  Created by mayar on 26/11/2024.
//

import UIKit
import Combine

class NetworkBaseViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNetworkMonitoring()
    }

    private func setupNetworkMonitoring() {
        NetworkMonitor.shared.networkStatusPublisher
            .sink { [weak self] isConnected in
                if isConnected {
                    self?.handleNetworkAvailable()
                } else {
                    self?.handleNoNetwork()
                }
            }
            .store(in: &cancellables)
    }

    func handleNetworkAvailable() {
    }

    func handleNoNetwork() {
    }
}
