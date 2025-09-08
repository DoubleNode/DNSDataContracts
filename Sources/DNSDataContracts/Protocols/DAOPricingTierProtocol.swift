//
//  DAOPricingTierProtocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import Foundation

// MARK: - PricingTier Protocols

/// Protocol for Pricing Tier Data Access Objects
public protocol DAOPricingTierProtocol: DAOBaseObjectProtocol {
    /// Associated pricing identifier
    var pricingId: String { get set }
    
    /// Tier name
    var name: String { get set }
    
    /// Tier pricing items
    var items: [any DAOPricingItemProtocol] { get set }
    
    /// Tier pricing exceptions/overrides
    var exceptions: [any DAOPricingOverrideProtocol] { get set }
    
    /// Tier status
    var status: DNSStatus { get set }
}
