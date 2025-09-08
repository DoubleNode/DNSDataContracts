//
//  DAOPlaceProtocolTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts Tests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
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
        
        // Test protocol conformance
        XCTAssertTrue(place is DAOPlaceProtocol)
        
        // Test base object conformance
        XCTAssertTrue(place is DAOBaseObjectProtocol)
        
        // Test type checking with casting
        XCTAssertNotNil(place as? DAOPlaceProtocol)
        XCTAssertNotNil(place as? DAOBaseObjectProtocol)
    }
}
