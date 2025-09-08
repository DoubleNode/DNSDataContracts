//
//  DAOChatProtocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import Foundation

// MARK: - Chat Protocols

/// Protocol for Chat Data Access Objects
public protocol DAOChatProtocol: DAOBaseObjectProtocol {
    /// Chat name
    var name: String? { get set }
    
    /// Chat participants
    var participants: [String] { get set }
    
    /// Chat messages
    var messages: [any DAOChatMessageProtocol] { get set }
    
    /// Last message timestamp
    var lastMessageTime: Date? { get set }
    
    /// Chat status
    var status: DNSStatus { get set }
}
