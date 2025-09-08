//
//  DAOSystemEndPointProtocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import Foundation

// MARK: - SystemEndPoint Protocols

/// Protocol for System EndPoint Data Access Objects
public protocol DAOSystemEndPointProtocol: DAOBaseObjectProtocol {
    /// Associated system identifier
    var systemId: String { get set }
    
    /// Endpoint name
    var name: String { get set }
    
    /// Endpoint URL
    var url: String { get set }
    
    /// Endpoint type
    var endpointType: String { get set }
    
    /// Endpoint status
    var status: DNSStatus { get set }
    
    /// Current endpoint state
    var currentState: DNSSystemState? { get set }
}
