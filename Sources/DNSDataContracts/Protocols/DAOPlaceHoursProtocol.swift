//
//  DAOPlaceHoursProtocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import Foundation

/// Protocol for Place Hours objects
public protocol DAOPlaceHoursProtocol: DAOBaseObjectProtocol {
    /// Associated place identifier
    var placeId: String { get set }
    
    /// Daily hours information
    var hours: [DNSDailyHours] { get set }
    
    /// Day of week flags
    var dayOfWeek: DNSDayOfWeekFlags { get set }
}
