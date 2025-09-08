//
//  DAOAccountProtocolTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts Tests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
@testable import DNSDataContracts

final class DAOAccountProtocolTests: XCTestCase {
    
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
    
    struct MockAccount: DAOAccountProtocol {
        var id: String = "account_123"
        var meta: any DAOMetadataProtocol = MockMetadata()
        var analyticsData: [any DAOAnalyticsDataProtocol] = []
        
        var name: String = "Test Account"
        var displayName: String? = "Test Account Display"
        var status: DNSStatus = .open
        var visibility: DNSVisibility = .everyone
        var accountType: String? = "business"
    }
    
    struct MockAccountLinkRequest: DAOAccountLinkRequestProtocol {
        var id: String = "link_request_123"
        var meta: any DAOMetadataProtocol = MockMetadata()
        var analyticsData: [any DAOAnalyticsDataProtocol] = []
        
        var accountId: String = "account_123"
        var userId: String = "user_456"
        var status: DNSStatus = .open
        var linkType: String = "member"
    }
    
    // MARK: - DAOAccountProtocol Tests
    
    func testDAOAccountProtocolInheritance() throws {
        let account = MockAccount()
        
        // Test that DAOAccountProtocol inherits from DAOBaseObjectProtocol
        XCTAssertTrue(account is DAOBaseObjectProtocol)
        XCTAssertTrue(account is DAOAccountProtocol)
        
        // Test base object properties
        XCTAssertEqual(account.id, "account_123")
        XCTAssertNotNil(account.meta)
        XCTAssertTrue(account.analyticsData.isEmpty)
    }
    
    func testAccountProtocolProperties() throws {
        let account = MockAccount()
        
        // Test account-specific properties
        XCTAssertEqual(account.name, "Test Account")
        XCTAssertEqual(account.displayName, "Test Account Display")
        XCTAssertEqual(account.status, .open)
        XCTAssertEqual(account.visibility, .everyone)
        XCTAssertEqual(account.accountType, "business")
    }
    
    func testAccountProtocolMutability() throws {
        var account = MockAccount()
        
        // Test property mutability
        account.name = "Updated Account Name"
        XCTAssertEqual(account.name, "Updated Account Name")
        
        account.displayName = "Updated Display Name"
        XCTAssertEqual(account.displayName, "Updated Display Name")
        
        account.status = .closed
        XCTAssertEqual(account.status, .closed)
        
        account.visibility = .staffOnly
        XCTAssertEqual(account.visibility, .staffOnly)
        
        account.accountType = "personal"
        XCTAssertEqual(account.accountType, "personal")
    }
    
    func testAccountOptionalProperties() throws {
        var account = MockAccount()
        
        // Test setting optional properties to nil
        account.displayName = nil
        account.accountType = nil
        
        XCTAssertNil(account.displayName)
        XCTAssertNil(account.accountType)
        
        // Required properties should still have values
        XCTAssertFalse(account.name.isEmpty)
        XCTAssertNotNil(account.status)
        XCTAssertNotNil(account.visibility)
    }
    
    func testAccountStatusValues() throws {
        var account = MockAccount()
        
        let statuses: [DNSStatus] = [.open, .closed, .maintenance, .hidden]
        
        for status in statuses {
            account.status = status
            XCTAssertEqual(account.status, status)
        }
    }
    
    func testAccountVisibilityValues() throws {
        var account = MockAccount()
        
        let visibilities: [DNSVisibility] = [.everyone, .staffOnly, .adminOnly, .adultsOnly, .staffYouth]
        
        for visibility in visibilities {
            account.visibility = visibility
            XCTAssertEqual(account.visibility, visibility)
        }
    }
    
    // MARK: - DAOAccountLinkRequestProtocol Tests
    
    func testAccountLinkRequestProtocolInheritance() throws {
        let linkRequest = MockAccountLinkRequest()
        
        // Test that DAOAccountLinkRequestProtocol inherits from DAOBaseObjectProtocol
        XCTAssertTrue(linkRequest is DAOBaseObjectProtocol)
        XCTAssertTrue(linkRequest is DAOAccountLinkRequestProtocol)
        
        // Test base object properties
        XCTAssertEqual(linkRequest.id, "link_request_123")
        XCTAssertNotNil(linkRequest.meta)
        XCTAssertTrue(linkRequest.analyticsData.isEmpty)
    }
    
    func testAccountLinkRequestProperties() throws {
        let linkRequest = MockAccountLinkRequest()
        
        // Test link request specific properties
        XCTAssertEqual(linkRequest.accountId, "account_123")
        XCTAssertEqual(linkRequest.userId, "user_456")
        XCTAssertEqual(linkRequest.status, .open)
        XCTAssertEqual(linkRequest.linkType, "member")
    }
    
    func testAccountLinkRequestMutability() throws {
        var linkRequest = MockAccountLinkRequest()
        
        // Test property mutability
        linkRequest.accountId = "account_789"
        XCTAssertEqual(linkRequest.accountId, "account_789")
        
        linkRequest.userId = "user_999"
        XCTAssertEqual(linkRequest.userId, "user_999")
        
        linkRequest.status = .open
        XCTAssertEqual(linkRequest.status, .open)
        
        linkRequest.linkType = "admin"
        XCTAssertEqual(linkRequest.linkType, "admin")
    }
    
    func testLinkRequestStatusTransitions() throws {
        var linkRequest = MockAccountLinkRequest()
        
        // Test status transitions
        linkRequest.status = .open
        XCTAssertEqual(linkRequest.status, .open)
        
        linkRequest.status = .closed
        XCTAssertEqual(linkRequest.status, .closed)
        
        linkRequest.status = .maintenance
        XCTAssertEqual(linkRequest.status, .maintenance)
        
        linkRequest.status = .hidden
        XCTAssertEqual(linkRequest.status, .hidden)
    }
    
    // MARK: - Business Logic Tests
    
    func testAccountBusinessLogic() throws {
        var account = MockAccount()
        
        // Test account name requirements
        XCTAssertFalse(account.name.isEmpty)
        
        // Test display name fallback
        account.displayName = nil
        // In a real implementation, display name might fall back to name
        let effectiveDisplayName = account.displayName ?? account.name
        XCTAssertEqual(effectiveDisplayName, "Test Account")
        
        // Test account type categorization
        let businessTypes = ["business", "enterprise", "corporate"]
        let personalTypes = ["personal", "individual", "private"]
        
        for businessType in businessTypes {
            account.accountType = businessType
            XCTAssertEqual(account.accountType, businessType)
        }
        
        for personalType in personalTypes {
            account.accountType = personalType
            XCTAssertEqual(account.accountType, personalType)
        }
    }
    
    func testLinkRequestBusinessLogic() throws {
        let linkRequest = MockAccountLinkRequest()
        
        // Test relationship validation
        XCTAssertNotEqual(linkRequest.accountId, linkRequest.userId)
        XCTAssertFalse(linkRequest.accountId.isEmpty)
        XCTAssertFalse(linkRequest.userId.isEmpty)
        
        // Test link type validation
        let validLinkTypes = ["member", "admin", "owner", "viewer", "editor"]
        for linkType in validLinkTypes {
            var mutableRequest = linkRequest
            mutableRequest.linkType = linkType
            XCTAssertEqual(mutableRequest.linkType, linkType)
        }
    }
    
    // MARK: - Account Type Tests
    
    func testAccountTypeCategories() throws {
        var account = MockAccount()
        
        // Test business account types
        let businessTypes = ["business", "enterprise", "organization", "company"]
        for type in businessTypes {
            account.accountType = type
            XCTAssertEqual(account.accountType, type)
        }
        
        // Test personal account types
        let personalTypes = ["personal", "individual", "family"]
        for type in personalTypes {
            account.accountType = type
            XCTAssertEqual(account.accountType, type)
        }
        
        // Test special account types
        let specialTypes = ["system", "service", "bot", "test"]
        for type in specialTypes {
            account.accountType = type
            XCTAssertEqual(account.accountType, type)
        }
    }
    
    // MARK: - Protocol as Type Tests
    
    func testAccountProtocolAsType() throws {
        let accounts: [any DAOAccountProtocol] = [
            MockAccount()
        ]
        
        XCTAssertEqual(accounts.count, 1)
        
        if let firstAccount = accounts.first {
            XCTAssertEqual(firstAccount.id, "account_123")
            XCTAssertEqual(firstAccount.name, "Test Account")
            XCTAssertEqual(firstAccount.status, .open)
        } else {
            XCTFail("Should have first account")
        }
    }
    
    func testLinkRequestProtocolAsType() throws {
        let linkRequests: [any DAOAccountLinkRequestProtocol] = [
            MockAccountLinkRequest()
        ]
        
        XCTAssertEqual(linkRequests.count, 1)
        
        if let firstRequest = linkRequests.first {
            XCTAssertEqual(firstRequest.id, "link_request_123")
            XCTAssertEqual(firstRequest.accountId, "account_123")
            XCTAssertEqual(firstRequest.userId, "user_456")
            XCTAssertEqual(firstRequest.status, .open)
        } else {
            XCTFail("Should have first link request")
        }
    }
    
    func testMixedProtocolArrays() throws {
        let account = MockAccount()
        let linkRequest = MockAccountLinkRequest()
        
        // Test array of base objects containing different protocol implementations
        let baseObjects: [any DAOBaseObjectProtocol] = [account, linkRequest]
        
        XCTAssertEqual(baseObjects.count, 2)
        XCTAssertEqual(baseObjects[0].id, "account_123")
        XCTAssertEqual(baseObjects[1].id, "link_request_123")
        
        // Test type checking
        XCTAssertTrue(baseObjects[0] is DAOAccountProtocol)
        XCTAssertTrue(baseObjects[1] is DAOAccountLinkRequestProtocol)
        XCTAssertFalse(baseObjects[0] is DAOAccountLinkRequestProtocol)
        XCTAssertFalse(baseObjects[1] is DAOAccountProtocol)
    }
    
    // MARK: - Integration Tests
    
    func testAccountWithBaseObjectProtocol() throws {
        let account: any DAOBaseObjectProtocol = MockAccount()
        
        // Test base protocol access
        XCTAssertEqual(account.id, "account_123")
        XCTAssertNotNil(account.meta)
        
        // Test downcasting to account protocol
        if let accountObject = account as? DAOAccountProtocol {
            XCTAssertEqual(accountObject.name, "Test Account")
            XCTAssertEqual(accountObject.accountType, "business")
        } else {
            XCTFail("Should be able to cast to DAOAccountProtocol")
        }
    }
    
    func testLinkRequestWithBaseObjectProtocol() throws {
        let linkRequest: any DAOBaseObjectProtocol = MockAccountLinkRequest()
        
        // Test base protocol access
        XCTAssertEqual(linkRequest.id, "link_request_123")
        XCTAssertNotNil(linkRequest.meta)
        
        // Test downcasting to link request protocol
        if let requestObject = linkRequest as? DAOAccountLinkRequestProtocol {
            XCTAssertEqual(requestObject.accountId, "account_123")
            XCTAssertEqual(requestObject.linkType, "member")
        } else {
            XCTFail("Should be able to cast to DAOAccountLinkRequestProtocol")
        }
    }
    
    // MARK: - Error Handling Tests
    
    func testAccountProtocolValidation() throws {
        var account = MockAccount()
        
        // Test empty name handling
        account.name = ""
        XCTAssertEqual(account.name, "")
        
        // Test required properties remain valid
        XCTAssertNotEqual(account.id, "")
        XCTAssertNotNil(account.status)
        XCTAssertNotNil(account.visibility)
    }
    
    func testLinkRequestValidation() throws {
        var linkRequest = MockAccountLinkRequest()
        
        // Test empty ID handling
        linkRequest.accountId = ""
        linkRequest.userId = ""
        linkRequest.linkType = ""
        
        XCTAssertEqual(linkRequest.accountId, "")
        XCTAssertEqual(linkRequest.userId, "")
        XCTAssertEqual(linkRequest.linkType, "")
        
        // Test required properties remain valid
        XCTAssertNotEqual(linkRequest.id, "")
        XCTAssertNotNil(linkRequest.status)
    }
    
    func testProtocolInstanceChecking() throws {
        let account = MockAccount()
        let linkRequest = MockAccountLinkRequest()
        
        // Test protocol conformance
        XCTAssertTrue(account is DAOAccountProtocol)
        XCTAssertTrue(account is DAOBaseObjectProtocol)
        XCTAssertTrue(linkRequest is DAOAccountLinkRequestProtocol)
        XCTAssertTrue(linkRequest is DAOBaseObjectProtocol)
        
        // Test type checking
        XCTAssertTrue(type(of: account) is DAOAccountProtocol.Type)
        XCTAssertTrue(type(of: linkRequest) is DAOAccountLinkRequestProtocol.Type)
    }
    
    // MARK: - Relationship Tests
    
    func testAccountLinkRequestRelationship() throws {
        let account = MockAccount()
        let linkRequest = MockAccountLinkRequest()
        
        // Test that link request references the account
        XCTAssertEqual(linkRequest.accountId, account.id)
        
        // Test multiple link requests for same account
        var linkRequest2 = MockAccountLinkRequest()
        linkRequest2.id = "link_request_456"
        linkRequest2.userId = "user_789"
        linkRequest2.linkType = "admin"
        
        let linkRequests = [linkRequest, linkRequest2]
        let accountLinkRequests = linkRequests.filter { $0.accountId == account.id }
        
        XCTAssertEqual(accountLinkRequests.count, 2)
        XCTAssertEqual(accountLinkRequests[0].userId, "user_456")
        XCTAssertEqual(accountLinkRequests[1].userId, "user_789")
    }
}