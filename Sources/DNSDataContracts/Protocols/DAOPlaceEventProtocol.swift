//
//  DAOPlaceEventProtocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

/// Protocol for Place Event objects
public protocol DAOPlaceEventProtocol: DAOBaseObjectProtocol {
    /// Associated place identifier
    var placeId: String { get set }
    
    /// Associated event identifier
    var eventId: String { get set }
    
    /// Event start time
    var startTime: Date? { get set }
    
    /// Event end time
    var endTime: Date? { get set }
}
