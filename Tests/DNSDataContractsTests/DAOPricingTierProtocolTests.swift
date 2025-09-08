//
//  DAOPricingTierProtocolTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts Tests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import XCTest
@testable import DNSDataContracts

final class DAOPricingTierProtocolTests: XCTestCase {
    
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
        var price: DNSPrice = DAOPricingTierProtocolTests.createPrice(19.99)
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
    
    struct MockPricingTier: DAOPricingTierProtocol {
        var id: String = "pricing_tier_123"
        var meta: any DAOMetadataProtocol = MockMetadata()
        var analyticsData: [any DAOAnalyticsDataProtocol] = []
        
        var pricingId: String = "pricing_123"
        var name: String = "Standard Tier"
        var items: [any DAOPricingItemProtocol] = [MockPricingItem()]
        var exceptions: [any DAOPricingOverrideProtocol] = [MockPricingOverride()]
        var status: DNSStatus = .open
    }
    
    // MARK: - DAOPricingTierProtocol Tests
    
    func testPricingTierProtocolInheritance() throws {
        let pricingTier = MockPricingTier()
        
        XCTAssertTrue(pricingTier is DAOBaseObjectProtocol)
        XCTAssertTrue(pricingTier is DAOPricingTierProtocol)
        
        XCTAssertEqual(pricingTier.id, "pricing_tier_123")
        XCTAssertNotNil(pricingTier.meta)
    }
    
    func testPricingTierProtocolProperties() throws {
        let pricingTier = MockPricingTier()
        
        XCTAssertEqual(pricingTier.pricingId, "pricing_123")
        XCTAssertEqual(pricingTier.name, "Standard Tier")
        XCTAssertEqual(pricingTier.items.count, 1)
        XCTAssertEqual(pricingTier.exceptions.count, 1)
        XCTAssertEqual(pricingTier.status, .open)
    }
    
    func testPricingTierMutability() throws {
        var pricingTier = MockPricingTier()
        
        pricingTier.pricingId = "pricing_456"
        XCTAssertEqual(pricingTier.pricingId, "pricing_456")
        
        pricingTier.name = "Premium Tier"
        XCTAssertEqual(pricingTier.name, "Premium Tier")
        
        pricingTier.items = []
        XCTAssertEqual(pricingTier.items.count, 0)
        
        pricingTier.exceptions = []
        XCTAssertEqual(pricingTier.exceptions.count, 0)
        
        pricingTier.status = .closed
        XCTAssertEqual(pricingTier.status, .closed)
    }
    
    // MARK: - Protocol as Type Tests
    
    func testPricingTierProtocolAsType() throws {
        let pricingTiers: [any DAOPricingTierProtocol] = [
            MockPricingTier()
        ]
        
        XCTAssertEqual(pricingTiers.count, 1)
        
        if let firstTier = pricingTiers.first {
            XCTAssertEqual(firstTier.id, "pricing_tier_123")
            XCTAssertEqual(firstTier.pricingId, "pricing_123")
            XCTAssertEqual(firstTier.name, "Standard Tier")
        } else {
            XCTFail("Should have first pricing tier")
        }
    }
    
    // MARK: - Error Handling Tests
    
    func testPricingTierProtocolValidation() throws {
        var pricingTier = MockPricingTier()
        
        // Test empty names and IDs
        pricingTier.name = ""
        pricingTier.pricingId = ""
        
        XCTAssertEqual(pricingTier.name, "")
        XCTAssertEqual(pricingTier.pricingId, "")
        
        // Test required properties remain valid
        XCTAssertNotEqual(pricingTier.id, "")
        XCTAssertNotNil(pricingTier.items)
        XCTAssertNotNil(pricingTier.exceptions)
    }
    
    func testProtocolInstanceChecking() throws {
        let pricingTier = MockPricingTier()
        
        // Test protocol conformance
        XCTAssertTrue(pricingTier is DAOPricingTierProtocol)
        
        // Test base object conformance
        XCTAssertTrue(pricingTier is DAOBaseObjectProtocol)
        
        // Test type checking with casting
        XCTAssertNotNil(pricingTier as? DAOPricingTierProtocol)
        XCTAssertNotNil(pricingTier as? DAOBaseObjectProtocol)
    }
}
