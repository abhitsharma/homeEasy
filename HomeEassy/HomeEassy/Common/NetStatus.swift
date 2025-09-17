//
//  NetStatus.swift
//  NetStatusDemo
//
//  Created by Gabriel Theodoropoulos.
//  Copyright © 2019 Appcoda. All rights reserved.
//

import Foundation
import Network

class NetStatus {
        
    static let shared = NetStatus()
    var monitor = NWPathMonitor()
    var netStatusChangeHandler: ((NWPath) -> Void)?
    let queue = DispatchQueue(label: "NetStatus_Monitor")

    
    var isConnected: Bool {
        return monitor.currentPath.status == .satisfied
    }

    
    // MARK: - Init & Deinit
    
    private init() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { path in
            CLGLog.debug("internet",path.status)
             self.netStatusChangeHandler?(path)
        }
    }
    
    
//    deinit {
//        stopMonitoring()
//    }
    


}
