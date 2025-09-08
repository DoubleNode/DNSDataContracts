//
//  DAOProductProtocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import Foundation

// MARK: - Product Protocols

/// Protocol for Product Data Access Objects
public protocol DAOProductProtocol: DAOBaseObjectProtocol {
    /// Product name
    var name: String { get set }
    
    /// Product description
    var productDescription: String? { get set }
    
    /// Product SKU
    var sku: String? { get set }
    
    /// Product price
    var price: DNSPrice? { get set }
    
    /// Product status
    var status: DNSStatus { get set }
    
    /// Product visibility
    var visibility: DNSVisibility { get set }
}
