//
//  DAOSystemProtocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import Foundation

// MARK: - System Protocols

/// Protocol for System Data Access Objects
public protocol DAOSystemProtocol: DAOBaseObjectProtocol {
    /// System name
    var name: String { get set }
    
    /// System description
    var systemDescription: String? { get set }
    
    /// System version
    var version: String? { get set }
    
    /// System endpoints
    var endpoints: [any DAOSystemEndPointProtocol] { get set }
    
    /// System status
    var status: DNSStatus { get set }
    
    /// Current system state
    var currentState: DNSSystemState? { get set }
}
