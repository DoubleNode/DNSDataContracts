//
//  DAOCommerce.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
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

// MARK: - Cart Protocols

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

/// Protocol for Pricing Tier Data Access Objects
public protocol DAOPricingTierProtocol: DAOBaseObjectProtocol {
    /// Associated pricing identifier
    var pricingId: String { get set }
    
    /// Tier name
    var name: String { get set }
    
    /// Tier pricing items
    var items: [any DAOPricingItemProtocol] { get set }
    
    /// Tier status
    var status: DNSStatus { get set }
}

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

/// Protocol for Pricing Season Data Access Objects
public protocol DAOPricingSeasonProtocol: DAOBaseObjectProtocol {
    /// Associated pricing tier identifier
    var pricingTierId: String { get set }
    
    /// Season name
    var name: String { get set }
    
    /// Season start date
    var startDate: Date? { get set }
    
    /// Season end date
    var endDate: Date? { get set }
    
    /// Season status
    var status: DNSStatus { get set }
}

// MARK: - Transaction Protocols

/// Protocol for Transaction Data Access Objects
public protocol DAOTransactionProtocol: DAOBaseObjectProtocol {
    /// Associated user identifier
    var userId: String? { get set }
    
    /// Associated order identifier
    var orderId: String? { get set }
    
    /// Transaction amount
    var amount: DNSPrice { get set }
    
    /// Transaction type
    var transactionType: String { get set }
    
    /// Transaction status
    var status: DNSStatus { get set }
    
    /// Transaction date
    var transactionDate: Date? { get set }
}