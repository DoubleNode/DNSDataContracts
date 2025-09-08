//
//  DAOContent.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

// MARK: - Content Protocols

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

/// Protocol for Event Data Access Objects
public protocol DAOEventProtocol: DAOBaseObjectProtocol {
    /// Event name
    var name: String { get set }
    
    /// Event description
    var eventDescription: String? { get set }
    
    /// Event start time
    var startTime: Date? { get set }
    
    /// Event end time
    var endTime: Date? { get set }
    
    /// Associated place identifier
    var placeId: String? { get set }
    
    /// Event status
    var status: DNSStatus { get set }
    
    /// Event visibility
    var visibility: DNSVisibility { get set }
}

/// Protocol for Event Day Data Access Objects
public protocol DAOEventDayProtocol: DAOBaseObjectProtocol {
    /// Associated event identifier
    var eventId: String { get set }
    
    /// Event day date
    var date: Date { get set }
    
    /// Day start time
    var startTime: Date? { get set }
    
    /// Day end time
    var endTime: Date? { get set }
    
    /// Day items
    var items: [any DAOEventDayItemProtocol] { get set }
    
    /// Day status
    var status: DNSStatus { get set }
}

/// Protocol for Event Day Item Data Access Objects
public protocol DAOEventDayItemProtocol: DAOBaseObjectProtocol {
    /// Associated event day identifier
    var eventDayId: String { get set }
    
    /// Item name
    var name: String { get set }
    
    /// Item description
    var itemDescription: String? { get set }
    
    /// Item start time
    var startTime: Date? { get set }
    
    /// Item end time
    var endTime: Date? { get set }
    
    /// Item status
    var status: DNSStatus { get set }
}

// MARK: - Communication Protocols

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

/// Protocol for Announcement Data Access Objects
public protocol DAOAnnouncementProtocol: DAOBaseObjectProtocol {
    /// Announcement title
    var title: String { get set }
    
    /// Announcement content
    var content: String { get set }
    
    /// Announcement author identifier
    var authorId: String? { get set }
    
    /// Announcement publish date
    var publishDate: Date? { get set }
    
    /// Announcement expiry date
    var expiryDate: Date? { get set }
    
    /// Announcement status
    var status: DNSStatus { get set }
    
    /// Announcement visibility
    var visibility: DNSVisibility { get set }
}

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