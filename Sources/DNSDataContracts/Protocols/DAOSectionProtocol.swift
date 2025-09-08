//
//  DAOSectionProtocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import Foundation

// MARK: - Section Protocols

/// Protocol for Section Data Access Objects
public protocol DAOSectionProtocol: DAOBaseObjectProtocol {
    /// Section name
    var name: String { get set }
    
    /// Section description
    var sectionDescription: String? { get set }
    
    /// Parent section identifier
    var parentId: String? { get set }
    
    /// Child sections
    var children: [any DAOSectionProtocol] { get set }
    
    /// Section status
    var status: DNSStatus { get set }
    
    /// Section visibility
    var visibility: DNSVisibility { get set }
}
