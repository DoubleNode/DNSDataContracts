//
//  DAOSystemStateProtocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import Foundation

// MARK: - SystemState Protocols

/// Protocol for System State Data Access Objects
public protocol DAOSystemStateProtocol: DAOBaseObjectProtocol {
    /// Associated system or endpoint identifier
    var referenceId: String { get set }
    
    /// State name
    var name: String { get set }
    
    /// State value
    var value: String? { get set }
    
    /// State timestamp
    var timestamp: Date { get set }
    
    /// State status
    var status: DNSStatus { get set }
}
