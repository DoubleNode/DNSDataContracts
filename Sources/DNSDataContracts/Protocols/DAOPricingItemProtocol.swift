//
//  DAOPricingItemProtocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import Foundation

// MARK: - PricingItem Protocols

/// Protocol for Pricing Item Data Access Objects
public protocol DAOPricingItemProtocol: DAOBaseObjectProtocol {
    /// Associated pricing tier identifier
    var pricingTierId: String { get set }
    
    /// Item name
    var name: String { get set }
    
    /// Item price
    var price: DNSPrice { get set }
    
    /// Item status
    var status: DNSStatus { get set }
}
