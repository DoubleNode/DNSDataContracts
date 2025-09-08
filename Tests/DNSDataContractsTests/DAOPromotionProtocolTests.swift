//
//  DAOPromotionProtocolTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts Tests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import XCTest
@testable import DNSDataContracts

final class DAOPromotionProtocolTests: XCTestCase {
    
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
    
    struct MockPromotion: DAOPromotionProtocol {
        var id: String = "promotion_123"
        var meta: any DAOMetadataProtocol = MockMetadata()
        var analyticsData: [any DAOAnalyticsDataProtocol] = []
        
        var name: String = "Test Promotion"
        var promotionDescription: String? = "A test promotional offer"
        var startDate: Date? = Date()
        var endDate: Date? = Date().addingTimeInterval(2592000) // 30 days
        var discountPercentage: Double? = 20.0
        var discountAmount: DNSPrice? = nil
        var status: DNSStatus = .open
        var visibility: DNSVisibility = .everyone
    }
    
    // MARK: - Promotion Protocol Tests
    
    func testDAOPromotionProtocolInheritance() throws {
        let promotion = MockPromotion()
        
        // Verify protocol conformance through required property access
        XCTAssertFalse(promotion.id.isEmpty)
        XCTAssertNotNil(promotion.meta)
        
        XCTAssertEqual(promotion.id, "promotion_123")
        XCTAssertNotNil(promotion.meta)
    }
    
    func testPromotionProtocolProperties() throws {
        let promotion = MockPromotion()
        
        XCTAssertEqual(promotion.name, "Test Promotion")
        XCTAssertEqual(promotion.promotionDescription, "A test promotional offer")
        XCTAssertNotNil(promotion.startDate)
        XCTAssertNotNil(promotion.endDate)
        XCTAssertEqual(promotion.discountPercentage ?? 0.0, 20.0, accuracy: 0.01)
        XCTAssertNil(promotion.discountAmount)
        XCTAssertEqual(promotion.status, .open)
        XCTAssertEqual(promotion.visibility, .everyone)
        
        // Test that end date is after start date
        if let startDate = promotion.startDate,
           let endDate = promotion.endDate {
            XCTAssertLessThan(startDate, endDate)
        }
    }
    
    func testPromotionDiscountTypes() throws {
        var promotion = MockPromotion()
        
        // Test percentage discount
        promotion.discountPercentage = 25.0
        promotion.discountAmount = nil
        XCTAssertEqual(promotion.discountPercentage ?? 0.0, 25.0, accuracy: 0.01)
        XCTAssertNil(promotion.discountAmount)
        
        // Test fixed amount discount
        promotion.discountPercentage = nil
        let discountPrice = DNSPrice()
        discountPrice.price = 10.0
        promotion.discountAmount = discountPrice
        XCTAssertNil(promotion.discountPercentage)
        XCTAssertNotNil(promotion.discountAmount)
        XCTAssertEqual(Double(promotion.discountAmount?.price ?? 0.0), 10.0, accuracy: 0.01)
    }
    
    // MARK: - Business Logic Tests
    
    func testPromotionValidation() throws {
        var promotion = MockPromotion()
        let now = Date()
        
        // Test active promotion
        promotion.startDate = now.addingTimeInterval(-86400) // 1 day ago
        promotion.endDate = now.addingTimeInterval(86400)    // 1 day from now
        
        if let startDate = promotion.startDate,
           let endDate = promotion.endDate {
            XCTAssertLessThan(startDate, now)
            XCTAssertGreaterThan(endDate, now)
        }
        
        // Test expired promotion
        promotion.endDate = now.addingTimeInterval(-3600) // 1 hour ago
        XCTAssertLessThan(promotion.endDate!, now)
        
        // Test future promotion
        promotion.startDate = now.addingTimeInterval(3600) // 1 hour from now
        promotion.endDate = now.addingTimeInterval(7200)   // 2 hours from now
        XCTAssertGreaterThan(promotion.startDate!, now)
    }
    
    // MARK: - Protocol as Type Tests
    
    func testPromotionProtocolAsType() throws {
        let promotion: any DAOPromotionProtocol = MockPromotion()
        
        XCTAssertEqual(promotion.id, "promotion_123")
        
        // Test protocol arrays
        let promotionObjects: [any DAOBaseObjectProtocol] = [promotion]
        XCTAssertEqual(promotionObjects.count, 1)
        
        // Test type filtering
        let promotions = promotionObjects.compactMap { $0 as? DAOPromotionProtocol }
        XCTAssertEqual(promotions.count, 1)
    }
    
    // MARK: - Integration Tests
    
    func testPromotionIntegration() throws {
        let promotion = MockPromotion()
        
        // Test promotion dates
        if let startDate = promotion.startDate,
           let endDate = promotion.endDate {
            XCTAssertLessThan(startDate, endDate)
        }
        
        // Test discount configuration
        if let discountPercentage = promotion.discountPercentage {
            XCTAssertGreaterThan(discountPercentage, 0)
            XCTAssertNil(promotion.discountAmount) // Only one discount type should be set
        }
    }
    
    // MARK: - Error Handling Tests
    
    func testPromotionProtocolValidation() throws {
        var promotion = MockPromotion()
        
        // Test empty names and required fields
        promotion.name = ""
        promotion.promotionDescription = ""
        
        XCTAssertEqual(promotion.name, "")
        XCTAssertEqual(promotion.promotionDescription, "")
        
        // Test required properties remain valid
        XCTAssertNotEqual(promotion.id, "")
    }
    
    func testProtocolInstanceChecking() throws {
        let promotion = MockPromotion()
        
        // Test protocol conformance by validating required properties exist and have expected values
        XCTAssertFalse(promotion.id.isEmpty)
        
        // Test base object conformance by validating metadata exists
        XCTAssertNotNil(promotion.meta)
    }
}
