//
//  DAOApplicationProtocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import Foundation

// MARK: - Application Protocols

/// Protocol for Application Data Access Objects
public protocol DAOApplicationProtocol: DAOBaseObjectProtocol {
    /// Application name
    var name: String { get set }
    
    /// Application description
    var appDescription: String? { get set }
    
    /// Application version
    var version: String? { get set }
    
    /// Application bundle identifier
    var bundleId: String? { get set }
    
    /// Application status
    var status: DNSStatus { get set }
}
