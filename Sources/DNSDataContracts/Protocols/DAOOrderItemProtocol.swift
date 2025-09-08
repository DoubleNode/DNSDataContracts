//
//  DAOOrderItemProtocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import Foundation

// MARK: - OrderItem Protocols

/// Protocol for Order Item Data Access Objects
public protocol DAOOrderItemProtocol: DAOBaseObjectProtocol {
    /// Associated order identifier
    var orderId: String { get set }
    
    /// Associated product identifier
    var productId: String { get set }
    
    /// Item quantity
    var quantity: Int { get set }
    
    /// Item unit price
    var unitPrice: DNSPrice? { get set }
    
    /// Item total price
    var totalPrice: DNSPrice? { get set }
}
