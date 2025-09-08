//
//  DAOAccountLinkRequestProtocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import Foundation

// MARK: - AccountLinkRequest Protocols

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
