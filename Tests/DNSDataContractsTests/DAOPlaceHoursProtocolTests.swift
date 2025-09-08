//
//  DAOPlaceHoursProtocolTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts Tests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import XCTest
@testable import DNSDataContracts

final class DAOPlaceHoursProtocolTests: XCTestCase {
    
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
    
    struct MockPlaceHours: DAOPlaceHoursProtocol {
        var id: String = "place_hours_123"
        var meta: any DAOMetadataProtocol = MockMetadata()
        var analyticsData: [any DAOAnalyticsDataProtocol] = []
        
        var placeId: String = "place_123"
        var hours: [DNSDailyHours] = [DNSDailyHours()]
        var dayOfWeek: DNSDayOfWeekFlags = DNSDayOfWeekFlags(sunday: false, monday: true, tuesday: true, wednesday: true, thursday: true, friday: true, saturday: false)
    }
    
    // MARK: - DAOPlaceHoursProtocol Tests
    
    func testPlaceHoursProtocolInheritance() throws {
        let placeHours = MockPlaceHours()
        
        XCTAssertTrue(placeHours is DAOBaseObjectProtocol)
        XCTAssertTrue(placeHours is DAOPlaceHoursProtocol)
        
        XCTAssertEqual(placeHours.id, "place_hours_123")
        XCTAssertNotNil(placeHours.meta)
    }
    
    func testPlaceHoursProperties() throws {
        let placeHours = MockPlaceHours()
        
        XCTAssertEqual(placeHours.placeId, "place_123")
        XCTAssertEqual(placeHours.hours.count, 1)
        XCTAssertTrue(placeHours.dayOfWeek.isWeekdays)
    }
    
    func testPlaceHoursMutability() throws {
        var placeHours = MockPlaceHours()
        
        placeHours.placeId = "place_789"
        XCTAssertEqual(placeHours.placeId, "place_789")
        
        let newHours = [DNSDailyHours(), DNSDailyHours()]
        placeHours.hours = newHours
        XCTAssertEqual(placeHours.hours.count, 2)
        
        placeHours.dayOfWeek = DNSDayOfWeekFlags(sunday: true, monday: false, tuesday: false, wednesday: false, thursday: false, friday: false, saturday: true)
        XCTAssertTrue(placeHours.dayOfWeek.isWeekend)
    }
    
    // MARK: - Business Logic Tests
    
    func testPlaceHoursBusinessLogic() throws {
        var placeHours = MockPlaceHours()
        
        // Test weekdays hours
        placeHours.dayOfWeek = DNSDayOfWeekFlags(sunday: false, monday: true, tuesday: true, wednesday: true, thursday: true, friday: true, saturday: false)
        XCTAssertTrue(placeHours.dayOfWeek.monday)
        XCTAssertTrue(placeHours.dayOfWeek.friday)
        XCTAssertFalse(placeHours.dayOfWeek.saturday)
        XCTAssertFalse(placeHours.dayOfWeek.sunday)
        
        // Test weekend hours
        placeHours.dayOfWeek = DNSDayOfWeekFlags(sunday: true, monday: false, tuesday: false, wednesday: false, thursday: false, friday: false, saturday: true)
        XCTAssertTrue(placeHours.dayOfWeek.saturday)
        XCTAssertTrue(placeHours.dayOfWeek.sunday)
        XCTAssertFalse(placeHours.dayOfWeek.monday)
        
        // Test all days
        placeHours.dayOfWeek = DNSDayOfWeekFlags() // Default is all days true
        XCTAssertTrue(placeHours.dayOfWeek.monday)
        XCTAssertTrue(placeHours.dayOfWeek.saturday)
        XCTAssertTrue(placeHours.dayOfWeek.sunday)
    }
    
    // MARK: - Protocol as Type Tests
    
    func testPlaceHoursProtocolAsType() throws {
        let placeHours: [any DAOPlaceHoursProtocol] = [
            MockPlaceHours()
        ]
        
        XCTAssertEqual(placeHours.count, 1)
        
        if let firstHours = placeHours.first {
            XCTAssertEqual(firstHours.id, "place_hours_123")
            XCTAssertEqual(firstHours.placeId, "place_123")
            XCTAssertEqual(firstHours.hours.count, 1)
        } else {
            XCTFail("Should have first place hours")
        }
    }
    
    // MARK: - Error Handling Tests
    
    func testPlaceHoursProtocolValidation() throws {
        var placeHours = MockPlaceHours()
        
        // Test empty place ID
        placeHours.placeId = ""
        XCTAssertEqual(placeHours.placeId, "")
        
        // Test empty hours array
        placeHours.hours = []
        XCTAssertEqual(placeHours.hours.count, 0)
        
        // Test required properties remain valid
        XCTAssertNotEqual(placeHours.id, "")
        XCTAssertNotNil(placeHours.dayOfWeek)
    }
    
    func testProtocolInstanceChecking() throws {
        let placeHours = MockPlaceHours()
        
        // Test protocol conformance
        XCTAssertTrue(placeHours is DAOPlaceHoursProtocol)
        
        // Test base object conformance
        XCTAssertTrue(placeHours is DAOBaseObjectProtocol)
        
        // Test type checking with casting
        XCTAssertNotNil(placeHours as? DAOPlaceHoursProtocol)
        XCTAssertNotNil(placeHours as? DAOBaseObjectProtocol)
    }
}
