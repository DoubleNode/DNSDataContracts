//
//  DAOAlertProtocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import Foundation

// MARK: - Alert Protocols

/// Protocol for Alert Data Access Objects
public protocol DAOAlertProtocol: DAOBaseObjectProtocol {
    /// Alert title
    var title: String { get set }
    
    /// Alert message
    var message: String { get set }
    
    /// Alert type
    var alertType: String { get set }
    
    /// Associated user identifier
    var userId: String? { get set }
    
    /// Alert read status
    var isRead: Bool { get set }
    
    /// Alert timestamp
    var timestamp: Date { get set }
    
    /// Alert status
    var status: DNSStatus { get set }
}
