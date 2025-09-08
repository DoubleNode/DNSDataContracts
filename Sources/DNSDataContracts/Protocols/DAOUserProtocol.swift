//
//  DAOUserProtocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

/// Protocol for User Data Access Objects
public protocol DAOUserProtocol: DAOBaseObjectProtocol {
    /// User's username/login identifier
    var username: String? { get set }
    
    /// User's email address
    var email: String? { get set }
    
    /// User's display name
    var displayName: String? { get set }
    
    /// User's first name
    var firstName: String? { get set }
    
    /// User's last name
    var lastName: String? { get set }
    
    /// User's phone number
    var phoneNumber: String? { get set }
    
    /// User type classification
    var userType: DNSUserType { get set }
    
    /// User role within the system
    var userRole: DNSUserRole { get set }
    
    /// User's current status
    var status: DNSStatus { get set }
    
    /// User's visibility settings
    var visibility: DNSVisibility { get set }
}