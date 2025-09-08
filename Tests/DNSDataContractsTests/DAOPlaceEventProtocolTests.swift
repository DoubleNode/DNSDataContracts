//
//  DAOPlaceEventProtocolTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts Tests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import XCTest
@testable import DNSDataContracts

final class DAOPlaceEventProtocolTests: XCTestCase {
    
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
    
    struct MockPlaceEvent: DAOPlaceEventProtocol {
        var id: String = "place_event_123"
        var meta: any DAOMetadataProtocol = MockMetadata()
        var analyticsData: [any DAOAnalyticsDataProtocol] = []
        
        var placeId: String = "place_123"
        var eventId: String = "event_456"
        var startTime: Date? = Date()
        var endTime: Date? = Date().addingTimeInterval(3600)
    }
    
    // MARK: - DAOPlaceEventProtocol Tests
    
    func testPlaceEventProtocolInheritance() throws {
        let placeEvent = MockPlaceEvent()
        
        XCTAssertTrue(placeEvent is DAOBaseObjectProtocol)
        XCTAssertTrue(placeEvent is DAOPlaceEventProtocol)
        
        XCTAssertEqual(placeEvent.id, "place_event_123")
        XCTAssertNotNil(placeEvent.meta)
    }
    
    func testPlaceEventProperties() throws {
        let placeEvent = MockPlaceEvent()
        
        XCTAssertEqual(placeEvent.placeId, "place_123")
        XCTAssertEqual(placeEvent.eventId, "event_456")
        XCTAssertNotNil(placeEvent.startTime)
        XCTAssertNotNil(placeEvent.endTime)
        
        // Test that end time is after start time
        if let startTime = placeEvent.startTime,
           let endTime = placeEvent.endTime {
            XCTAssertLessThan(startTime, endTime)
        }
    }
    
    func testPlaceEventMutability() throws {
        var placeEvent = MockPlaceEvent()
        
        placeEvent.placeId = "place_999"
        XCTAssertEqual(placeEvent.placeId, "place_999")
        
        placeEvent.eventId = "event_888"
        XCTAssertEqual(placeEvent.eventId, "event_888")
        
        let newStartTime = Date().addingTimeInterval(3600)
        let newEndTime = newStartTime.addingTimeInterval(7200)
        
        placeEvent.startTime = newStartTime
        placeEvent.endTime = newEndTime
        
        XCTAssertEqual(placeEvent.startTime, newStartTime)
        XCTAssertEqual(placeEvent.endTime, newEndTime)
        
        placeEvent.startTime = nil
        placeEvent.endTime = nil
        
        XCTAssertNil(placeEvent.startTime)
        XCTAssertNil(placeEvent.endTime)
    }
    
    // MARK: - Protocol as Type Tests
    
    func testPlaceEventProtocolAsType() throws {
        let placeEvents: [any DAOPlaceEventProtocol] = [
            MockPlaceEvent()
        ]
        
        XCTAssertEqual(placeEvents.count, 1)
        
        if let firstEvent = placeEvents.first {
            XCTAssertEqual(firstEvent.id, "place_event_123")
            XCTAssertEqual(firstEvent.placeId, "place_123")
            XCTAssertEqual(firstEvent.eventId, "event_456")
        } else {
            XCTFail("Should have first place event")
        }
    }
    
    // MARK: - Error Handling Tests
    
    func testPlaceEventProtocolValidation() throws {
        var placeEvent = MockPlaceEvent()
        
        // Test empty IDs
        placeEvent.placeId = ""
        placeEvent.eventId = ""
        
        XCTAssertEqual(placeEvent.placeId, "")
        XCTAssertEqual(placeEvent.eventId, "")
        
        // Test required properties remain valid
        XCTAssertNotEqual(placeEvent.id, "")
    }
    
    func testProtocolInstanceChecking() throws {
        let placeEvent = MockPlaceEvent()
        
        // Test protocol conformance
        XCTAssertTrue(placeEvent is DAOPlaceEventProtocol)
        
        // Test base object conformance
        XCTAssertTrue(placeEvent is DAOBaseObjectProtocol)
        
        // Test type checking with casting
        XCTAssertNotNil(placeEvent as? DAOPlaceEventProtocol)
        XCTAssertNotNil(placeEvent as? DAOBaseObjectProtocol)
    }
}
