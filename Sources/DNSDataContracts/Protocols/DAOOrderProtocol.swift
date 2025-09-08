//
//  DAOOrderProtocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import Foundation

// MARK: - Order Protocols

/// Protocol for Order Data Access Objects
public protocol DAOOrderProtocol: DAOBaseObjectProtocol {
    /// Associated user identifier
    var userId: String? { get set }
    
    /// Order number
    var orderNumber: String? { get set }
    
    /// Order items
    var items: [any DAOOrderItemProtocol] { get set }
    
    /// Order status
    var status: DNSOrderState { get set }
    
    /// Order total amount
    var totalAmount: DNSPrice? { get set }
    
    /// Order date
    var orderDate: Date? { get set }
}
