//
//  DAOAlertProtocolTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts Tests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import XCTest
@testable import DNSDataContracts

final class DAOAlertProtocolTests: XCTestCase {
    
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
    
    struct MockAlert: DAOAlertProtocol {
        var id: String = "alert_123"
        var meta: any DAOMetadataProtocol = MockMetadata()
        var analyticsData: [any DAOAnalyticsDataProtocol] = []
        
        var title: String = "Test Alert"
        var message: String = "This is a test alert message."
        var alertType: String = "info"
        var userId: String? = "user_456"
        var isRead: Bool = false
        var timestamp: Date = Date()
        var status: DNSStatus = .open
    }
    
    // MARK: - Alert Protocol Tests
    
    func testDAOAlertProtocolInheritance() throws {
        let alert = MockAlert()
        
        XCTAssertTrue(alert is DAOBaseObjectProtocol)
        XCTAssertTrue(alert is DAOAlertProtocol)
        
        XCTAssertEqual(alert.id, "alert_123")
        XCTAssertNotNil(alert.meta)
    }
    
    func testAlertProtocolProperties() throws {
        let alert = MockAlert()
        
        XCTAssertEqual(alert.title, "Test Alert")
        XCTAssertEqual(alert.message, "This is a test alert message.")
        XCTAssertEqual(alert.alertType, "info")
        XCTAssertEqual(alert.userId, "user_456")
        XCTAssertFalse(alert.isRead)
        XCTAssertNotNil(alert.timestamp)
        XCTAssertEqual(alert.status, .open)
    }
    
    func testAlertTypeValues() throws {
        var alert = MockAlert()
        
        let alertTypes = ["info", "warning", "error", "success", "notification"]
        
        for alertType in alertTypes {
            alert.alertType = alertType
            XCTAssertEqual(alert.alertType, alertType)
        }
    }
    
    func testAlertReadStatus() throws {
        var alert = MockAlert()
        
        // Test unread alert
        alert.isRead = false
        XCTAssertFalse(alert.isRead)
        
        // Test marking as read
        alert.isRead = true
        XCTAssertTrue(alert.isRead)
    }
    
    // MARK: - Protocol as Type Tests
    
    func testAlertProtocolAsType() throws {
        let alert: any DAOAlertProtocol = MockAlert()
        
        XCTAssertEqual(alert.id, "alert_123")
        
        // Test protocol arrays
        let alertObjects: [any DAOBaseObjectProtocol] = [alert]
        XCTAssertEqual(alertObjects.count, 1)
    }
    
    // MARK: - Integration Tests
    
    func testAlertIntegration() throws {
        let alert = MockAlert()
        
        // Test alert belongs to user
        XCTAssertEqual(alert.userId, "user_456")
        
        // Test alert type and read status
        XCTAssertEqual(alert.alertType, "info")
        XCTAssertFalse(alert.isRead)
    }
    
    // MARK: - Error Handling Tests
    
    func testAlertProtocolValidation() throws {
        var alert = MockAlert()
        
        // Test empty titles and messages
        alert.title = ""
        alert.message = ""
        
        XCTAssertEqual(alert.title, "")
        XCTAssertEqual(alert.message, "")
        
        // Test required properties remain valid
        XCTAssertNotEqual(alert.id, "")
    }
    
    func testProtocolInstanceChecking() throws {
        let alert = MockAlert()
        
        // Test protocol conformance
        XCTAssertTrue(alert is DAOAlertProtocol)
        
        // Test base object conformance
        XCTAssertTrue(alert is DAOBaseObjectProtocol)
    }
}
