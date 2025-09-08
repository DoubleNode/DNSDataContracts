//
//  DAOApplicationProtocolTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts Tests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import XCTest
@testable import DNSDataContracts

final class DAOApplicationProtocolTests: XCTestCase {
    
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
    
    struct MockApplication: DAOApplicationProtocol {
        var id: String = "application_123"
        var meta: any DAOMetadataProtocol = MockMetadata()
        var analyticsData: [any DAOAnalyticsDataProtocol] = []
        
        var name: String = "Test Application"
        var appDescription: String? = "A test application"
        var version: String? = "2.1.0"
        var bundleId: String? = "com.example.testapp"
        var status: DNSStatus = .open
    }
    
    struct MockAppEvent: DAOAppEventProtocol {
        var id: String = "app_event_123"
        var meta: any DAOMetadataProtocol = MockMetadata()
        var analyticsData: [any DAOAnalyticsDataProtocol] = []
        
        var name: String = "user_login"
        var eventType: String = "authentication"
        var userId: String? = "user_456"
        var timestamp: Date = Date()
        var eventData: [String: Any]? = ["success": true, "method": "password"]
    }
    
    // MARK: - Application Protocol Tests
    
    func testDAOApplicationProtocolInheritance() throws {
        let application = MockApplication()
        
        // Verify protocol conformance through required property access
        XCTAssertFalse(application.id.isEmpty)
        XCTAssertNotNil(application.meta)
        
        XCTAssertEqual(application.id, "application_123")
        XCTAssertNotNil(application.meta)
    }
    
    func testApplicationProtocolProperties() throws {
        let application = MockApplication()
        
        XCTAssertEqual(application.name, "Test Application")
        XCTAssertEqual(application.appDescription, "A test application")
        XCTAssertEqual(application.version, "2.1.0")
        XCTAssertEqual(application.bundleId, "com.example.testapp")
        XCTAssertEqual(application.status, .open)
    }
    
    func testAppEventProperties() throws {
        let appEvent = MockAppEvent()
        
        XCTAssertEqual(appEvent.name, "user_login")
        XCTAssertEqual(appEvent.eventType, "authentication")
        XCTAssertEqual(appEvent.userId, "user_456")
        XCTAssertNotNil(appEvent.timestamp)
        XCTAssertNotNil(appEvent.eventData)
        
        if let eventData = appEvent.eventData {
            XCTAssertEqual(eventData["success"] as? Bool, true)
            XCTAssertEqual(eventData["method"] as? String, "password")
        }
    }
    
    func testAppEventDataHandling() throws {
        var appEvent = MockAppEvent()
        
        // Test different event data types
        let loginData: [String: Any] = [
            "success": true,
            "method": "oauth",
            "provider": "google",
            "timestamp": Date(),
            "location": ["lat": 37.7749, "lng": -122.4194]
        ]
        
        appEvent.eventData = loginData
        
        if let eventData = appEvent.eventData {
            XCTAssertEqual(eventData["success"] as? Bool, true)
            XCTAssertEqual(eventData["method"] as? String, "oauth")
            XCTAssertEqual(eventData["provider"] as? String, "google")
            XCTAssertNotNil(eventData["timestamp"] as? Date)
            XCTAssertNotNil(eventData["location"] as? [String: Double])
        }
    }
    
    // MARK: - Protocol as Type Tests
    
    func testApplicationProtocolsAsTypes() throws {
        let application: any DAOApplicationProtocol = MockApplication()
        let appEvent: any DAOAppEventProtocol = MockAppEvent()
        
        XCTAssertEqual(application.id, "application_123")
        XCTAssertEqual(appEvent.id, "app_event_123")
        
        // Test protocol arrays
        let appObjects: [any DAOBaseObjectProtocol] = [application, appEvent]
        XCTAssertEqual(appObjects.count, 2)
        
        // Test type filtering
        let applications = appObjects.compactMap { $0 as? DAOApplicationProtocol }
        let appEvents = appObjects.compactMap { $0 as? DAOAppEventProtocol }
        
        XCTAssertEqual(applications.count, 1)
        XCTAssertEqual(appEvents.count, 1)
    }
    
    // MARK: - Integration Tests
    
    func testApplicationIntegration() throws {
        let application = MockApplication()
        let appEvent = MockAppEvent()
        
        // Test app event relates to application lifecycle
        XCTAssertEqual(application.name, "Test Application")
        XCTAssertEqual(appEvent.name, "user_login")
        
        // Test event tracking within application
        XCTAssertEqual(appEvent.eventType, "authentication")
        XCTAssertNotNil(appEvent.userId)
    }
    
    // MARK: - Error Handling Tests
    
    func testApplicationProtocolValidation() throws {
        var application = MockApplication()
        var appEvent = MockAppEvent()
        
        // Test empty names and required fields
        application.name = ""
        appEvent.name = ""
        appEvent.eventType = ""
        
        XCTAssertEqual(application.name, "")
        XCTAssertEqual(appEvent.name, "")
        XCTAssertEqual(appEvent.eventType, "")
        
        // Test required properties remain valid
        XCTAssertNotEqual(application.id, "")
        XCTAssertNotEqual(appEvent.id, "")
    }
    
    func testProtocolInstanceChecking() throws {
        let application = MockApplication()
        let appEvent = MockAppEvent()
        
        // Test protocol conformance by validating required properties exist and have expected values
        XCTAssertFalse(application.id.isEmpty)
        XCTAssertFalse(appEvent.id.isEmpty)
        
        // Test base object conformance by validating metadata exists
        XCTAssertNotNil(application.meta)
        XCTAssertNotNil(appEvent.meta)
    }
}
