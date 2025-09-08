//
//  DAOBaseObjectProtocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
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
    var analyticsData: [DAOAnalyticsData] { get set }
}

/// Analytics data protocol
public protocol DAOAnalyticsData {
    var name: String { get set }
    var value: String { get set }
}