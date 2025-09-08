//
//  DAOPlaceStatusProtocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import Foundation

/// Protocol for Place Status objects
public protocol DAOPlaceStatusProtocol: DAOBaseObjectProtocol {
    /// Associated place identifier
    var placeId: String { get set }
    
    /// Status information
    var status: DNSStatus { get set }
    
    /// Status effective date
    var effectiveDate: Date? { get set }
}

