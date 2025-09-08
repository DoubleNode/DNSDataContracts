//
//  DAOTransactionProtocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import Foundation

// MARK: - Transaction Protocols

/// Protocol for Transaction Data Access Objects
public protocol DAOTransactionProtocol: DAOBaseObjectProtocol {
    /// Associated user identifier
    var userId: String? { get set }
    
    /// Associated order identifier
    var orderId: String? { get set }
    
    /// Transaction amount
    var amount: DNSPrice { get set }
    
    /// Transaction type
    var transactionType: String { get set }
    
    /// Transaction status
    var status: DNSStatus { get set }
    
    /// Transaction date
    var transactionDate: Date? { get set }
}
