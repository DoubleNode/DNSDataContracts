//
//  DAOPlaceHolidayProtocolTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts Tests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import XCTest
@testable import DNSDataContracts

final class DAOPlaceHolidayProtocolTests: XCTestCase {
    
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
    
    struct MockPlaceHoliday: DAOPlaceHolidayProtocol {
        var id: String = "place_holiday_123"
        var meta: any DAOMetadataProtocol = MockMetadata()
        var analyticsData: [any DAOAnalyticsDataProtocol] = []
        
        var placeId: String = "place_123"
        var name: String = "New Year's Day"
        var date: Date = Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 1))!
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
    
    // MARK: - Protocol as Type Tests
    
    func testPlaceHolidayProtocolAsType() throws {
        let placeHolidays: [any DAOPlaceHolidayProtocol] = [
            MockPlaceHoliday()
        ]
        
        XCTAssertEqual(placeHolidays.count, 1)
        
        if let firstHoliday = placeHolidays.first {
            XCTAssertEqual(firstHoliday.id, "place_holiday_123")
            XCTAssertEqual(firstHoliday.placeId, "place_123")
            XCTAssertEqual(firstHoliday.name, "New Year's Day")
        } else {
            XCTFail("Should have first place holiday")
        }
    }
    
    // MARK: - Error Handling Tests
    
    func testPlaceHolidayProtocolValidation() throws {
        var placeHoliday = MockPlaceHoliday()
        
        // Test empty name and place ID
        placeHoliday.name = ""
        placeHoliday.placeId = ""
        
        XCTAssertEqual(placeHoliday.name, "")
        XCTAssertEqual(placeHoliday.placeId, "")
        
        // Test required properties remain valid
        XCTAssertNotEqual(placeHoliday.id, "")
        XCTAssertNotNil(placeHoliday.date)
    }
    
    func testProtocolInstanceChecking() throws {
        let placeHoliday = MockPlaceHoliday()
        
        // Test protocol conformance
        XCTAssertTrue(placeHoliday is DAOPlaceHolidayProtocol)
        
        // Test base object conformance
        XCTAssertTrue(placeHoliday is DAOBaseObjectProtocol)
        
        // Test type checking with casting
        XCTAssertNotNil(placeHoliday as? DAOPlaceHolidayProtocol)
        XCTAssertNotNil(placeHoliday as? DAOBaseObjectProtocol)
    }
}
