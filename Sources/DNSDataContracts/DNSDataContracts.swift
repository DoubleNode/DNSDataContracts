//
//  DNSDataContracts.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

/// DNSDataContracts module provides protocol definitions for Data Access Objects
/// without creating circular dependencies between DNSProtocols and DNSDataObjects.
///
/// This module contains:
/// - Base object protocols
/// - User and account protocols
/// - Place and location protocols
/// - Commerce and pricing protocols
/// - Content and media protocols
/// - System and activity protocols
/// - Shared type definitions
///
/// Usage:
/// ```swift
/// import DNSDataContracts
/// 
/// // Use protocols in worker definitions
/// func doLoadUser(for id: String) -> (any DAOUserProtocol)?
/// ```

// Re-export all protocols and types for convenience
@_exported import struct DNSCore.DNSMetadata
@_exported import struct DNSCore.DNSDataDictionary

// Note: Individual protocol files are automatically available when importing DNSDataContracts