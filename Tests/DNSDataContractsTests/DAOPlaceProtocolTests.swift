//
//  DAOPlaceProtocolTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts Tests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
@testable import DNSDataContracts

final class DAOPlaceProtocolTests: XCTestCase {
    
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
    
    struct MockPlace: DAOPlaceProtocol {
        var id: String = "place_123"
        var meta: any DAOMetadataProtocol = MockMetadata()
        var analyticsData: [any DAOAnalyticsDataProtocol] = []
        
        var name: String = "Test Location"
        var placeDescription: String? = "A test location for unit tests"
        var address: String? = "123 Test St, Test City, TS 12345"
        var latitude: Double? = 37.7749
        var longitude: Double? = -122.4194
        var status: DNSStatus = .open
        var visibility: DNSVisibility = .everyone
    }
    
    struct MockPlaceStatus: DAOPlaceStatusProtocol {
        var id: String = "place_status_123"
        var meta: any DAOMetadataProtocol = MockMetadata()
        var analyticsData: [any DAOAnalyticsDataProtocol] = []
        
        var placeId: String = "place_123"
        var status: DNSStatus = .open
        var effectiveDate: Date? = Date()
    }
    
    struct MockPlaceHours: DAOPlaceHoursProtocol {
        var id: String = "place_hours_123"
        var meta: any DAOMetadataProtocol = MockMetadata()
        var analyticsData: [any DAOAnalyticsDataProtocol] = []
        
        var placeId: String = "place_123"
        var hours: [DNSDailyHours] = [DNSDailyHours()]
        var dayOfWeek: DNSDayOfWeekFlags = DNSDayOfWeekFlags(sunday: false, monday: true, tuesday: true, wednesday: true, thursday: true, friday: true, saturday: false)
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
    
    struct MockPlaceHoliday: DAOPlaceHolidayProtocol {
        var id: String = "place_holiday_123"
        var meta: any DAOMetadataProtocol = MockMetadata()
        var analyticsData: [any DAOAnalyticsDataProtocol] = []
        
        var placeId: String = "place_123"
        var name: String = "New Year's Day"
        var date: Date = Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 1))!
    }
    
    // MARK: - DAOPlaceProtocol Tests
    
    func testDAOPlaceProtocolInheritance() throws {
        let place = MockPlace()
        
        // Test that DAOPlaceProtocol inherits from DAOBaseObjectProtocol
        XCTAssertTrue(place is DAOBaseObjectProtocol)
        XCTAssertTrue(place is DAOPlaceProtocol)
        
        // Test base object properties
        XCTAssertEqual(place.id, "place_123")
        XCTAssertNotNil(place.meta)
        XCTAssertTrue(place.analyticsData.isEmpty)
    }
    
    func testPlaceProtocolProperties() throws {
        let place = MockPlace()
        
        // Test place-specific properties
        XCTAssertEqual(place.name, "Test Location")
        XCTAssertEqual(place.placeDescription, "A test location for unit tests")
        XCTAssertEqual(place.address, "123 Test St, Test City, TS 12345")
        XCTAssertEqual(place.latitude ?? 0.0, 37.7749, accuracy: 0.0001)
        XCTAssertEqual(place.longitude ?? 0.0, -122.4194, accuracy: 0.0001)
        XCTAssertEqual(place.status, .open)
        XCTAssertEqual(place.visibility, .everyone)
    }
    
    func testPlaceProtocolMutability() throws {
        var place = MockPlace()
        
        // Test property mutability
        place.name = "Updated Location"
        XCTAssertEqual(place.name, "Updated Location")
        
        place.placeDescription = "Updated description"
        XCTAssertEqual(place.placeDescription, "Updated description")
        
        place.address = "456 New St, New City, NS 67890"
        XCTAssertEqual(place.address, "456 New St, New City, NS 67890")
        
        place.latitude = 40.7128
        XCTAssertEqual(place.latitude ?? 0.0, 40.7128, accuracy: 0.0001)
        
        place.longitude = -74.0060
        XCTAssertEqual(place.longitude ?? 0.0, -74.0060, accuracy: 0.0001)
        
        place.status = .closed
        XCTAssertEqual(place.status, .closed)
        
        place.visibility = .staffOnly
        XCTAssertEqual(place.visibility, .staffOnly)
    }
    
    func testPlaceOptionalProperties() throws {
        var place = MockPlace()
        
        // Test setting optional properties to nil
        place.placeDescription = nil
        place.address = nil
        place.latitude = nil
        place.longitude = nil
        
        XCTAssertNil(place.placeDescription)
        XCTAssertNil(place.address)
        XCTAssertNil(place.latitude)
        XCTAssertNil(place.longitude)
        
        // Required properties should still have values
        XCTAssertFalse(place.name.isEmpty)
        XCTAssertNotNil(place.status)
        XCTAssertNotNil(place.visibility)
    }
    
    // MARK: - DAOPlaceStatusProtocol Tests
    
    func testPlaceStatusProtocolInheritance() throws {
        let placeStatus = MockPlaceStatus()
        
        XCTAssertTrue(placeStatus is DAOBaseObjectProtocol)
        XCTAssertTrue(placeStatus is DAOPlaceStatusProtocol)
        
        XCTAssertEqual(placeStatus.id, "place_status_123")
        XCTAssertNotNil(placeStatus.meta)
    }
    
    func testPlaceStatusProperties() throws {
        let placeStatus = MockPlaceStatus()
        
        XCTAssertEqual(placeStatus.placeId, "place_123")
        XCTAssertEqual(placeStatus.status, .open)
        XCTAssertNotNil(placeStatus.effectiveDate)
    }
    
    func testPlaceStatusMutability() throws {
        var placeStatus = MockPlaceStatus()
        
        placeStatus.placeId = "place_456"
        XCTAssertEqual(placeStatus.placeId, "place_456")
        
        placeStatus.status = .closed
        XCTAssertEqual(placeStatus.status, .closed)
        
        let futureDate = Date().addingTimeInterval(86400) // tomorrow
        placeStatus.effectiveDate = futureDate
        XCTAssertEqual(placeStatus.effectiveDate, futureDate)
        
        placeStatus.effectiveDate = nil
        XCTAssertNil(placeStatus.effectiveDate)
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
    
    // MARK: - DAOPlaceHolidayProtocol Tests
    
    func testPlaceHolidayProtocolInheritance() throws {
        let placeHoliday = MockPlaceHoliday()
        
        XCTAssertTrue(placeHoliday is DAOBaseObjectProtocol)
        XCTAssertTrue(placeHoliday is DAOPlaceHolidayProtocol)
        
        XCTAssertEqual(placeHoliday.id, "place_holiday_123")
        XCTAssertNotNil(placeHoliday.meta)
    }
    
    func testPlaceHolidayProperties() throws {
        let placeHoliday = MockPlaceHoliday()
        
        XCTAssertEqual(placeHoliday.placeId, "place_123")
        XCTAssertEqual(placeHoliday.name, "New Year's Day")
        
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: placeHoliday.date)
        XCTAssertEqual(dateComponents.year, 2025)
        XCTAssertEqual(dateComponents.month, 1)
        XCTAssertEqual(dateComponents.day, 1)
    }
    
    func testPlaceHolidayMutability() throws {
        var placeHoliday = MockPlaceHoliday()
        
        placeHoliday.placeId = "place_555"
        XCTAssertEqual(placeHoliday.placeId, "place_555")
        
        placeHoliday.name = "Independence Day"
        XCTAssertEqual(placeHoliday.name, "Independence Day")
        
        let july4th = Calendar.current.date(from: DateComponents(year: 2025, month: 7, day: 4))!
        placeHoliday.date = july4th
        
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: placeHoliday.date)
        XCTAssertEqual(dateComponents.month, 7)
        XCTAssertEqual(dateComponents.day, 4)
    }
    
    // MARK: - Business Logic Tests
    
    func testPlaceCoordinateValidation() throws {
        var place = MockPlace()
        
        // Test valid coordinates
        place.latitude = 37.7749  // San Francisco
        place.longitude = -122.4194
        XCTAssertEqual(place.latitude ?? 0.0, 37.7749, accuracy: 0.0001)
        XCTAssertEqual(place.longitude ?? 0.0, -122.4194, accuracy: 0.0001)
        
        // Test boundary coordinates
        place.latitude = 90.0  // North Pole
        place.longitude = 180.0  // Date Line
        XCTAssertEqual(place.latitude, 90.0)
        XCTAssertEqual(place.longitude, 180.0)
        
        place.latitude = -90.0  // South Pole  
        place.longitude = -180.0  // Date Line
        XCTAssertEqual(place.latitude, -90.0)
        XCTAssertEqual(place.longitude, -180.0)
    }
    
    func testPlaceStatusEffectiveDate() throws {
        var placeStatus = MockPlaceStatus()
        
        // Test current effective date
        let now = Date()
        placeStatus.effectiveDate = now
        placeStatus.status = .open
        
        if let effectiveDate = placeStatus.effectiveDate {
            XCTAssertLessThanOrEqual(effectiveDate.timeIntervalSinceNow, 1.0) // within 1 second
        } else {
            XCTFail("Effective date should not be nil")
        }
        
        // Test future effective date
        let futureDate = now.addingTimeInterval(86400) // tomorrow
        placeStatus.effectiveDate = futureDate
        placeStatus.status = .comingSoon
        
        XCTAssertEqual(placeStatus.status, .comingSoon)
        XCTAssertGreaterThan(placeStatus.effectiveDate!, now)
    }
    
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
    
    func testPlaceProtocolAsType() throws {
        let places: [any DAOPlaceProtocol] = [
            MockPlace()
        ]
        
        XCTAssertEqual(places.count, 1)
        
        if let firstPlace = places.first {
            XCTAssertEqual(firstPlace.id, "place_123")
            XCTAssertEqual(firstPlace.name, "Test Location")
            XCTAssertEqual(firstPlace.status, .open)
        } else {
            XCTFail("Should have first place")
        }
    }
    
    func testMixedPlaceProtocolArray() throws {
        let place = MockPlace()
        let placeStatus = MockPlaceStatus()
        let placeHours = MockPlaceHours()
        let placeEvent = MockPlaceEvent()
        let placeHoliday = MockPlaceHoliday()
        
        // Test array of base objects containing different place-related protocols
        let baseObjects: [any DAOBaseObjectProtocol] = [
            place, placeStatus, placeHours, placeEvent, placeHoliday
        ]
        
        XCTAssertEqual(baseObjects.count, 5)
        
        // Test filtering by protocol type
        let placeObjects = baseObjects.compactMap { $0 as? DAOPlaceProtocol }
        XCTAssertEqual(placeObjects.count, 1)
        
        let statusObjects = baseObjects.compactMap { $0 as? DAOPlaceStatusProtocol }
        XCTAssertEqual(statusObjects.count, 1)
        
        let hoursObjects = baseObjects.compactMap { $0 as? DAOPlaceHoursProtocol }
        XCTAssertEqual(hoursObjects.count, 1)
        
        let eventObjects = baseObjects.compactMap { $0 as? DAOPlaceEventProtocol }
        XCTAssertEqual(eventObjects.count, 1)
        
        let holidayObjects = baseObjects.compactMap { $0 as? DAOPlaceHolidayProtocol }
        XCTAssertEqual(holidayObjects.count, 1)
    }
    
    // MARK: - Integration Tests
    
    func testPlaceWithRelatedObjects() throws {
        let place = MockPlace()
        let placeStatus = MockPlaceStatus()
        let placeHours = MockPlaceHours()
        
        // Test relationships through IDs
        XCTAssertEqual(placeStatus.placeId, place.id)
        XCTAssertEqual(placeHours.placeId, place.id)
        
        // Test filtering related objects by place ID
        let relatedObjects: [any DAOBaseObjectProtocol] = [placeStatus, placeHours]
        
        if let placeStatusObj = relatedObjects.first(where: { $0 is DAOPlaceStatusProtocol }) as? DAOPlaceStatusProtocol {
            XCTAssertEqual(placeStatusObj.placeId, place.id)
        } else {
            XCTFail("Should find place status object")
        }
        
        if let placeHoursObj = relatedObjects.first(where: { $0 is DAOPlaceHoursProtocol }) as? DAOPlaceHoursProtocol {
            XCTAssertEqual(placeHoursObj.placeId, place.id)
        } else {
            XCTFail("Should find place hours object")
        }
    }
    
    // MARK: - Error Handling Tests
    
    func testPlaceProtocolValidation() throws {
        var place = MockPlace()
        
        // Test empty name handling
        place.name = ""
        XCTAssertEqual(place.name, "")
        
        // Test coordinate edge cases
        place.latitude = 91.0  // Invalid latitude
        XCTAssertEqual(place.latitude, 91.0) // Protocol doesn't enforce validation
        
        place.longitude = 181.0  // Invalid longitude
        XCTAssertEqual(place.longitude, 181.0) // Protocol doesn't enforce validation
        
        // Test required properties remain valid
        XCTAssertNotEqual(place.id, "")
        XCTAssertNotNil(place.status)
        XCTAssertNotNil(place.visibility)
    }
    
    func testProtocolInstanceChecking() throws {
        let place = MockPlace()
        let placeStatus = MockPlaceStatus()
        let placeHours = MockPlaceHours()
        let placeEvent = MockPlaceEvent()
        let placeHoliday = MockPlaceHoliday()
        
        // Test protocol conformance
        XCTAssertTrue(place is DAOPlaceProtocol)
        XCTAssertTrue(placeStatus is DAOPlaceStatusProtocol)
        XCTAssertTrue(placeHours is DAOPlaceHoursProtocol)
        XCTAssertTrue(placeEvent is DAOPlaceEventProtocol)
        XCTAssertTrue(placeHoliday is DAOPlaceHolidayProtocol)
        
        // Test base object conformance
        XCTAssertTrue(place is DAOBaseObjectProtocol)
        XCTAssertTrue(placeStatus is DAOBaseObjectProtocol)
        XCTAssertTrue(placeHours is DAOBaseObjectProtocol)
        XCTAssertTrue(placeEvent is DAOBaseObjectProtocol)
        XCTAssertTrue(placeHoliday is DAOBaseObjectProtocol)
        
        // Test type checking with casting
        XCTAssertNotNil(place as? DAOPlaceProtocol)
        XCTAssertNotNil(placeStatus as? DAOPlaceStatusProtocol)
        XCTAssertNotNil(placeHours as? DAOPlaceHoursProtocol)
        XCTAssertNotNil(placeEvent as? DAOPlaceEventProtocol)
        XCTAssertNotNil(placeHoliday as? DAOPlaceHolidayProtocol)
    }
}