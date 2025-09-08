//
//  DAOPromotionProtocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import Foundation

// MARK: - Promotion Protocols

/// Protocol for Promotion Data Access Objects
public protocol DAOPromotionProtocol: DAOBaseObjectProtocol {
    /// Promotion name
    var name: String { get set }
    
    /// Promotion description
    var promotionDescription: String? { get set }
    
    /// Promotion start date
    var startDate: Date? { get set }
    
    /// Promotion end date
    var endDate: Date? { get set }
    
    /// Promotion discount percentage
    var discountPercentage: Double? { get set }
    
    /// Promotion discount amount
    var discountAmount: DNSPrice? { get set }
    
    /// Promotion status
    var status: DNSStatus { get set }
    
    /// Promotion visibility
    var visibility: DNSVisibility { get set }
}
