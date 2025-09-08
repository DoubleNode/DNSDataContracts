//
//  DAOMediaProtocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import Foundation

// MARK: - Media Protocols

/// Protocol for Media Data Access Objects
public protocol DAOMediaProtocol: DAOBaseObjectProtocol {
    /// Media name
    var name: String { get set }
    
    /// Media description
    var mediaDescription: String? { get set }
    
    /// Media type
    var mediaType: DNSMediaType { get set }
    
    /// Media URL
    var url: String? { get set }
    
    /// Media thumbnail URL
    var thumbnailUrl: String? { get set }
    
    /// Media size in bytes
    var size: Int64 { get set }
    
    /// Media status
    var status: DNSStatus { get set }
}
