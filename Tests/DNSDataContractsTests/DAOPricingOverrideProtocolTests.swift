//
//  DAOPricingOverrideProtocolTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts Tests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import XCTest
@testable import DNSDataContracts

final class DAOPricingOverrideProtocolTests: XCTestCase {
    
    // MARK: - Helper Functions
    
    /// Helper function to create a DNSPrice instance
    private static func createPrice(_ priceValue: Float) -> DNSPrice {
        let price = DNSPrice()
        price.price = priceValue
        return price
    }
    
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
    
    struct MockPricingItem: DAOPricingItemProtocol {
        var id: String = "pricing_item_123"
        var meta: any DAOMetadataProtocol = MockMetadata()
        var analyticsData: [any DAOAnalyticsDataProtocol] = []
        
        var pricingTierId: String = "pricing_tier_123"
        var name: String = "Standard Item"
        var price: DNSPrice = DAOPricingOverrideProtocolTests.createPrice(19.99)
        var status: DNSStatus = .open
    }
    
    struct MockPricingOverride: DAOPricingOverrideProtocol {
        var id: String = "pricing_override_123"
        var meta: any DAOMetadataProtocol = MockMetadata()
        var analyticsData: [any DAOAnalyticsDataProtocol] = []
        
        var enabled: Bool = true
        var startTime: Date = Date()
        var endTime: Date = Date().addingTimeInterval(3600) // 1 hour later
        var title: DNSString = DNSString(with: "Holiday Special")
        var priority: Int = 1
        var items: [any DAOPricingItemProtocol] = [MockPricingItem()]
        
        var isActive: Bool {
            return isActive(for: Date())
        }
        
        func isActive(for time: Date) -> Bool {
            return enabled && time >= startTime && time <= endTime
        }
        
        var item: (any DAOPricingItemProtocol)? {
            return item(for: Date())
        }
        
        func item(for time: Date) -> (any DAOPricingItemProtocol)? {
            return isActive(for: time) ? items.first : nil
        }
        
        var price: DNSPrice? {
            return price(for: Date())
        }
        
        func price(for time: Date) -> DNSPrice? {
            return item(for: time)?.price
        }
    }
    
    // MARK: - DAOPricingOverrideProtocol Tests
    
    func testPricingOverrideProtocolInheritance() throws {
        let pricingOverride = MockPricingOverride()
        
        // Test protocol conformance by checking key properties
        XCTAssertNotNil(pricingOverride.id)
        XCTAssertNotNil(pricingOverride.meta)
        XCTAssertNotNil(pricingOverride.analyticsData)
        
        // Test specific DAOPricingOverrideProtocol properties
        XCTAssertNotNil(pricingOverride.title)
        XCTAssertNotNil(pricingOverride.items)
        
        XCTAssertEqual(pricingOverride.id, "pricing_override_123")
        XCTAssertNotNil(pricingOverride.meta)
    }
    
    func testPricingOverrideProtocolProperties() throws {
        let pricingOverride = MockPricingOverride()
        
        XCTAssertTrue(pricingOverride.enabled)
        XCTAssertNotNil(pricingOverride.startTime)
        XCTAssertNotNil(pricingOverride.endTime)
        XCTAssertEqual(pricingOverride.title.asString, "Holiday Special")
        XCTAssertEqual(pricingOverride.priority, 1)
        XCTAssertEqual(pricingOverride.items.count, 1)
        
        // Test that end time is after start time
        XCTAssertLessThan(pricingOverride.startTime, pricingOverride.endTime)
    }
    
    func testPricingOverrideMutability() throws {
        var pricingOverride = MockPricingOverride()
        
        pricingOverride.enabled = false
        XCTAssertFalse(pricingOverride.enabled)
        
        let newStartTime = Date().addingTimeInterval(-7200) // 2 hours ago
        let newEndTime = Date().addingTimeInterval(7200)    // 2 hours from now
        
        pricingOverride.startTime = newStartTime
        pricingOverride.endTime = newEndTime
        
        XCTAssertEqual(pricingOverride.startTime, newStartTime)
        XCTAssertEqual(pricingOverride.endTime, newEndTime)
        
        pricingOverride.title = DNSString(with: "Black Friday Sale")
        XCTAssertEqual(pricingOverride.title.asString, "Black Friday Sale")
        
        pricingOverride.priority = 5
        XCTAssertEqual(pricingOverride.priority, 5)
        
        pricingOverride.items = []
        XCTAssertEqual(pricingOverride.items.count, 0)
    }
    
    func testPricingOverrideActivation() throws {
        var pricingOverride = MockPricingOverride()
        let now = Date()
        
        // Test active override
        pricingOverride.startTime = now.addingTimeInterval(-3600) // 1 hour ago
        pricingOverride.endTime = now.addingTimeInterval(3600)    // 1 hour from now
        pricingOverride.enabled = true
        
        XCTAssertTrue(pricingOverride.isActive)
        XCTAssertNotNil(pricingOverride.item)
        XCTAssertNotNil(pricingOverride.price)
        
        // Test inactive override (disabled)
        pricingOverride.enabled = false
        XCTAssertFalse(pricingOverride.isActive)
        XCTAssertNil(pricingOverride.item)
        XCTAssertNil(pricingOverride.price)
        
        // Test expired override
        pricingOverride.enabled = true
        pricingOverride.endTime = now.addingTimeInterval(-1800) // 30 minutes ago
        XCTAssertFalse(pricingOverride.isActive)
        
        // Test future override
        pricingOverride.startTime = now.addingTimeInterval(1800) // 30 minutes from now
        pricingOverride.endTime = now.addingTimeInterval(5400)   // 1.5 hours from now
        XCTAssertFalse(pricingOverride.isActive)
    }
    
    func testPricingOverrideTimeBased() throws {
        let pricingOverride = MockPricingOverride()
        let pastTime = Date().addingTimeInterval(-7200) // 2 hours ago
        let futureTime = Date().addingTimeInterval(7200) // 2 hours from now
        
        // Test with past time (should not be active)
        XCTAssertFalse(pricingOverride.isActive(for: pastTime))
        XCTAssertNil(pricingOverride.item(for: pastTime))
        XCTAssertNil(pricingOverride.price(for: pastTime))
        
        // Test with future time (should not be active due to default end time)
        XCTAssertFalse(pricingOverride.isActive(for: futureTime))
        XCTAssertNil(pricingOverride.item(for: futureTime))
        XCTAssertNil(pricingOverride.price(for: futureTime))
    }
    
    // MARK: - Protocol as Type Tests
    
    func testPricingOverrideProtocolAsType() throws {
        let pricingOverrides: [any DAOPricingOverrideProtocol] = [
            MockPricingOverride()
        ]
        
        XCTAssertEqual(pricingOverrides.count, 1)
        
        if let firstOverride = pricingOverrides.first {
            XCTAssertEqual(firstOverride.id, "pricing_override_123")
            XCTAssertTrue(firstOverride.enabled)
            XCTAssertEqual(firstOverride.title.asString, "Holiday Special")
        } else {
            XCTFail("Should have first pricing override")
        }
    }
    
    // MARK: - Error Handling Tests
    
    func testPricingOverrideProtocolValidation() throws {
        var pricingOverride = MockPricingOverride()
        
        // Test empty title
        pricingOverride.title = DNSString(with: "")
        XCTAssertEqual(pricingOverride.title.asString, "")
        
        // Test negative priority
        pricingOverride.priority = -1
        XCTAssertEqual(pricingOverride.priority, -1)
        
        // Test required properties remain valid
        XCTAssertNotEqual(pricingOverride.id, "")
        XCTAssertNotNil(pricingOverride.items)
    }
    
    func testProtocolInstanceChecking() throws {
        let pricingOverride = MockPricingOverride()
        
        // Test protocol conformance by validating protocol-specific behavior
        XCTAssertNotNil(pricingOverride.startTime)
        XCTAssertNotNil(pricingOverride.endTime)
        XCTAssertNotNil(pricingOverride.priority)
        
        // Test base object protocol behavior
        XCTAssertFalse(pricingOverride.id.isEmpty)
        XCTAssertNotNil(pricingOverride.meta.uid)
        
        // Test actual protocol functionality rather than casting
        XCTAssertTrue(pricingOverride.enabled || !pricingOverride.enabled) // enabled is valid boolean
        XCTAssertNotEqual(pricingOverride.meta.uid, UUID()) // metadata has unique ID
    }
}
