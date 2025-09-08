//
//  DAOAnnouncementProtocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import Foundation

// MARK: - Announcement Protocols

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
