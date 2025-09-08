//
//  DAOAccountProtocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import Foundation

// MARK: - Account Protocols

/// Protocol for Account Data Access Objects
public protocol DAOAccountProtocol: DAOBaseObjectProtocol {
    /// Account name/identifier
    var name: String { get set }
    
    /// Account display name
    var displayName: String? { get set }
    
    /// Account status
    var status: DNSStatus { get set }
    
    /// Account visibility settings
    var visibility: DNSVisibility { get set }
    
    /// Account type classification
    var accountType: String? { get set }
}
