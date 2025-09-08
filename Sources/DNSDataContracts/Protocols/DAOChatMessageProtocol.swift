//
//  DAOChatMessageProtocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import Foundation

// MARK: - ChatMessage Protocols

/// Protocol for Chat Message Data Access Objects
public protocol DAOChatMessageProtocol: DAOBaseObjectProtocol {
    /// Associated chat identifier
    var chatId: String { get set }
    
    /// Message sender identifier
    var senderId: String { get set }
    
    /// Message content
    var content: String { get set }
    
    /// Message timestamp
    var timestamp: Date { get set }
    
    /// Message status
    var status: DNSStatus { get set }
}
