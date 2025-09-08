//
//  DAOActivityProtocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import Foundation

// MARK: - Activity Protocols

/// Protocol for Activity Data Access Objects
public protocol DAOActivityProtocol: DAOBaseObjectProtocol {
    /// Activity name
    var name: String { get set }
    
    /// Activity description
    var activityDescription: String? { get set }
    
    /// Associated activity type identifier
    var activityTypeId: String { get set }
    
    /// Associated user identifier
    var userId: String? { get set }
    
    /// Activity start time
    var startTime: Date? { get set }
    
    /// Activity end time
    var endTime: Date? { get set }
    
    /// Activity status
    var status: DNSStatus { get set }
}
