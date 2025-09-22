//
//  DAOMetadataProtocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import Foundation

/// Protocol defining the interface for metadata objects without concrete dependencies
public protocol DAOMetadataProtocol {
    /// Unique identifier for the metadata
    var uid: UUID { get set }
    
    /// Creation timestamp
    var created: Date { get set }
    
    /// Last synchronization timestamp
    var synced: Date? { get set }
    
    /// Last update timestamp
    var updated: Date { get set }
    
    /// Object status
    var status: String { get set }
    
    /// Who created this object
    var createdBy: String { get set }
    
    /// Who last updated this object
    var updatedBy: String { get set }
    
    /// Generic key-value storage for extensibility
    var genericValues: DNSDataDictionary { get set }

    ///
    var reactions: [String: DNSUserReaction] { get set }
    
    var reactionCounts: DNSReactionCounts { get set }
    
    var userReaction: DNSUserReaction? { get set }
    
    /// View count
    var views: UInt { get set }
}
