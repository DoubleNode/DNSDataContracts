//
//  DAOUserProtocolTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts Tests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
@testable import DNSDataContracts

final class DAOUserProtocolTests: XCTestCase {
    
    // MARK: - Mock Implementations
    
    struct MockMetadata: DAOMetadataProtocol {
        var uid: UUID = UUID()
        var created: Date = Date()
        var synced: Date? = nil
        var updated: Date = Date()
        var status: String = "active"
        var createdBy: String = "system"
        var updatedBy: String = "system"
        var genericValues: DNSDataDictionary = [:]
        var views: UInt = 0
    }
    
    struct MockUser: DAOUserProtocol {
        var id: String = "user_123"
        var meta: any DAOMetadataProtocol = MockMetadata()
        var analyticsData: [any DAOAnalyticsDataProtocol] = []
        
        var username: String? = "testuser"
        var email: String? = "test@example.com"
        var displayName: String? = "Test User"
        var firstName: String? = "Test"
        var lastName: String? = "User"
        var phoneNumber: String? = "+1234567890"
        var userType: DNSUserType = .adult
        var userRole: DNSUserRole = .endUser
        var status: DNSStatus = .open
        var visibility: DNSVisibility = .everyone
    }
    
    // MARK: - Protocol Conformance Tests
    
    func testDAOUserProtocolInheritance() throws {
        let user = MockUser()
        
        // Test that DAOUserProtocol inherits from DAOBaseObjectProtocol
        XCTAssertTrue(user is DAOBaseObjectProtocol)
        XCTAssertTrue(user is DAOUserProtocol)
        
        // Test base object properties
        XCTAssertEqual(user.id, "user_123")
        XCTAssertNotNil(user.meta)
        XCTAssertTrue(user.analyticsData.isEmpty)
    }
    
    func testUserProtocolProperties() throws {
        let user = MockUser()
        
        // Test user-specific properties
        XCTAssertEqual(user.username, "testuser")
        XCTAssertEqual(user.email, "test@example.com")
        XCTAssertEqual(user.displayName, "Test User")
        XCTAssertEqual(user.firstName, "Test")
        XCTAssertEqual(user.lastName, "User")
        XCTAssertEqual(user.phoneNumber, "+1234567890")
        XCTAssertEqual(user.userType, .adult)
        XCTAssertEqual(user.userRole, .endUser)
        XCTAssertEqual(user.status, .open)
        XCTAssertEqual(user.visibility, .everyone)
    }
    
    func testUserProtocolMutability() throws {
        var user = MockUser()
        
        // Test property mutability
        user.username = "newusername"
        XCTAssertEqual(user.username, "newusername")
        
        user.email = "new@example.com"
        XCTAssertEqual(user.email, "new@example.com")
        
        user.displayName = "New Display Name"
        XCTAssertEqual(user.displayName, "New Display Name")
        
        user.firstName = "New"
        XCTAssertEqual(user.firstName, "New")
        
        user.lastName = "Name"
        XCTAssertEqual(user.lastName, "Name")
        
        user.phoneNumber = "+9876543210"
        XCTAssertEqual(user.phoneNumber, "+9876543210")
        
        user.userType = .child
        XCTAssertEqual(user.userType, .child)
        
        user.userRole = .placeAdmin
        XCTAssertEqual(user.userRole, .placeAdmin)
        
        user.status = .closed
        XCTAssertEqual(user.status, .closed)
        
        user.visibility = .adminOnly
        XCTAssertEqual(user.visibility, .adminOnly)
    }
    
    // MARK: - Optional Property Tests
    
    func testOptionalProperties() throws {
        var user = MockUser()
        
        // Test setting optional properties to nil
        user.username = nil
        user.email = nil
        user.displayName = nil
        user.firstName = nil
        user.lastName = nil
        user.phoneNumber = nil
        
        XCTAssertNil(user.username)
        XCTAssertNil(user.email)
        XCTAssertNil(user.displayName)
        XCTAssertNil(user.firstName)
        XCTAssertNil(user.lastName)
        XCTAssertNil(user.phoneNumber)
        
        // Required properties should still have values
        XCTAssertEqual(user.userType, .adult)
        XCTAssertEqual(user.userRole, .endUser)
        XCTAssertEqual(user.status, .open)
        XCTAssertEqual(user.visibility, .everyone)
    }
    
    // MARK: - Enum Value Tests
    
    func testDNSUserTypeValues() throws {
        var user = MockUser()
        
        let userTypes: [DNSUserType] = [.adult, .child, .youth, .pendingAdult]
        
        for userType in userTypes {
            user.userType = userType
            XCTAssertEqual(user.userType, userType)
        }
    }
    
    func testDNSUserRoleValues() throws {
        var user = MockUser()
        
        let userRoles: [DNSUserRole] = [.endUser, .placeAdmin, .supportAdmin, .superUser]
        
        for userRole in userRoles {
            user.userRole = userRole
            XCTAssertEqual(user.userRole, userRole)
        }
    }
    
    func testDNSStatusValues() throws {
        var user = MockUser()
        
        let statuses: [DNSStatus] = [.open, .closed, .maintenance, .hidden]
        
        for status in statuses {
            user.status = status
            XCTAssertEqual(user.status, status)
        }
    }
    
    func testDNSVisibilityValues() throws {
        var user = MockUser()
        
        let visibilities: [DNSVisibility] = [.everyone, .staffOnly, .adminOnly, .adultsOnly, .staffYouth]
        
        for visibility in visibilities {
            user.visibility = visibility
            XCTAssertEqual(user.visibility, visibility)
        }
    }
    
    // MARK: - Business Logic Tests
    
    func testUserDisplayName() throws {
        var user = MockUser()
        
        // Test display name fallback logic (simulated)
        user.displayName = nil
        user.firstName = "John"
        user.lastName = "Doe"
        
        // Simulate display name computation
        let computedDisplayName = [user.firstName, user.lastName].compactMap { $0 }.joined(separator: " ")
        XCTAssertEqual(computedDisplayName, "John Doe")
        
        // Test with display name provided
        user.displayName = "Custom Display Name"
        XCTAssertEqual(user.displayName, "Custom Display Name")
    }
    
    func testUserIdentificationMethods() throws {
        let user = MockUser()
        
        // Test various identification methods
        XCTAssertEqual(user.id, "user_123")
        XCTAssertEqual(user.username, "testuser")
        XCTAssertEqual(user.email, "test@example.com")
        
        // All three should be valid identifiers
        XCTAssertFalse(user.id.isEmpty)
        XCTAssertNotNil(user.username)
        XCTAssertNotNil(user.email)
    }
    
    func testUserContactInformation() throws {
        let user = MockUser()
        
        // Test contact information
        XCTAssertEqual(user.email, "test@example.com")
        XCTAssertEqual(user.phoneNumber, "+1234567890")
        
        // Test email validation (basic format check)
        if let email = user.email {
            XCTAssertTrue(email.contains("@"))
            XCTAssertTrue(email.contains("."))
        }
        
        // Test phone number format
        if let phone = user.phoneNumber {
            XCTAssertTrue(phone.hasPrefix("+"))
        }
    }
    
    // MARK: - User Permission Tests
    
    func testUserPermissionLevels() throws {
        var user = MockUser()
        
        // Test admin permissions
        user.userType = .adult
        user.userRole = .superUser
        XCTAssertEqual(user.userType, .adult)
        XCTAssertEqual(user.userRole, .superUser)
        
        // Test support admin permissions
        user.userType = .adult
        user.userRole = .supportAdmin
        XCTAssertEqual(user.userType, .adult)
        XCTAssertEqual(user.userRole, .supportAdmin)
        
        // Test regular user permissions
        user.userType = .adult
        user.userRole = .endUser
        XCTAssertEqual(user.userType, .adult)
        XCTAssertEqual(user.userRole, .endUser)
        
        // Test child user permissions
        user.userType = .child
        user.userRole = .endUser
        XCTAssertEqual(user.userType, .child)
        XCTAssertEqual(user.userRole, .endUser)
    }
    
    func testUserVisibilityLevels() throws {
        var user = MockUser()
        
        // Test everyone visibility
        user.visibility = .everyone
        XCTAssertEqual(user.visibility, .everyone)
        
        // Test adults only visibility
        user.visibility = .adultsOnly
        XCTAssertEqual(user.visibility, .adultsOnly)
        
        // Test staff youth visibility
        user.visibility = .staffYouth
        XCTAssertEqual(user.visibility, .staffYouth)
        
        // Test staff/admin visibility
        user.visibility = .staffOnly
        XCTAssertEqual(user.visibility, .staffOnly)
        
        user.visibility = .adminOnly
        XCTAssertEqual(user.visibility, .adminOnly)
    }
    
    // MARK: - User Status Tests
    
    func testUserStatusTransitions() throws {
        var user = MockUser()
        
        // Test normal open user
        user.status = .open
        XCTAssertEqual(user.status, .open)
        
        // Test closed user
        user.status = .closed
        XCTAssertEqual(user.status, .closed)
        
        // Test hidden user (e.g., not visible in listings)
        user.status = .hidden
        XCTAssertEqual(user.status, .hidden)
        
        // Test maintenance user
        user.status = .maintenance
        XCTAssertEqual(user.status, .maintenance)
        
        // Test reactivation
        user.status = .open
        XCTAssertEqual(user.status, .open)
    }
    
    // MARK: - Protocol as Type Tests
    
    func testUserProtocolAsType() throws {
        let users: [any DAOUserProtocol] = [
            MockUser()
        ]
        
        XCTAssertEqual(users.count, 1)
        
        if let firstUser = users.first {
            XCTAssertEqual(firstUser.id, "user_123")
            XCTAssertEqual(firstUser.username, "testuser")
            XCTAssertEqual(firstUser.userType, .adult)
        } else {
            XCTFail("Should have first user")
        }
    }
    
    func testUserProtocolArrayHandling() throws {
        let user1 = MockUser()
        var user2 = MockUser()
        user2.id = "user_456"
        user2.username = "seconduser"
        
        let users: [any DAOUserProtocol] = [user1, user2]
        
        XCTAssertEqual(users.count, 2)
        XCTAssertEqual(users[0].id, "user_123")
        XCTAssertEqual(users[1].id, "user_456")
        
        // Test filtering users
        let openUsers = users.filter { $0.status == .open }
        XCTAssertEqual(openUsers.count, 2)
        
        let childUsers = users.filter { $0.userType == .child }
        XCTAssertEqual(childUsers.count, 0)
    }
    
    // MARK: - Integration Tests
    
    func testUserWithBaseObjectProtocol() throws {
        let user: any DAOBaseObjectProtocol = MockUser()
        
        // Test base protocol access
        XCTAssertEqual(user.id, "user_123")
        XCTAssertNotNil(user.meta)
        
        // Test downcasting to user protocol
        if let userObject = user as? DAOUserProtocol {
            XCTAssertEqual(userObject.username, "testuser")
            XCTAssertEqual(userObject.email, "test@example.com")
        } else {
            XCTFail("Should be able to cast to DAOUserProtocol")
        }
    }
    
    func testUserMetadataIntegration() throws {
        var user = MockUser()
        var metadata = MockMetadata()
        
        // Test metadata updates
        metadata.updatedBy = user.id
        metadata.views = 10
        user.meta = metadata
        
        if let userMetadata = user.meta as? MockMetadata {
            XCTAssertEqual(userMetadata.updatedBy, "user_123")
            XCTAssertEqual(userMetadata.views, 10)
        } else {
            XCTFail("Should be able to cast metadata")
        }
    }
    
    // MARK: - Error Handling Tests
    
    func testUserProtocolValidation() throws {
        var user = MockUser()
        
        // Test empty username handling
        user.username = ""
        XCTAssertEqual(user.username, "")
        
        user.username = nil
        XCTAssertNil(user.username)
        
        // Test invalid email formats (basic validation)
        user.email = "invalid_email"
        XCTAssertEqual(user.email, "invalid_email")
        
        user.email = nil
        XCTAssertNil(user.email)
        
        // Test required properties remain valid
        XCTAssertNotEqual(user.id, "")
        XCTAssertNotNil(user.userType)
        XCTAssertNotNil(user.userRole)
        XCTAssertNotNil(user.status)
        XCTAssertNotNil(user.visibility)
    }
    
    func testUserProtocolInstanceChecking() throws {
        let user = MockUser()
        
        // Test protocol conformance
        XCTAssertTrue(user is DAOUserProtocol)
        XCTAssertTrue(user is DAOBaseObjectProtocol)
        
        // Test type checking
        XCTAssertTrue(type(of: user) is DAOUserProtocol.Type)
        XCTAssertTrue(type(of: user) is DAOBaseObjectProtocol.Type)
    }
}