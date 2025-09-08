//
//  DAOSystem.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

// MARK: - System Protocols

/// Protocol for System Data Access Objects
public protocol DAOSystemProtocol: DAOBaseObjectProtocol {
    /// System name
    var name: String { get set }
    
    /// System description
    var systemDescription: String? { get set }
    
    /// System version
    var version: String? { get set }
    
    /// System endpoints
    var endpoints: [any DAOSystemEndPointProtocol] { get set }
    
    /// System status
    var status: DNSStatus { get set }
    
    /// Current system state
    var currentState: DNSSystemState? { get set }
}

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

/// Protocol for Activity Type Data Access Objects
public protocol DAOActivityTypeProtocol: DAOBaseObjectProtocol {
    /// Activity type name
    var name: String { get set }
    
    /// Activity type description
    var typeDescription: String? { get set }
    
    /// Activity type category
    var category: String? { get set }
    
    /// Activity type status
    var status: DNSStatus { get set }
}

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

// MARK: - Application Protocols

/// Protocol for Application Data Access Objects
public protocol DAOApplicationProtocol: DAOBaseObjectProtocol {
    /// Application name
    var name: String { get set }
    
    /// Application description
    var appDescription: String? { get set }
    
    /// Application version
    var version: String? { get set }
    
    /// Application bundle identifier
    var bundleId: String? { get set }
    
    /// Application status
    var status: DNSStatus { get set }
}

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

// MARK: - Promotional Protocols

/// Protocol for Promotion Data Access Objects
public protocol DAOPromotionProtocol: DAOBaseObjectProtocol {
    /// Promotion name
    var name: String { get set }
    
    /// Promotion description
    var promotionDescription: String? { get set }
    
    /// Promotion start date
    var startDate: Date? { get set }
    
    /// Promotion end date
    var endDate: Date? { get set }
    
    /// Promotion discount percentage
    var discountPercentage: Double? { get set }
    
    /// Promotion discount amount
    var discountAmount: DNSPrice? { get set }
    
    /// Promotion status
    var status: DNSStatus { get set }
    
    /// Promotion visibility
    var visibility: DNSVisibility { get set }
}