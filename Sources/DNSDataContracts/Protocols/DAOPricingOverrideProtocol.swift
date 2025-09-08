//
//  DAOPricingOverrideProtocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import Foundation

// MARK: - PricingOverride Protocols

/// Protocol for Pricing Override/Exception Data Access Objects
public protocol DAOPricingOverrideProtocol: DAOBaseObjectProtocol {
    /// Override enabled state
    var enabled: Bool { get set }
    
    /// Override start time
    var startTime: Date { get set }
    
    /// Override end time
    var endTime: Date { get set }
    
    /// Override title
    var title: DNSString { get set }
    
    /// Override priority
    var priority: Int { get set }
    
    /// Override pricing items
    var items: [any DAOPricingItemProtocol] { get set }
    
    /// Check if override is currently active
    var isActive: Bool { get }
    
    /// Check if override is active at a specific time
    func isActive(for time: Date) -> Bool
    
    /// Get the active pricing item (first available)
    var item: (any DAOPricingItemProtocol)? { get }
    
    /// Get the active pricing item for a specific time
    func item(for time: Date) -> (any DAOPricingItemProtocol)?
    
    /// Get the active price (from first available item)
    var price: DNSPrice? { get }
    
    /// Get the active price for a specific time
    func price(for time: Date) -> DNSPrice?
}
