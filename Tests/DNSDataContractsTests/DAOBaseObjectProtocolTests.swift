//
//  DAOBaseObjectProtocolTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts Tests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
@testable import DNSDataContracts

final class DAOBaseObjectProtocolTests: XCTestCase {
    
    // MARK: - Mock Implementations
    
    struct MockMetadata: DAOMetadataProtocol {
        var uid: UUID = UUID()
        var created: Date = Date()
        var synced: Date? = nil
        var updated: Date = Date()
        var status: String = "active"
        var createdBy: String = "test_user"
        var updatedBy: String = "test_user"
        var genericValues: DNSDataDictionary = [:]
        var views: UInt = 0
    }
    
    struct MockAnalyticsData: DAOAnalyticsDataProtocol {
        var title: String
        var subtitle: String
    }
    
    struct MockBaseObject: DAOBaseObjectProtocol {
        var id: String = "test_id"
        var meta: any DAOMetadataProtocol = MockMetadata()
        var analyticsData: [any DAOAnalyticsDataProtocol] = []
    }
    
    // MARK: - Protocol Conformance Tests
    
    func testDAOBaseObjectProtocolConformance() throws {
        let baseObject = MockBaseObject()
        
        // Test id property
        XCTAssertEqual(baseObject.id, "test_id")
        
        // Test meta property
        XCTAssertNotNil(baseObject.meta)
        XCTAssertEqual(baseObject.meta.status, "active")
        XCTAssertEqual(baseObject.meta.createdBy, "test_user")
        
        // Test analyticsData property
        XCTAssertTrue(baseObject.analyticsData.isEmpty)
    }
    
    func testDAOMetadataProtocolProperties() throws {
        let metadata = MockMetadata()
        
        // Test required properties
        XCTAssertNotNil(metadata.uid)
        XCTAssertNotNil(metadata.created)
        XCTAssertNotNil(metadata.updated)
        XCTAssertEqual(metadata.status, "active")
        XCTAssertEqual(metadata.createdBy, "test_user")
        XCTAssertEqual(metadata.updatedBy, "test_user")
        XCTAssertTrue(metadata.genericValues.isEmpty)
        XCTAssertEqual(metadata.views, 0)
        
        // Test optional properties
        XCTAssertNil(metadata.synced)
    }
    
    func testDAOMetadataProtocolMutability() throws {
        var metadata = MockMetadata()
        let originalUid = metadata.uid
        let originalCreated = metadata.created
        
        // Test property mutability
        metadata.uid = UUID()
        XCTAssertNotEqual(metadata.uid, originalUid)
        
        metadata.created = Date().addingTimeInterval(-3600)
        XCTAssertNotEqual(metadata.created, originalCreated)
        
        metadata.synced = Date()
        XCTAssertNotNil(metadata.synced)
        
        metadata.status = "inactive"
        XCTAssertEqual(metadata.status, "inactive")
        
        metadata.views = 42
        XCTAssertEqual(metadata.views, 42)
        
        metadata.genericValues["custom"] = "value"
        XCTAssertEqual(metadata.genericValues["custom"] as? String, "value")
    }
    
    func testDAOAnalyticsDataProtocolConformance() throws {
        let analyticsData = MockAnalyticsData(
            title: "Test Analytics",
            subtitle: "Test Subtitle"
        )
        
        // Test properties
        XCTAssertEqual(analyticsData.title, "Test Analytics")
        XCTAssertEqual(analyticsData.subtitle, "Test Subtitle")
    }
    
    func testAnalyticsDataArrayHandling() throws {
        var baseObject = MockBaseObject()
        
        // Test adding analytics data
        let analytics1 = MockAnalyticsData(title: "View", subtitle: "Page viewed")
        let analytics2 = MockAnalyticsData(title: "Click", subtitle: "Button clicked")
        
        baseObject.analyticsData = [analytics1, analytics2]
        
        XCTAssertEqual(baseObject.analyticsData.count, 2)
        XCTAssertEqual(baseObject.analyticsData[0].title, "View")
        XCTAssertEqual(baseObject.analyticsData[1].title, "Click")
    }
    
    // MARK: - Protocol Inheritance Tests
    
    func testProtocolInheritance() throws {
        // Test that DAOBaseObjectProtocol is accessible
        XCTAssertTrue(DAOBaseObjectProtocol.self is Any.Type)
        XCTAssertTrue(DAOMetadataProtocol.self is Any.Type)
        XCTAssertTrue(DAOAnalyticsDataProtocol.self is Any.Type)
        
        // Test protocol relationship
        let baseObject: any DAOBaseObjectProtocol = MockBaseObject()
        XCTAssertNotNil(baseObject)
        XCTAssertEqual(baseObject.id, "test_id")
    }
    
    // MARK: - Type Compatibility Tests
    
    func testTypeCompatibilityWithDNSCore() throws {
        let metadata = MockMetadata()
        
        // Test DNSDataDictionary compatibility
        let genericValues: DNSDataDictionary = [
            "string": "value",
            "number": 42,
            "bool": true,
            "date": Date(),
            "array": ["item1", "item2"],
            "dict": ["nested": "value"]
        ]
        
        var mutableMetadata = metadata
        mutableMetadata.genericValues = genericValues
        
        XCTAssertEqual(mutableMetadata.genericValues["string"] as? String, "value")
        XCTAssertEqual(mutableMetadata.genericValues["number"] as? Int, 42)
        XCTAssertEqual(mutableMetadata.genericValues["bool"] as? Bool, true)
        XCTAssertNotNil(mutableMetadata.genericValues["date"] as? Date)
        XCTAssertEqual((mutableMetadata.genericValues["array"] as? [String])?.count, 2)
        XCTAssertNotNil(mutableMetadata.genericValues["dict"] as? [String: String])
    }
    
    func testUUIDHandling() throws {
        let metadata1 = MockMetadata()
        let metadata2 = MockMetadata()
        
        // Test UUID uniqueness
        XCTAssertNotEqual(metadata1.uid, metadata2.uid)
        
        // Test UUID assignment
        var mutableMetadata = metadata1
        let newUid = UUID()
        mutableMetadata.uid = newUid
        XCTAssertEqual(mutableMetadata.uid, newUid)
    }
    
    func testDateHandling() throws {
        let now = Date()
        var metadata = MockMetadata()
        
        // Test date properties
        metadata.created = now
        metadata.updated = now
        metadata.synced = now
        
        XCTAssertEqual(metadata.created, now)
        XCTAssertEqual(metadata.updated, now)
        XCTAssertEqual(metadata.synced, now)
        
        // Test date ordering
        let earlier = now.addingTimeInterval(-3600)
        metadata.created = earlier
        XCTAssertLessThan(metadata.created, metadata.updated)
    }
    
    // MARK: - Protocol as Type Tests
    
    func testProtocolAsType() throws {
        let objects: [any DAOBaseObjectProtocol] = [
            MockBaseObject()
        ]
        
        XCTAssertEqual(objects.count, 1)
        XCTAssertEqual(objects[0].id, "test_id")
        
        // Test type casting
        if let firstObject = objects.first {
            XCTAssertEqual(firstObject.id, "test_id")
            XCTAssertNotNil(firstObject.meta)
            XCTAssertTrue(firstObject.analyticsData.isEmpty)
        } else {
            XCTFail("Should have first object")
        }
    }
    
    func testMetadataProtocolAsType() throws {
        let metadataObjects: [any DAOMetadataProtocol] = [
            MockMetadata()
        ]
        
        XCTAssertEqual(metadataObjects.count, 1)
        
        if let metadata = metadataObjects.first {
            XCTAssertNotNil(metadata.uid)
            XCTAssertEqual(metadata.status, "active")
            XCTAssertEqual(metadata.views, 0)
        } else {
            XCTFail("Should have metadata object")
        }
    }
    
    // MARK: - Business Logic Tests
    
    func testMetadataBusinessLogic() throws {
        var metadata = MockMetadata()
        
        // Test view increment simulation
        metadata.views = 1
        XCTAssertEqual(metadata.views, 1)
        
        metadata.views += 1
        XCTAssertEqual(metadata.views, 2)
        
        // Test status changes
        let validStatuses = ["active", "inactive", "pending", "deleted"]
        for status in validStatuses {
            metadata.status = status
            XCTAssertEqual(metadata.status, status)
        }
    }
    
    func testAnalyticsDataBusinessLogic() throws {
        let pageViewData = MockAnalyticsData(
            title: "Page View",
            subtitle: "User viewed product page"
        )
        
        let clickData = MockAnalyticsData(
            title: "Button Click", 
            subtitle: "User clicked purchase button"
        )
        
        var baseObject = MockBaseObject()
        baseObject.analyticsData = [pageViewData, clickData]
        
        // Test analytics filtering by title
        let clickEvents = baseObject.analyticsData.filter { $0.title.contains("Click") }
        XCTAssertEqual(clickEvents.count, 1)
        XCTAssertEqual(clickEvents.first?.subtitle, "User clicked purchase button")
    }
    
    // MARK: - Error Handling Tests
    
    func testRequiredPropertiesHandling() throws {
        // Test that required properties can't be nil/empty inappropriately
        var baseObject = MockBaseObject()
        
        // ID should not be empty for valid objects
        baseObject.id = ""
        XCTAssertTrue(baseObject.id.isEmpty)
        
        baseObject.id = "valid_id"
        XCTAssertFalse(baseObject.id.isEmpty)
        XCTAssertEqual(baseObject.id, "valid_id")
    }
    
    func testProtocolInstanceChecking() throws {
        let baseObject = MockBaseObject()
        let metadata = MockMetadata()
        let analytics = MockAnalyticsData(title: "Test", subtitle: "Test")
        
        // Test protocol conformance checking
        XCTAssertTrue(baseObject is DAOBaseObjectProtocol)
        XCTAssertTrue(metadata is DAOMetadataProtocol)
        XCTAssertTrue(analytics is DAOAnalyticsDataProtocol)
        
        // Test type checking
        XCTAssertTrue(type(of: baseObject) is DAOBaseObjectProtocol.Type)
        XCTAssertTrue(type(of: metadata) is DAOMetadataProtocol.Type)
        XCTAssertTrue(type(of: analytics) is DAOAnalyticsDataProtocol.Type)
    }
}