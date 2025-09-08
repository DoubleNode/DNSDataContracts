//
//  DAOAccountProtocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

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

/// Protocol for Account Link Request objects
public protocol DAOAccountLinkRequestProtocol: DAOBaseObjectProtocol {
    /// The account being linked
    var accountId: String { get set }
    
    /// The user requesting the link
    var userId: String { get set }
    
    /// Status of the link request
    var status: DNSStatus { get set }
    
    /// Type of link being requested
    var linkType: String { get set }
}