//
//  DAOAccountLinkRequestProtocolTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts Tests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import XCTest
@testable import DNSDataContracts

final class DAOAccountLinkRequestProtocolTests: XCTestCase {
    
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
    
    struct MockAccountLinkRequest: DAOAccountLinkRequestProtocol {
        var id: String = "link_request_123"
        var meta: any DAOMetadataProtocol = MockMetadata()
        var analyticsData: [any DAOAnalyticsDataProtocol] = []
        
        var accountId: String = "account_123"
        var userId: String = "user_456"
        var status: DNSStatus = .open
        var linkType: String = "member"
    }
    
    // MARK: - DAOAccountLinkRequestProtocol Tests
    
    func testAccountLinkRequestProtocolInheritance() throws {
        let linkRequest = MockAccountLinkRequest()
        
        XCTAssertTrue(linkRequest is DAOBaseObjectProtocol)
        XCTAssertTrue(linkRequest is DAOAccountLinkRequestProtocol)
        
        XCTAssertEqual(linkRequest.id, "link_request_123")
        XCTAssertNotNil(linkRequest.meta)
    }
    
    func testAccountLinkRequestProperties() throws {
        let linkRequest = MockAccountLinkRequest()
        
        XCTAssertEqual(linkRequest.accountId, "account_123")
        XCTAssertEqual(linkRequest.userId, "user_456")
        XCTAssertEqual(linkRequest.status, .open)
        XCTAssertEqual(linkRequest.linkType, "member")
    }
    
    func testAccountLinkRequestMutability() throws {
        var linkRequest = MockAccountLinkRequest()
        
        linkRequest.accountId = "account_456"
        XCTAssertEqual(linkRequest.accountId, "account_456")
        
        linkRequest.userId = "user_789"
        XCTAssertEqual(linkRequest.userId, "user_789")
        
        linkRequest.status = .closed
        XCTAssertEqual(linkRequest.status, .closed)
        
        linkRequest.linkType = "admin"
        XCTAssertEqual(linkRequest.linkType, "admin")
    }
    
    // MARK: - Protocol as Type Tests
    
    func testAccountLinkRequestProtocolAsType() throws {
        let linkRequests: [any DAOAccountLinkRequestProtocol] = [
            MockAccountLinkRequest()
        ]
        
        XCTAssertEqual(linkRequests.count, 1)
        
        if let firstRequest = linkRequests.first {
            XCTAssertEqual(firstRequest.id, "link_request_123")
            XCTAssertEqual(firstRequest.accountId, "account_123")
            XCTAssertEqual(firstRequest.linkType, "member")
        } else {
            XCTFail("Should have first link request")
        }
    }
    
    // MARK: - Error Handling Tests
    
    func testAccountLinkRequestProtocolValidation() throws {
        var linkRequest = MockAccountLinkRequest()
        
        // Test empty IDs and link type
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
        let linkRequest = MockAccountLinkRequest()
        
        // Test protocol conformance
        XCTAssertTrue(linkRequest is DAOAccountLinkRequestProtocol)
        
        // Test base object conformance
        XCTAssertTrue(linkRequest is DAOBaseObjectProtocol)
        
        // Test type checking with casting
        XCTAssertNotNil(linkRequest as? DAOAccountLinkRequestProtocol)
        XCTAssertNotNil(linkRequest as? DAOBaseObjectProtocol)
    }
}
