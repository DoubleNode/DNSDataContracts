//
//  DAOBasketProtocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import Foundation

// MARK: - Basket Protocols

/// Protocol for Cart/Basket Data Access Objects
public protocol DAOBasketProtocol: DAOBaseObjectProtocol {
    /// Associated user identifier
    var userId: String? { get set }
    
    /// Basket items
    var items: [any DAOBasketItemProtocol] { get set }
    
    /// Basket status
    var status: DNSStatus { get set }
    
    /// Total amount
    var totalAmount: DNSPrice? { get set }
}
