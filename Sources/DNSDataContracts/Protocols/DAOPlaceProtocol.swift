//
//  DAOPlaceProtocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

/// Protocol for Place Data Access Objects
public protocol DAOPlaceProtocol: DAOBaseObjectProtocol {
    /// Place name
    var name: String { get set }
    
    /// Place description
    var placeDescription: String? { get set }
    
    /// Place address
    var address: String? { get set }
    
    /// Place latitude coordinate
    var latitude: Double? { get set }
    
    /// Place longitude coordinate
    var longitude: Double? { get set }
    
    /// Place status
    var status: DNSStatus { get set }
    
    /// Place visibility settings
    var visibility: DNSVisibility { get set }
}

/// Protocol for Place Status objects
public protocol DAOPlaceStatusProtocol: DAOBaseObjectProtocol {
    /// Associated place identifier
    var placeId: String { get set }
    
    /// Status information
    var status: DNSStatus { get set }
    
    /// Status effective date
    var effectiveDate: Date? { get set }
}

/// Protocol for Place Hours objects
public protocol DAOPlaceHoursProtocol: DAOBaseObjectProtocol {
    /// Associated place identifier
    var placeId: String { get set }
    
    /// Daily hours information
    var hours: [DNSDailyHours] { get set }
    
    /// Day of week flags
    var dayOfWeek: DNSDayOfWeekFlags { get set }
}

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

/// Protocol for Place Holiday objects
public protocol DAOPlaceHolidayProtocol: DAOBaseObjectProtocol {
    /// Associated place identifier
    var placeId: String { get set }
    
    /// Holiday name
    var name: String { get set }
    
    /// Holiday date
    var date: Date { get set }
}