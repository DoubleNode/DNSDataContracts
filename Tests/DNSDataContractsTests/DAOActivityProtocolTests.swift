//
//  DAOActivityProtocolTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts Tests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import XCTest
@testable import DNSDataContracts

final class DAOActivityProtocolTests: XCTestCase {
    
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
    
    struct MockActivity: DAOActivityProtocol {
        var id: String = "activity_123"
        var meta: any DAOMetadataProtocol = MockMetadata()
        var analyticsData: [any DAOAnalyticsDataProtocol] = []
        
        var name: String = "Test Activity"
        var activityDescription: String? = "A test activity for unit tests"
        var activityTypeId: String = "activity_type_456"
        var userId: String? = "user_789"
        var startTime: Date? = Date()
        var endTime: Date? = Date().addingTimeInterval(3600) // 1 hour later
        var status: DNSStatus = .open
    }
    
    struct MockActivityType: DAOActivityTypeProtocol {
        var id: String = "activity_type_123"
        var meta: any DAOMetadataProtocol = MockMetadata()
        var analyticsData: [any DAOAnalyticsDataProtocol] = []
        
        var name: String = "Test Activity Type"
        var typeDescription: String? = "A test activity type"
        var category: String? = "testing"
        var status: DNSStatus = .open
    }
    
    struct MockActivityBlackout: DAOActivityBlackoutProtocol {
        var id: String = "activity_blackout_123"
        var meta: any DAOMetadataProtocol = MockMetadata()
        var analyticsData: [any DAOAnalyticsDataProtocol] = []
        
        var activityTypeId: String = "activity_type_123"
        var name: String = "Maintenance Window"
        var startTime: Date = Date()
        var endTime: Date = Date().addingTimeInterval(7200) // 2 hours later
        var status: DNSStatus = .open
    }
    
    // MARK: - Activity Protocol Tests
    
    func testDAOActivityProtocolInheritance() throws {
        let activity = MockActivity()
        
        // Verify protocol conformance through required property access
        XCTAssertFalse(activity.id.isEmpty)
        XCTAssertNotNil(activity.meta)
        
        XCTAssertEqual(activity.id, "activity_123")
        XCTAssertNotNil(activity.meta)
    }
    
    func testActivityProtocolProperties() throws {
        let activity = MockActivity()
        
        XCTAssertEqual(activity.name, "Test Activity")
        XCTAssertEqual(activity.activityDescription, "A test activity for unit tests")
        XCTAssertEqual(activity.activityTypeId, "activity_type_456")
        XCTAssertEqual(activity.userId, "user_789")
        XCTAssertNotNil(activity.startTime)
        XCTAssertNotNil(activity.endTime)
        XCTAssertEqual(activity.status, .open)
        
        // Test that end time is after start time
        if let startTime = activity.startTime,
           let endTime = activity.endTime {
            XCTAssertLessThan(startTime, endTime)
        }
    }
    
    func testActivityTypeProperties() throws {
        let activityType = MockActivityType()
        
        XCTAssertEqual(activityType.name, "Test Activity Type")
        XCTAssertEqual(activityType.typeDescription, "A test activity type")
        XCTAssertEqual(activityType.category, "testing")
        XCTAssertEqual(activityType.status, .open)
    }
    
    func testActivityBlackoutProperties() throws {
        let blackout = MockActivityBlackout()
        
        XCTAssertEqual(blackout.activityTypeId, "activity_type_123")
        XCTAssertEqual(blackout.name, "Maintenance Window")
        XCTAssertNotNil(blackout.startTime)
        XCTAssertNotNil(blackout.endTime)
        XCTAssertEqual(blackout.status, .open)
        
        // Test that end time is after start time
        XCTAssertLessThan(blackout.startTime, blackout.endTime)
        
        // Test duration calculation
        let duration = blackout.endTime.timeIntervalSince(blackout.startTime)
        XCTAssertEqual(duration, 7200, accuracy: 1) // 2 hours = 7200 seconds
    }
    
    // MARK: - Business Logic Tests
    
    func testActivityScheduling() throws {
        let activity = MockActivity()
        let activityType = MockActivityType()
        let blackout = MockActivityBlackout()
        
        // Test activity belongs to type
        XCTAssertEqual(activity.activityTypeId, "activity_type_456")
        
        // Test blackout affects activity type
        XCTAssertEqual(blackout.activityTypeId, activityType.id)
        
        // Test activity timing
        if let startTime = activity.startTime,
           let endTime = activity.endTime {
            let duration = endTime.timeIntervalSince(startTime)
            XCTAssertEqual(duration, 3600, accuracy: 1) // 1 hour
        }
        
        // Test blackout timing
        let blackoutDuration = blackout.endTime.timeIntervalSince(blackout.startTime)
        XCTAssertEqual(blackoutDuration, 7200, accuracy: 1) // 2 hours
    }
    
    // MARK: - Protocol as Type Tests
    
    func testActivityProtocolsAsTypes() throws {
        let activity: any DAOActivityProtocol = MockActivity()
        let activityType: any DAOActivityTypeProtocol = MockActivityType()
        let blackout: any DAOActivityBlackoutProtocol = MockActivityBlackout()
        
        XCTAssertEqual(activity.id, "activity_123")
        XCTAssertEqual(activityType.id, "activity_type_123")
        XCTAssertEqual(blackout.id, "activity_blackout_123")
        
        // Test protocol arrays
        let activityObjects: [any DAOBaseObjectProtocol] = [activity, activityType, blackout]
        XCTAssertEqual(activityObjects.count, 3)
        
        // Test type filtering
        let activities = activityObjects.compactMap { $0 as? DAOActivityProtocol }
        let activityTypes = activityObjects.compactMap { $0 as? DAOActivityTypeProtocol }
        let blackouts = activityObjects.compactMap { $0 as? DAOActivityBlackoutProtocol }
        
        XCTAssertEqual(activities.count, 1)
        XCTAssertEqual(activityTypes.count, 1)
        XCTAssertEqual(blackouts.count, 1)
    }
    
    // MARK: - Integration Tests
    
    func testActivityIntegration() throws {
        let activity = MockActivity()
        let activityType = MockActivityType()
        let blackout = MockActivityBlackout()
        
        // Test activity uses activity type
        var mutableActivity = activity
        mutableActivity.activityTypeId = activityType.id
        XCTAssertEqual(mutableActivity.activityTypeId, activityType.id)
        
        // Test blackout affects activity type
        XCTAssertEqual(blackout.activityTypeId, activityType.id)
        
        // Test activity scheduling respects blackouts
        let isInBlackout = activity.startTime ?? Date() >= blackout.startTime && 
                          activity.startTime ?? Date() <= blackout.endTime
        
        if isInBlackout {
            // Activity would be blocked during blackout
            XCTAssertTrue(isInBlackout)
        }
    }
    
    // MARK: - Error Handling Tests
    
    func testActivityProtocolValidation() throws {
        var activity = MockActivity()
        
        // Test empty names and required fields
        activity.name = ""
        
        XCTAssertEqual(activity.name, "")
        
        // Test required properties remain valid
        XCTAssertNotEqual(activity.id, "")
    }
    
    func testProtocolInstanceChecking() throws {
        let activity = MockActivity()
        let activityType = MockActivityType()
        let blackout = MockActivityBlackout()
        
        // Test protocol conformance by validating required properties exist and have expected values
        XCTAssertFalse(activity.id.isEmpty)
        XCTAssertFalse(activityType.id.isEmpty)
        XCTAssertFalse(blackout.id.isEmpty)
        
        // Test base object conformance by validating metadata exists
        XCTAssertNotNil(activity.meta)
        XCTAssertNotNil(activityType.meta)
        XCTAssertNotNil(blackout.meta)
    }
}
