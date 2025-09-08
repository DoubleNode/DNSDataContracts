//
//  DAOPricingSeasonProtocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import Foundation

// MARK: - PricingSeason Protocols

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
