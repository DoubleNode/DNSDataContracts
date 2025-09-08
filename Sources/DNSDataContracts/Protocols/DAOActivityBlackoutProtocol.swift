//
//  DAOActivityBlackoutProtocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import Foundation

// MARK: - ActivityBlackout Protocols

/// Protocol for Activity Blackout Data Access Objects
public protocol DAOActivityBlackoutProtocol: DAOBaseObjectProtocol {
    /// Associated activity type identifier
    var activityTypeId: String { get set }
    
    /// Blackout name
    var name: String { get set }
    
    /// Blackout start time
    var startTime: Date { get set }
    
    /// Blackout end time
    var endTime: Date { get set }
    
    /// Blackout status
    var status: DNSStatus { get set }
}
