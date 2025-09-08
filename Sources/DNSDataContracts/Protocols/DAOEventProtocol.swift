//
//  DAOEventProtocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import Foundation

// MARK: - Event Protocols

/// Protocol for Event Data Access Objects
public protocol DAOEventProtocol: DAOBaseObjectProtocol {
    /// Event name
    var name: String { get set }
    
    /// Event description
    var eventDescription: String? { get set }
    
    /// Event start time
    var startTime: Date? { get set }
    
    /// Event end time
    var endTime: Date? { get set }
    
    /// Associated place identifier
    var placeId: String? { get set }
    
    /// Event status
    var status: DNSStatus { get set }
    
    /// Event visibility
    var visibility: DNSVisibility { get set }
}
