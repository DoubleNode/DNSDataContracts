//
//  DAOProductProtocolTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts Tests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import XCTest
@testable import DNSDataContracts

final class DAOProductProtocolTests: XCTestCase {
    
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
    
    struct MockProduct: DAOProductProtocol {
        var id: String = "product_123"
        var meta: any DAOMetadataProtocol = MockMetadata()
        var analyticsData: [any DAOAnalyticsDataProtocol] = []
        
        var name: String = "Test Product"
        var productDescription: String? = "A test product for unit tests"
        var sku: String? = "TEST-PROD-123"
        var price: DNSPrice? = DAOProductProtocolTests.createPrice(19.99)
        var status: DNSStatus = .open
        var visibility: DNSVisibility = .everyone
    }
    
    // MARK: - Product Protocol Tests
    
    func testDAOProductProtocolInheritance() throws {
        let product = MockProduct()
        
        XCTAssertTrue(product is DAOBaseObjectProtocol)
        XCTAssertTrue(product is DAOProductProtocol)
        
        XCTAssertEqual(product.id, "product_123")
        XCTAssertNotNil(product.meta)
        XCTAssertTrue(product.analyticsData.isEmpty)
    }
    
    func testProductProtocolProperties() throws {
        let product = MockProduct()
        
        XCTAssertEqual(product.name, "Test Product")
        XCTAssertEqual(product.productDescription, "A test product for unit tests")
        XCTAssertEqual(product.sku, "TEST-PROD-123")
        XCTAssertNotNil(product.price)
        XCTAssertEqual(product.status, .open)
        XCTAssertEqual(product.visibility, .everyone)
        
        if let price = product.price {
            XCTAssertEqual(price.price, 19.99, accuracy: 0.01)
            XCTAssertNotNil(price.priority)
        }
    }
    
    func testProductProtocolMutability() throws {
        var product = MockProduct()
        
        product.name = "Updated Product"
        XCTAssertEqual(product.name, "Updated Product")
        
        product.productDescription = "Updated description"
        XCTAssertEqual(product.productDescription, "Updated description")
        
        product.sku = "UPD-PROD-456"
        XCTAssertEqual(product.sku, "UPD-PROD-456")
        
        let newPrice = DAOProductProtocolTests.createPrice(29.99)
        product.price = newPrice
        XCTAssertEqual(product.price?.price ?? 0, 29.99, accuracy: 0.01)
        
        product.status = .closed
        XCTAssertEqual(product.status, .closed)
        
        product.visibility = .staffOnly
        XCTAssertEqual(product.visibility, .staffOnly)
    }
    
    // MARK: - Business Logic Tests
    
    func testProductBusinessLogic() throws {
        var product = MockProduct()
        
        // Test product availability
        product.status = .open
        product.visibility = .everyone
        XCTAssertEqual(product.status, .open)
        XCTAssertEqual(product.visibility, .everyone)
        
        // Test product out of stock
        product.status = .closed
        XCTAssertEqual(product.status, .closed)
        
        // Test price updates
        let salePrice = DAOProductProtocolTests.createPrice(15.99)
        product.price = salePrice
        XCTAssertEqual(product.price?.price ?? 0, 15.99, accuracy: 0.01)
    }
    
    // MARK: - Protocol as Type Tests
    
    func testProductProtocolAsType() throws {
        let product: any DAOProductProtocol = MockProduct()
        
        XCTAssertEqual(product.id, "product_123")
        
        // Test protocol arrays
        let productObjects: [any DAOBaseObjectProtocol] = [product]
        XCTAssertEqual(productObjects.count, 1)
        
        // Test type filtering
        let products = productObjects.compactMap { $0 as? DAOProductProtocol }
        XCTAssertEqual(products.count, 1)
    }
    
    // MARK: - Error Handling Tests
    
    func testProductProtocolValidation() throws {
        var product = MockProduct()
        
        // Test empty names and IDs
        product.name = ""
        
        XCTAssertEqual(product.name, "")
        
        // Test required properties remain valid
        XCTAssertNotEqual(product.id, "")
    }
    
    func testProtocolInstanceChecking() throws {
        let product = MockProduct()
        
        // Test protocol conformance
        XCTAssertTrue(product is DAOProductProtocol)
        
        // Test base object conformance
        XCTAssertTrue(product is DAOBaseObjectProtocol)
    }
}
