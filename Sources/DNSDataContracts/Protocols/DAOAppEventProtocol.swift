//
//  DAOAppEventProtocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

// MARK: - AppEvent Protocols

/// Protocol for App Event Data Access Objects
public protocol DAOAppEventProtocol: DAOBaseObjectProtocol {
    /// Event name
    var name: String { get set }
    
    /// Event type
    var eventType: String { get set }
    
    /// Associated user identifier
    var userId: String? { get set }
    
    /// Event timestamp
    var timestamp: Date { get set }
    
    /// Event data
    var eventData: [String: Any]? { get set }
}
