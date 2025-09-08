//
//  DAOBasketProtocolTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts Tests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import XCTest
@testable import DNSDataContracts

final class DAOBasketProtocolTests: XCTestCase {
    
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
    
    struct MockBasketItem: DAOBasketItemProtocol {
        var id: String = "basket_item_123"
        var meta: any DAOMetadataProtocol = MockMetadata()
        var analyticsData: [any DAOAnalyticsDataProtocol] = []
        
        var basketId: String = "basket_123"
        var productId: String = "product_123"
        var quantity: Int = 2
        var unitPrice: DNSPrice? = DAOBasketProtocolTests.createPrice(19.99)
        var totalPrice: DNSPrice? = DAOBasketProtocolTests.createPrice(39.98)
    }
    
    struct MockBasket: DAOBasketProtocol {
        var id: String = "basket_123"
        var meta: any DAOMetadataProtocol = MockMetadata()
        var analyticsData: [any DAOAnalyticsDataProtocol] = []
        
        var userId: String? = "user_456"
        var items: [any DAOBasketItemProtocol] = [MockBasketItem()]
        var status: DNSStatus = .open
        var totalAmount: DNSPrice? = DAOBasketProtocolTests.createPrice(39.98)
    }
    
    // MARK: - Basket Protocol Tests
    
    func testDAOBasketProtocolInheritance() throws {
        let basket = MockBasket()
        
        XCTAssertTrue(basket is DAOBaseObjectProtocol)
        XCTAssertTrue(basket is DAOBasketProtocol)
        
        XCTAssertEqual(basket.id, "basket_123")
        XCTAssertNotNil(basket.meta)
    }
    
    func testBasketProtocolProperties() throws {
        let basket = MockBasket()
        
        XCTAssertEqual(basket.userId, "user_456")
        XCTAssertEqual(basket.items.count, 1)
        XCTAssertEqual(basket.status, .open)
        XCTAssertNotNil(basket.totalAmount)
        
        if let totalAmount = basket.totalAmount {
            XCTAssertEqual(totalAmount.price, 39.98, accuracy: 0.01)
        }
    }
    
    func testBasketItemProtocolProperties() throws {
        let basketItem = MockBasketItem()
        
        XCTAssertEqual(basketItem.basketId, "basket_123")
        XCTAssertEqual(basketItem.productId, "product_123")
        XCTAssertEqual(basketItem.quantity, 2)
        XCTAssertNotNil(basketItem.unitPrice)
        XCTAssertNotNil(basketItem.totalPrice)
        
        if let unitPrice = basketItem.unitPrice,
           let totalPrice = basketItem.totalPrice {
            XCTAssertEqual(unitPrice.price, 19.99, accuracy: 0.01)
            XCTAssertEqual(totalPrice.price, 39.98, accuracy: 0.01)
            XCTAssertEqual(totalPrice.price, unitPrice.price * Float(basketItem.quantity), accuracy: 0.01)
        }
    }
    
    func testBasketItemMutability() throws {
        var basketItem = MockBasketItem()
        
        basketItem.quantity = 3
        XCTAssertEqual(basketItem.quantity, 3)
        
        let newTotalPrice = DAOBasketProtocolTests.createPrice(59.97)
        basketItem.totalPrice = newTotalPrice
        XCTAssertEqual(basketItem.totalPrice?.price ?? 0, 59.97, accuracy: 0.01)
    }
    
    // MARK: - Business Logic Tests
    
    func testBasketBusinessLogic() throws {
        var basket = MockBasket()
        var basketItem = MockBasketItem()
        
        // Test adding items to basket
        basketItem.quantity = 3
        let newTotalPrice = DAOBasketProtocolTests.createPrice(59.97)
        basketItem.totalPrice = newTotalPrice
        
        basket.items = [basketItem]
        basket.totalAmount = newTotalPrice
        
        XCTAssertEqual(basket.items.count, 1)
        XCTAssertEqual(basket.items[0].quantity, 3)
        XCTAssertEqual(basket.totalAmount?.price ?? 0, 59.97, accuracy: 0.01)
        
        // Test basket total calculation
        let item2 = MockBasketItem()
        basket.items = [basketItem, item2]
        
        // In a real implementation, total would be calculated from all items
        let expectedTotal = DAOBasketProtocolTests.createPrice(79.96)
        basket.totalAmount = expectedTotal
        XCTAssertEqual(basket.totalAmount?.price ?? 0, 79.96, accuracy: 0.01)
    }
    
    // MARK: - Protocol as Type Tests
    
    func testBasketProtocolsAsTypes() throws {
        let basket: any DAOBasketProtocol = MockBasket()
        let basketItem: any DAOBasketItemProtocol = MockBasketItem()
        
        XCTAssertEqual(basket.id, "basket_123")
        XCTAssertEqual(basketItem.id, "basket_item_123")
        
        // Test protocol arrays
        let basketObjects: [any DAOBaseObjectProtocol] = [basket, basketItem]
        XCTAssertEqual(basketObjects.count, 2)
        
        // Test type filtering
        let baskets = basketObjects.compactMap { $0 as? DAOBasketProtocol }
        let basketItems = basketObjects.compactMap { $0 as? DAOBasketItemProtocol }
        
        XCTAssertEqual(baskets.count, 1)
        XCTAssertEqual(basketItems.count, 1)
    }
    
    // MARK: - Price Calculation Tests
    
    func testPriceCalculations() throws {
        let unitPrice = DAOBasketProtocolTests.createPrice(19.99)
        var basketItem = MockBasketItem()
        
        // Test quantity calculations
        let quantities = [1, 2, 3, 5, 10]
        
        for quantity in quantities {
            basketItem.quantity = quantity
            basketItem.unitPrice = unitPrice
            
            let expectedTotal = unitPrice.price * Float(quantity)
            let calculatedPrice = DNSPrice()
            calculatedPrice.price = expectedTotal
            basketItem.totalPrice = calculatedPrice
            
            XCTAssertEqual(basketItem.totalPrice?.price ?? 0, expectedTotal, accuracy: 0.01)
            XCTAssertEqual(basketItem.quantity, quantity)
        }
    }
    
    // MARK: - Error Handling Tests
    
    func testBasketProtocolValidation() throws {
        var basket = MockBasket()
        
        // Test empty user ID
        basket.userId = nil
        
        XCTAssertNil(basket.userId)
        
        // Test required properties remain valid
        XCTAssertNotEqual(basket.id, "")
    }
    
    func testProtocolInstanceChecking() throws {
        let basket = MockBasket()
        let basketItem = MockBasketItem()
        
        // Test protocol conformance
        XCTAssertTrue(basket is DAOBasketProtocol)
        XCTAssertTrue(basketItem is DAOBasketItemProtocol)
        
        // Test base object conformance
        XCTAssertTrue(basket is DAOBaseObjectProtocol)
        XCTAssertTrue(basketItem is DAOBaseObjectProtocol)
    }
}
