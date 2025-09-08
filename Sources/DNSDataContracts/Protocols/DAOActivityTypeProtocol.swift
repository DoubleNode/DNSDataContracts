//
//  DAOActivityTypeProtocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import Foundation

// MARK: - ActivityType Protocols

/// Protocol for Activity Type Data Access Objects
public protocol DAOActivityTypeProtocol: DAOBaseObjectProtocol {
    /// Activity type name
    var name: String { get set }
    
    /// Activity type description
    var typeDescription: String? { get set }
    
    /// Activity type category
    var category: String? { get set }
    
    /// Activity type status
    var status: DNSStatus { get set }
}
