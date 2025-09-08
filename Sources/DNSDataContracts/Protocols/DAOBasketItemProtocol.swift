//
//  DAOBasketItemProtocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import Foundation

// MARK: - BasketItem Protocols

/// Protocol for Basket Item Data Access Objects
public protocol DAOBasketItemProtocol: DAOBaseObjectProtocol {
    /// Associated basket identifier
    var basketId: String { get set }
    
    /// Associated product identifier
    var productId: String { get set }
    
    /// Item quantity
    var quantity: Int { get set }
    
    /// Item unit price
    var unitPrice: DNSPrice? { get set }
    
    /// Item total price
    var totalPrice: DNSPrice? { get set }
}
