//
//  DAOAnalyticsDataProtocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

// MARK: - AnalyticsData Protocols

// Analytics data protocol
/// Note: Simplified interface for the complex DNSAnalyticsNumbers, DNSString properties
public protocol DAOAnalyticsDataProtocol {
    /// Analytics data title
    var title: String { get }
    
    /// Analytics data subtitle  
    var subtitle: String { get }
}
