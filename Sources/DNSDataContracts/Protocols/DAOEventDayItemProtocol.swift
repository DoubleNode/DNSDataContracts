//
//  DAOEventDayItemProtocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import Foundation

// MARK: - EventDayItem Protocols

/// Protocol for Event Day Item Data Access Objects
public protocol DAOEventDayItemProtocol: DAOBaseObjectProtocol {
    /// Associated event day identifier
    var eventDayId: String { get set }
    
    /// Item name
    var name: String { get set }
    
    /// Item description
    var itemDescription: String? { get set }
    
    /// Item start time
    var startTime: Date? { get set }
    
    /// Item end time
    var endTime: Date? { get set }
    
    /// Item status
    var status: DNSStatus { get set }
}
