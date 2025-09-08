//
//  DAOEventProtocolTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts Tests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import XCTest
@testable import DNSDataContracts

final class DAOEventProtocolTests: XCTestCase {
    
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
    
    struct MockEvent: DAOEventProtocol {
        var id: String = "event_123"
        var meta: any DAOMetadataProtocol = MockMetadata()
        var analyticsData: [any DAOAnalyticsDataProtocol] = []
        
        var name: String = "Test Event"
        var eventDescription: String? = "A test event for unit tests"
        var startTime: Date? = Date()
        var endTime: Date? = Date().addingTimeInterval(3600) // 1 hour later
        var placeId: String? = "place_456"
        var status: DNSStatus = .open
        var visibility: DNSVisibility = .everyone
    }
    
    struct MockEventDayItem: DAOEventDayItemProtocol {
        var id: String = "event_day_item_123"
        var meta: any DAOMetadataProtocol = MockMetadata()
        var analyticsData: [any DAOAnalyticsDataProtocol] = []
        
        var eventDayId: String = "event_day_123"
        var name: String = "Morning Session"
        var itemDescription: String? = "Morning session description"
        var startTime: Date? = Date()
        var endTime: Date? = Date().addingTimeInterval(1800) // 30 minutes
        var status: DNSStatus = .open
    }
    
    struct MockEventDay: DAOEventDayProtocol {
        var id: String = "event_day_123"
        var meta: any DAOMetadataProtocol = MockMetadata()
        var analyticsData: [any DAOAnalyticsDataProtocol] = []
        
        var eventId: String = "event_123"
        var date: Date = Calendar.current.startOfDay(for: Date())
        var startTime: Date? = Date()
        var endTime: Date? = Date().addingTimeInterval(28800) // 8 hours
        var items: [any DAOEventDayItemProtocol] = [MockEventDayItem()]
        var status: DNSStatus = .open
    }
    
    // MARK: - Event Protocol Tests
    
    func testDAOEventProtocolInheritance() throws {
        let event = MockEvent()
        
        XCTAssertTrue(event is DAOBaseObjectProtocol)
        XCTAssertTrue(event is DAOEventProtocol)
        
        XCTAssertEqual(event.id, "event_123")
        XCTAssertNotNil(event.meta)
    }
    
    func testEventProtocolProperties() throws {
        let event = MockEvent()
        
        XCTAssertEqual(event.name, "Test Event")
        XCTAssertEqual(event.eventDescription, "A test event for unit tests")
        XCTAssertNotNil(event.startTime)
        XCTAssertNotNil(event.endTime)
        XCTAssertEqual(event.placeId, "place_456")
        XCTAssertEqual(event.status, .open)
        XCTAssertEqual(event.visibility, .everyone)
        
        // Test that end time is after start time
        if let startTime = event.startTime,
           let endTime = event.endTime {
            XCTAssertLessThan(startTime, endTime)
        }
    }
    
    func testEventDayProtocolProperties() throws {
        let eventDay = MockEventDay()
        
        XCTAssertEqual(eventDay.eventId, "event_123")
        XCTAssertNotNil(eventDay.date)
        XCTAssertNotNil(eventDay.startTime)
        XCTAssertNotNil(eventDay.endTime)
        XCTAssertEqual(eventDay.items.count, 1)
        XCTAssertEqual(eventDay.status, .open)
        
        // Test that the date is start of day
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.hour, .minute, .second], from: eventDay.date)
        XCTAssertEqual(dateComponents.hour, 0)
        XCTAssertEqual(dateComponents.minute, 0)
        XCTAssertEqual(dateComponents.second, 0)
    }
    
    func testEventDayItemProtocolProperties() throws {
        let eventDayItem = MockEventDayItem()
        
        XCTAssertEqual(eventDayItem.eventDayId, "event_day_123")
        XCTAssertEqual(eventDayItem.name, "Morning Session")
        XCTAssertEqual(eventDayItem.itemDescription, "Morning session description")
        XCTAssertNotNil(eventDayItem.startTime)
        XCTAssertNotNil(eventDayItem.endTime)
        XCTAssertEqual(eventDayItem.status, .open)
        
        // Test that end time is after start time
        if let startTime = eventDayItem.startTime,
           let endTime = eventDayItem.endTime {
            XCTAssertLessThan(startTime, endTime)
        }
    }
    
    // MARK: - Business Logic Tests
    
    func testEventScheduling() throws {
        var event = MockEvent()
        let eventDay = MockEventDay()
        let eventDayItem = MockEventDayItem()
        
        // Test event day belongs to event
        XCTAssertEqual(eventDay.eventId, event.id)
        
        // Test event day item belongs to event day
        XCTAssertEqual(eventDayItem.eventDayId, eventDay.id)
        
        // Test scheduling logic
        let startDate = Calendar.current.startOfDay(for: Date())
        event.startTime = startDate
        event.endTime = startDate.addingTimeInterval(86400) // 1 day later
        
        if let startTime = event.startTime,
           let endTime = event.endTime {
            let duration = endTime.timeIntervalSince(startTime)
            XCTAssertEqual(duration, 86400, accuracy: 1) // 1 day = 86400 seconds
        }
    }
    
    // MARK: - Protocol as Type Tests
    
    func testEventProtocolsAsTypes() throws {
        let event: any DAOEventProtocol = MockEvent()
        let eventDay: any DAOEventDayProtocol = MockEventDay()
        let eventDayItem: any DAOEventDayItemProtocol = MockEventDayItem()
        
        XCTAssertEqual(event.id, "event_123")
        XCTAssertEqual(eventDay.id, "event_day_123")
        XCTAssertEqual(eventDayItem.id, "event_day_item_123")
        
        // Test protocol arrays
        let eventObjects: [any DAOBaseObjectProtocol] = [event, eventDay, eventDayItem]
        XCTAssertEqual(eventObjects.count, 3)
    }
    
    // MARK: - Integration Tests
    
    func testEventIntegration() throws {
        let event = MockEvent()
        let eventDay = MockEventDay()
        
        // Test event with place relationship
        XCTAssertEqual(event.placeId, "place_456")
        XCTAssertEqual(eventDay.eventId, event.id)
    }
    
    // MARK: - Error Handling Tests
    
    func testEventProtocolValidation() throws {
        var event = MockEvent()
        
        // Test empty names and required fields
        event.name = ""
        
        XCTAssertEqual(event.name, "")
        
        // Test required properties remain valid
        XCTAssertNotEqual(event.id, "")
    }
    
    func testProtocolInstanceChecking() throws {
        let event = MockEvent()
        let eventDay = MockEventDay()
        let eventDayItem = MockEventDayItem()
        
        // Test protocol conformance
        XCTAssertTrue(event is DAOEventProtocol)
        XCTAssertTrue(eventDay is DAOEventDayProtocol)
        XCTAssertTrue(eventDayItem is DAOEventDayItemProtocol)
        
        // Test base object conformance
        XCTAssertTrue(event is DAOBaseObjectProtocol)
        XCTAssertTrue(eventDay is DAOBaseObjectProtocol)
        XCTAssertTrue(eventDayItem is DAOBaseObjectProtocol)
    }
}
