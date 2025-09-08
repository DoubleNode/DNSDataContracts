//
//  DAOPlaceHolidayProtocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

/// Protocol for Place Holiday objects
public protocol DAOPlaceHolidayProtocol: DAOBaseObjectProtocol {
    /// Associated place identifier
    var placeId: String { get set }
    
    /// Holiday name
    var name: String { get set }
    
    /// Holiday date
    var date: Date { get set }
}
