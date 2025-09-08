//
//  DAOBaseObjectProtocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

/// Base protocol for all Data Access Objects
/// This provides the minimal interface needed by protocols without creating circular dependencies
public protocol DAOBaseObjectProtocol {
    /// Unique identifier for the object
    var id: String { get set }
    
    /// Metadata associated with the object
    var meta: any DAOMetadataProtocol { get set }
    
    /// Analytics data collection
    var analyticsData: [any DAOAnalyticsDataProtocol] { get set }
}

/// Analytics data protocol
/// Note: Simplified interface for the complex DNSAnalyticsNumbers, DNSString properties
public protocol DAOAnalyticsDataProtocol {
    /// Analytics data title
    var title: String { get }
    
    /// Analytics data subtitle  
    var subtitle: String { get }
}