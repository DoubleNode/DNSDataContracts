//
//  DAOPricingItemProtocolTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts Tests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import XCTest
@testable import DNSDataContracts

final class DAOPricingItemProtocolTests: XCTestCase {
    
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
        var price: DNSPrice = DAOPricingItemProtocolTests.createPrice(19.99)
        var status: DNSStatus = .open
    }
    
    // MARK: - DAOPricingItemProtocol Tests
    
    func testPricingItemProtocolInheritance() throws {
        let pricingItem = MockPricingItem()
        
        XCTAssertTrue(pricingItem is DAOBaseObjectProtocol)
        XCTAssertTrue(pricingItem is DAOPricingItemProtocol)
        
        XCTAssertEqual(pricingItem.id, "pricing_item_123")
        XCTAssertNotNil(pricingItem.meta)
    }
    
    func testPricingItemProtocolProperties() throws {
        let pricingItem = MockPricingItem()
        
        XCTAssertEqual(pricingItem.pricingTierId, "pricing_tier_123")
        XCTAssertEqual(pricingItem.name, "Standard Item")
        XCTAssertEqual(pricingItem.price.price, 19.99, accuracy: 0.01)
        XCTAssertEqual(pricingItem.status, .open)
    }
    
    func testPricingItemMutability() throws {
        var pricingItem = MockPricingItem()
        
        pricingItem.pricingTierId = "pricing_tier_456"
        XCTAssertEqual(pricingItem.pricingTierId, "pricing_tier_456")
        
        pricingItem.name = "Premium Item"
        XCTAssertEqual(pricingItem.name, "Premium Item")
        
        pricingItem.price = Self.createPrice(29.99)
        XCTAssertEqual(pricingItem.price.price, 29.99, accuracy: 0.01)
        
        pricingItem.status = .closed
        XCTAssertEqual(pricingItem.status, .closed)
    }
    
    // MARK: - Protocol as Type Tests
    
    func testPricingItemProtocolAsType() throws {
        let pricingItems: [any DAOPricingItemProtocol] = [
            MockPricingItem()
        ]
        
        XCTAssertEqual(pricingItems.count, 1)
        
        if let firstItem = pricingItems.first {
            XCTAssertEqual(firstItem.id, "pricing_item_123")
            XCTAssertEqual(firstItem.pricingTierId, "pricing_tier_123")
            XCTAssertEqual(firstItem.name, "Standard Item")
        } else {
            XCTFail("Should have first pricing item")
        }
    }
    
    // MARK: - Error Handling Tests
    
    func testPricingItemProtocolValidation() throws {
        var pricingItem = MockPricingItem()
        
        // Test empty names and IDs
        pricingItem.name = ""
        pricingItem.pricingTierId = ""
        
        XCTAssertEqual(pricingItem.name, "")
        XCTAssertEqual(pricingItem.pricingTierId, "")
        
        // Test required properties remain valid
        XCTAssertNotEqual(pricingItem.id, "")
        XCTAssertNotNil(pricingItem.price)
        XCTAssertNotNil(pricingItem.status)
    }
    
    func testProtocolInstanceChecking() throws {
        let pricingItem = MockPricingItem()
        
        // Test protocol conformance
        XCTAssertTrue(pricingItem is DAOPricingItemProtocol)
        
        // Test base object conformance
        XCTAssertTrue(pricingItem is DAOBaseObjectProtocol)
        
        // Test type checking with casting
        XCTAssertNotNil(pricingItem as? DAOPricingItemProtocol)
        XCTAssertNotNil(pricingItem as? DAOBaseObjectProtocol)
    }
}
