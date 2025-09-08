//
//  DAOPricingProtocolTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts Tests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import XCTest
@testable import DNSDataContracts

final class DAOPricingProtocolTests: XCTestCase {
    
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
    
    struct MockPricingTier: DAOPricingTierProtocol {
        var id: String = "pricing_tier_123"
        var meta: any DAOMetadataProtocol = MockMetadata()
        var analyticsData: [any DAOAnalyticsDataProtocol] = []
        
        var pricingId: String = "pricing_123"
        var name: String = "Standard Tier"
        var items: [any DAOPricingItemProtocol] = []
        var exceptions: [any DAOPricingOverrideProtocol] = []
        var status: DNSStatus = .open
    }
    
    struct MockPricing: DAOPricingProtocol {
        var id: String = "pricing_123"
        var meta: any DAOMetadataProtocol = MockMetadata()
        var analyticsData: [any DAOAnalyticsDataProtocol] = []
        
        var name: String = "Standard Pricing"
        var tiers: [any DAOPricingTierProtocol] = [MockPricingTier()]
        var status: DNSStatus = .open
    }
    
    
    // MARK: - Pricing Protocol Tests
    
    func testDAOPricingProtocolInheritance() throws {
        let pricing = MockPricing()
        
        XCTAssertTrue(pricing is DAOBaseObjectProtocol)
        XCTAssertTrue(pricing is DAOPricingProtocol)
        
        XCTAssertEqual(pricing.id, "pricing_123")
        XCTAssertNotNil(pricing.meta)
    }
    
    func testPricingProtocolProperties() throws {
        let pricing = MockPricing()
        
        XCTAssertEqual(pricing.name, "Standard Pricing")
        XCTAssertEqual(pricing.tiers.count, 1)
        XCTAssertEqual(pricing.status, .open)
    }
    
    func testPricingMutability() throws {
        var pricing = MockPricing()
        
        pricing.name = "Premium Pricing"
        XCTAssertEqual(pricing.name, "Premium Pricing")
        
        pricing.tiers = []
        XCTAssertEqual(pricing.tiers.count, 0)
        
        pricing.status = .closed
        XCTAssertEqual(pricing.status, .closed)
    }
    
    // MARK: - Protocol as Type Tests
    
    func testPricingProtocolAsType() throws {
        let pricing: any DAOPricingProtocol = MockPricing()
        
        XCTAssertEqual(pricing.id, "pricing_123")
        XCTAssertEqual(pricing.name, "Standard Pricing")
        XCTAssertEqual(pricing.tiers.count, 1)
    }
    
    // MARK: - Integration Tests
    
    func testPricingTierIntegration() throws {
        let pricing = MockPricing()
        
        // Test pricing contains tiers
        XCTAssertEqual(pricing.tiers.count, 1)
        
        if let firstTier = pricing.tiers.first {
            XCTAssertEqual(firstTier.pricingId, pricing.id)
        } else {
            XCTFail("Should have first tier")
        }
    }
    
    // MARK: - Error Handling Tests
    
    func testPricingProtocolValidation() throws {
        var pricing = MockPricing()
        
        // Test empty names
        pricing.name = ""
        XCTAssertEqual(pricing.name, "")
        
        // Test required properties remain valid
        XCTAssertNotEqual(pricing.id, "")
        XCTAssertNotNil(pricing.tiers)
    }
    
    func testProtocolInstanceChecking() throws {
        let pricing = MockPricing()
        
        // Test protocol conformance
        XCTAssertTrue(pricing is DAOPricingProtocol)
        
        // Test base object conformance
        XCTAssertTrue(pricing is DAOBaseObjectProtocol)
        
        // Test type checking with casting
        XCTAssertNotNil(pricing as? DAOPricingProtocol)
        XCTAssertNotNil(pricing as? DAOBaseObjectProtocol)
    }
}
