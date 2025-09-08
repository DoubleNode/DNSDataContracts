//
//  SharedTypes.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

// MARK: - User Types

/// User type enumeration
public enum DNSUserType: String, CaseIterable {
    case admin
    case user
    case guest
    case system
}

/// User role enumeration  
public enum DNSUserRole: String, CaseIterable {
    case owner
    case admin
    case manager
    case member
    case viewer
    case guest
}

// MARK: - Status Types

/// General status enumeration
public enum DNSStatus: String, CaseIterable {
    case active
    case inactive
    case pending
    case suspended
    case deleted
    case draft
    case published
    case archived
}

/// Visibility enumeration
public enum DNSVisibility: String, CaseIterable {
    case `public`
    case `private`
    case friends
    case limited
    case hidden
}

// MARK: - Time Types

/// Daily hours structure
public struct DNSDailyHours {
    public var openTime: Date?
    public var closeTime: Date?
    public var isClosed: Bool
    public var isAllDay: Bool
    
    public init(openTime: Date? = nil, closeTime: Date? = nil, isClosed: Bool = false, isAllDay: Bool = false) {
        self.openTime = openTime
        self.closeTime = closeTime
        self.isClosed = isClosed
        self.isAllDay = isAllDay
    }
}

/// Day of week flags
public struct DNSDayOfWeekFlags: OptionSet {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let sunday = DNSDayOfWeekFlags(rawValue: 1 << 0)
    public static let monday = DNSDayOfWeekFlags(rawValue: 1 << 1)
    public static let tuesday = DNSDayOfWeekFlags(rawValue: 1 << 2)
    public static let wednesday = DNSDayOfWeekFlags(rawValue: 1 << 3)
    public static let thursday = DNSDayOfWeekFlags(rawValue: 1 << 4)
    public static let friday = DNSDayOfWeekFlags(rawValue: 1 << 5)
    public static let saturday = DNSDayOfWeekFlags(rawValue: 1 << 6)
    
    public static let weekdays: DNSDayOfWeekFlags = [.monday, .tuesday, .wednesday, .thursday, .friday]
    public static let weekend: DNSDayOfWeekFlags = [.saturday, .sunday]
    public static let all: DNSDayOfWeekFlags = [.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday]
}

// MARK: - Pricing Types

/// Price structure
public struct DNSPrice {
    public var amount: Decimal
    public var currency: String
    public var displayString: String?
    
    public init(amount: Decimal, currency: String = "USD", displayString: String? = nil) {
        self.amount = amount
        self.currency = currency
        self.displayString = displayString
    }
}

// MARK: - Media Types

/// Media type enumeration
public enum DNSMediaType: String, CaseIterable {
    case image
    case video
    case audio
    case document
    case other
}

// MARK: - System Types

/// System state enumeration
public enum DNSSystemState: String, CaseIterable {
    case online
    case offline
    case maintenance
    case error
    case degraded
    case unknown
}

// MARK: - Order Types

/// Order state enumeration
public enum DNSOrderState: String, CaseIterable {
    case pending
    case confirmed
    case processing
    case shipped
    case delivered
    case cancelled
    case refunded
    case failed
}

// MARK: - Reaction Types

/// Reaction type enumeration
public enum DNSReactionType: String, CaseIterable {
    case like
    case love
    case laugh
    case wow
    case sad
    case angry
    case dislike
}

/// User reaction structure
public struct DNSUserReaction {
    public var userId: String
    public var reactionType: DNSReactionType
    public var timestamp: Date
    
    public init(userId: String, reactionType: DNSReactionType, timestamp: Date = Date()) {
        self.userId = userId
        self.reactionType = reactionType
        self.timestamp = timestamp
    }
}

/// Reaction counts structure
public struct DNSReactionCounts {
    public var like: Int
    public var love: Int
    public var laugh: Int
    public var wow: Int
    public var sad: Int
    public var angry: Int
    public var dislike: Int
    
    public init() {
        self.like = 0
        self.love = 0
        self.laugh = 0
        self.wow = 0
        self.sad = 0
        self.angry = 0
        self.dislike = 0
    }
}