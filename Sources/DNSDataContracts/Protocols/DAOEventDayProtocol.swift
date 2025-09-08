//
//  DAOEventDayProtocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import Foundation

// MARK: - EventDay Protocols

/// Protocol for Event Day Data Access Objects
public protocol DAOEventDayProtocol: DAOBaseObjectProtocol {
    /// Associated event identifier
    var eventId: String { get set }
    
    /// Event day date
    var date: Date { get set }
    
    /// Day start time
    var startTime: Date? { get set }
    
    /// Day end time
    var endTime: Date? { get set }
    
    /// Day items
    var items: [any DAOEventDayItemProtocol] { get set }
    
    /// Day status
    var status: DNSStatus { get set }
}
