//
//  DAOPlaceProtocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import Foundation

/// Protocol for Place Data Access Objects
public protocol DAOPlaceProtocol: DAOBaseObjectProtocol {
    /// Place name
    var name: String { get set }
    
    /// Place description
    var placeDescription: String? { get set }
    
    /// Place address
    var address: String? { get set }
    
    /// Place latitude coordinate
    var latitude: Double? { get set }
    
    /// Place longitude coordinate
    var longitude: Double? { get set }
    
    /// Place status
    var status: DNSStatus { get set }
    
    /// Place visibility settings
    var visibility: DNSVisibility { get set }
}
