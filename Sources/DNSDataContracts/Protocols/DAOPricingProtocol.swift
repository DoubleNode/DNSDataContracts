//
//  DAOPricingProtocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import Foundation

// MARK: - Pricing Protocols

/// Protocol for Pricing Data Access Objects
public protocol DAOPricingProtocol: DAOBaseObjectProtocol {
    /// Pricing name
    var name: String { get set }
    
    /// Pricing tiers
    var tiers: [any DAOPricingTierProtocol] { get set }
    
    /// Pricing status
    var status: DNSStatus { get set }
}
