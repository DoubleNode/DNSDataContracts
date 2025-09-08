//
//  DAOPlaceStatusProtocolTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts Tests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import XCTest
@testable import DNSDataContracts

final class DAOPlaceStatusProtocolTests: XCTestCase {
    
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
    
    struct MockPlaceStatus: DAOPlaceStatusProtocol {
        var id: String = "place_status_123"
        var meta: any DAOMetadataProtocol = MockMetadata()
        var analyticsData: [any DAOAnalyticsDataProtocol] = []
        
        var placeId: String = "place_123"
        var status: DNSStatus = .open
        var effectiveDate: Date? = Date()
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
    
    // MARK: - Business Logic Tests
    
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
    
    // MARK: - Protocol as Type Tests
    
    func testPlaceStatusProtocolAsType() throws {
        let placeStatuses: [any DAOPlaceStatusProtocol] = [
            MockPlaceStatus()
        ]
        
        XCTAssertEqual(placeStatuses.count, 1)
        
        if let firstStatus = placeStatuses.first {
            XCTAssertEqual(firstStatus.id, "place_status_123")
            XCTAssertEqual(firstStatus.placeId, "place_123")
            XCTAssertEqual(firstStatus.status, .open)
        } else {
            XCTFail("Should have first place status")
        }
    }
    
    // MARK: - Error Handling Tests
    
    func testPlaceStatusProtocolValidation() throws {
        var placeStatus = MockPlaceStatus()
        
        // Test empty place ID
        placeStatus.placeId = ""
        XCTAssertEqual(placeStatus.placeId, "")
        
        // Test required properties remain valid
        XCTAssertNotEqual(placeStatus.id, "")
        XCTAssertNotNil(placeStatus.status)
    }
    
    func testProtocolInstanceChecking() throws {
        let placeStatus = MockPlaceStatus()
        
        // Test protocol conformance
        XCTAssertTrue(placeStatus is DAOPlaceStatusProtocol)
        
        // Test base object conformance
        XCTAssertTrue(placeStatus is DAOBaseObjectProtocol)
        
        // Test type checking with casting
        XCTAssertNotNil(placeStatus as? DAOPlaceStatusProtocol)
        XCTAssertNotNil(placeStatus as? DAOBaseObjectProtocol)
    }
}
