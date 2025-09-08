//
//  DAOPricingSeasonProtocolTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts Tests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import XCTest
@testable import DNSDataContracts

final class DAOPricingSeasonProtocolTests: XCTestCase {
    
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
    
    struct MockPricingSeason: DAOPricingSeasonProtocol {
        var id: String = "pricing_season_123"
        var meta: any DAOMetadataProtocol = MockMetadata()
        var analyticsData: [any DAOAnalyticsDataProtocol] = []
        
        var pricingTierId: String = "pricing_tier_123"
        var name: String = "Summer Season"
        var startDate: Date? = Date()
        var endDate: Date? = Date().addingTimeInterval(7776000) // 90 days later
        var status: DNSStatus = .open
    }
    
    // MARK: - DAOPricingSeasonProtocol Tests
    
    func testPricingSeasonProtocolInheritance() throws {
        let pricingSeason = MockPricingSeason()
        
        XCTAssertTrue(pricingSeason is DAOBaseObjectProtocol)
        XCTAssertTrue(pricingSeason is DAOPricingSeasonProtocol)
        
        XCTAssertEqual(pricingSeason.id, "pricing_season_123")
        XCTAssertNotNil(pricingSeason.meta)
    }
    
    func testPricingSeasonProtocolProperties() throws {
        let pricingSeason = MockPricingSeason()
        
        XCTAssertEqual(pricingSeason.pricingTierId, "pricing_tier_123")
        XCTAssertEqual(pricingSeason.name, "Summer Season")
        XCTAssertNotNil(pricingSeason.startDate)
        XCTAssertNotNil(pricingSeason.endDate)
        XCTAssertEqual(pricingSeason.status, .open)
        
        // Test that end date is after start date
        if let startDate = pricingSeason.startDate,
           let endDate = pricingSeason.endDate {
            XCTAssertLessThan(startDate, endDate)
        }
    }
    
    func testPricingSeasonMutability() throws {
        var pricingSeason = MockPricingSeason()
        
        pricingSeason.pricingTierId = "pricing_tier_456"
        XCTAssertEqual(pricingSeason.pricingTierId, "pricing_tier_456")
        
        pricingSeason.name = "Winter Season"
        XCTAssertEqual(pricingSeason.name, "Winter Season")
        
        let newStartDate = Date().addingTimeInterval(86400) // tomorrow
        let newEndDate = newStartDate.addingTimeInterval(5184000) // 60 days later
        
        pricingSeason.startDate = newStartDate
        pricingSeason.endDate = newEndDate
        
        XCTAssertEqual(pricingSeason.startDate, newStartDate)
        XCTAssertEqual(pricingSeason.endDate, newEndDate)
        
        pricingSeason.status = .closed
        XCTAssertEqual(pricingSeason.status, .closed)
        
        pricingSeason.startDate = nil
        pricingSeason.endDate = nil
        
        XCTAssertNil(pricingSeason.startDate)
        XCTAssertNil(pricingSeason.endDate)
    }
    
    // MARK: - Protocol as Type Tests
    
    func testPricingSeasonProtocolAsType() throws {
        let pricingSeasons: [any DAOPricingSeasonProtocol] = [
            MockPricingSeason()
        ]
        
        XCTAssertEqual(pricingSeasons.count, 1)
        
        if let firstSeason = pricingSeasons.first {
            XCTAssertEqual(firstSeason.id, "pricing_season_123")
            XCTAssertEqual(firstSeason.pricingTierId, "pricing_tier_123")
            XCTAssertEqual(firstSeason.name, "Summer Season")
        } else {
            XCTFail("Should have first pricing season")
        }
    }
    
    // MARK: - Error Handling Tests
    
    func testPricingSeasonProtocolValidation() throws {
        var pricingSeason = MockPricingSeason()
        
        // Test empty names and IDs
        pricingSeason.name = ""
        pricingSeason.pricingTierId = ""
        
        XCTAssertEqual(pricingSeason.name, "")
        XCTAssertEqual(pricingSeason.pricingTierId, "")
        
        // Test required properties remain valid
        XCTAssertNotEqual(pricingSeason.id, "")
        XCTAssertNotNil(pricingSeason.status)
    }
    
    func testProtocolInstanceChecking() throws {
        let pricingSeason = MockPricingSeason()
        
        // Test protocol conformance
        XCTAssertTrue(pricingSeason is DAOPricingSeasonProtocol)
        
        // Test base object conformance
        XCTAssertTrue(pricingSeason is DAOBaseObjectProtocol)
        
        // Test type checking with casting
        XCTAssertNotNil(pricingSeason as? DAOPricingSeasonProtocol)
        XCTAssertNotNil(pricingSeason as? DAOBaseObjectProtocol)
    }
}
