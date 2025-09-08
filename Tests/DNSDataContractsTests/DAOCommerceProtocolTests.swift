//
//  DAOCommerceProtocolTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts Tests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
@testable import DNSDataContracts

final class DAOCommerceProtocolTests: XCTestCase {
    
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
        var price: DNSPrice? = DAOCommerceProtocolTests.createPrice(19.99)
        var status: DNSStatus = .open
        var visibility: DNSVisibility = .everyone
    }
    
    struct MockBasketItem: DAOBasketItemProtocol {
        var id: String = "basket_item_123"
        var meta: any DAOMetadataProtocol = MockMetadata()
        var analyticsData: [any DAOAnalyticsDataProtocol] = []
        
        var basketId: String = "basket_123"
        var productId: String = "product_123"
        var quantity: Int = 2
        var unitPrice: DNSPrice? = DAOCommerceProtocolTests.createPrice(19.99)
        var totalPrice: DNSPrice? = DAOCommerceProtocolTests.createPrice(39.98)
    }
    
    struct MockBasket: DAOBasketProtocol {
        var id: String = "basket_123"
        var meta: any DAOMetadataProtocol = MockMetadata()
        var analyticsData: [any DAOAnalyticsDataProtocol] = []
        
        var userId: String? = "user_456"
        var items: [any DAOBasketItemProtocol] = [MockBasketItem()]
        var status: DNSStatus = .open
        var totalAmount: DNSPrice? = DAOCommerceProtocolTests.createPrice(39.98)
    }
    
    struct MockOrderItem: DAOOrderItemProtocol {
        var id: String = "order_item_123"
        var meta: any DAOMetadataProtocol = MockMetadata()
        var analyticsData: [any DAOAnalyticsDataProtocol] = []
        
        var orderId: String = "order_123"
        var productId: String = "product_123"
        var quantity: Int = 2
        var unitPrice: DNSPrice? = DAOCommerceProtocolTests.createPrice(19.99)
        var totalPrice: DNSPrice? = DAOCommerceProtocolTests.createPrice(39.98)
    }
    
    struct MockOrder: DAOOrderProtocol {
        var id: String = "order_123"
        var meta: any DAOMetadataProtocol = MockMetadata()
        var analyticsData: [any DAOAnalyticsDataProtocol] = []
        
        var userId: String? = "user_456"
        var orderNumber: String? = "ORD-2025-001"
        var items: [any DAOOrderItemProtocol] = [MockOrderItem()]
        var status: DNSOrderState = .pending
        var totalAmount: DNSPrice? = DAOCommerceProtocolTests.createPrice(39.98)
        var orderDate: Date? = Date()
    }
    
    struct MockTransaction: DAOTransactionProtocol {
        var id: String = "transaction_123"
        var meta: any DAOMetadataProtocol = MockMetadata()
        var analyticsData: [any DAOAnalyticsDataProtocol] = []
        
        var userId: String? = "user_456"
        var orderId: String? = "order_123"
        var amount: DNSPrice = DAOCommerceProtocolTests.createPrice(39.98)
        var transactionType: String = "payment"
        var status: DNSStatus = .open
        var transactionDate: Date? = Date()
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
        
        let newPrice = DAOCommerceProtocolTests.createPrice(29.99)
        product.price = newPrice
        XCTAssertEqual(product.price?.price ?? 0, 29.99, accuracy: 0.01)
        
        product.status = .closed
        XCTAssertEqual(product.status, .closed)
        
        product.visibility = .staffOnly
        XCTAssertEqual(product.visibility, .staffOnly)
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
        
        let newTotalPrice = DAOCommerceProtocolTests.createPrice(59.97)
        basketItem.totalPrice = newTotalPrice
        XCTAssertEqual(basketItem.totalPrice?.price ?? 0, 59.97, accuracy: 0.01)
    }
    
    // MARK: - Order Protocol Tests
    
    func testDAOOrderProtocolInheritance() throws {
        let order = MockOrder()
        
        XCTAssertTrue(order is DAOBaseObjectProtocol)
        XCTAssertTrue(order is DAOOrderProtocol)
        
        XCTAssertEqual(order.id, "order_123")
        XCTAssertNotNil(order.meta)
    }
    
    func testOrderProtocolProperties() throws {
        let order = MockOrder()
        
        XCTAssertEqual(order.userId, "user_456")
        XCTAssertEqual(order.orderNumber, "ORD-2025-001")
        XCTAssertEqual(order.items.count, 1)
        XCTAssertEqual(order.status, .pending)
        XCTAssertNotNil(order.totalAmount)
        XCTAssertNotNil(order.orderDate)
        
        if let totalAmount = order.totalAmount {
            XCTAssertEqual(totalAmount.price, 39.98, accuracy: 0.01)
        }
    }
    
    func testOrderItemProtocolProperties() throws {
        let orderItem = MockOrderItem()
        
        XCTAssertEqual(orderItem.orderId, "order_123")
        XCTAssertEqual(orderItem.productId, "product_123")
        XCTAssertEqual(orderItem.quantity, 2)
        XCTAssertNotNil(orderItem.unitPrice)
        XCTAssertNotNil(orderItem.totalPrice)
        
        if let unitPrice = orderItem.unitPrice,
           let totalPrice = orderItem.totalPrice {
            XCTAssertEqual(unitPrice.price, 19.99, accuracy: 0.01)
            XCTAssertEqual(totalPrice.price, 39.98, accuracy: 0.01)
            XCTAssertEqual(totalPrice.price, unitPrice.price * Float(orderItem.quantity), accuracy: 0.01)
        }
    }
    
    func testOrderStatusValues() throws {
        var order = MockOrder()
        
        let orderStates: [DNSOrderState] = [.pending, .processing, .completed, .cancelled]
        
        for state in orderStates {
            order.status = state
            XCTAssertEqual(order.status, state)
        }
    }
    
    // MARK: - Transaction Protocol Tests
    
    func testDAOTransactionProtocolInheritance() throws {
        let transaction = MockTransaction()
        
        XCTAssertTrue(transaction is DAOBaseObjectProtocol)
        XCTAssertTrue(transaction is DAOTransactionProtocol)
        
        XCTAssertEqual(transaction.id, "transaction_123")
        XCTAssertNotNil(transaction.meta)
    }
    
    func testTransactionProtocolProperties() throws {
        let transaction = MockTransaction()
        
        XCTAssertEqual(transaction.userId, "user_456")
        XCTAssertEqual(transaction.orderId, "order_123")
        XCTAssertEqual(transaction.amount.price, 39.98, accuracy: 0.01)
        XCTAssertEqual(transaction.transactionType, "payment")
        XCTAssertEqual(transaction.status, .open)
        XCTAssertNotNil(transaction.transactionDate)
    }
    
    func testTransactionMutability() throws {
        var transaction = MockTransaction()
        
        transaction.transactionType = "refund"
        XCTAssertEqual(transaction.transactionType, "refund")
        
        let refundAmount = DAOCommerceProtocolTests.createPrice(-39.98)
        transaction.amount = refundAmount
        XCTAssertEqual(transaction.amount.price, -39.98, accuracy: 0.01)
        
        transaction.status = .closed
        XCTAssertEqual(transaction.status, .closed)
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
        let salePrice = DAOCommerceProtocolTests.createPrice(15.99)
        product.price = salePrice
        XCTAssertEqual(product.price?.price ?? 0, 15.99, accuracy: 0.01)
    }
    
    func testBasketBusinessLogic() throws {
        var basket = MockBasket()
        var basketItem = MockBasketItem()
        
        // Test adding items to basket
        basketItem.quantity = 3
        let newTotalPrice = DAOCommerceProtocolTests.createPrice(59.97)
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
        let expectedTotal = DAOCommerceProtocolTests.createPrice(79.96)
        basket.totalAmount = expectedTotal
        XCTAssertEqual(basket.totalAmount?.price ?? 0, 79.96, accuracy: 0.01)
    }
    
    func testOrderBusinessLogic() throws {
        var order = MockOrder()
        
        // Test order status workflow
        order.status = .pending
        XCTAssertEqual(order.status, .pending)
        
        order.status = .processing
        XCTAssertEqual(order.status, .processing)
        
        order.status = .completed
        XCTAssertEqual(order.status, .completed)
        
        // Test order cancellation
        order.status = .cancelled
        XCTAssertEqual(order.status, .cancelled)
        
        // Test order number generation pattern
        if let orderNumber = order.orderNumber {
            XCTAssertTrue(orderNumber.hasPrefix("ORD-"))
            XCTAssertTrue(orderNumber.contains("2025"))
        }
    }
    
    func testTransactionBusinessLogic() throws {
        var transaction = MockTransaction()
        
        // Test payment transaction
        transaction.transactionType = "payment"
        transaction.amount = DAOCommerceProtocolTests.createPrice(39.98)
        XCTAssertEqual(transaction.transactionType, "payment")
        XCTAssertGreaterThan(transaction.amount.price, 0)
        
        // Test refund transaction
        transaction.transactionType = "refund"
        transaction.amount = DAOCommerceProtocolTests.createPrice(-39.98)
        XCTAssertEqual(transaction.transactionType, "refund")
        XCTAssertLessThan(transaction.amount.price, 0)
        
        // Test transaction types
        let validTransactionTypes = ["payment", "refund", "adjustment", "fee", "discount"]
        for type in validTransactionTypes {
            transaction.transactionType = type
            XCTAssertEqual(transaction.transactionType, type)
        }
    }
    
    // MARK: - Protocol as Type Tests
    
    func testCommerceProtocolsAsTypes() throws {
        let product: any DAOProductProtocol = MockProduct()
        let basket: any DAOBasketProtocol = MockBasket()
        let order: any DAOOrderProtocol = MockOrder()
        let transaction: any DAOTransactionProtocol = MockTransaction()
        
        XCTAssertEqual(product.id, "product_123")
        XCTAssertEqual(basket.id, "basket_123")
        XCTAssertEqual(order.id, "order_123")
        XCTAssertEqual(transaction.id, "transaction_123")
        
        // Test protocol arrays
        let commerceObjects: [any DAOBaseObjectProtocol] = [product, basket, order, transaction]
        XCTAssertEqual(commerceObjects.count, 4)
        
        // Test type filtering
        let products = commerceObjects.compactMap { $0 as? DAOProductProtocol }
        let baskets = commerceObjects.compactMap { $0 as? DAOBasketProtocol }
        let orders = commerceObjects.compactMap { $0 as? DAOOrderProtocol }
        let transactions = commerceObjects.compactMap { $0 as? DAOTransactionProtocol }
        
        XCTAssertEqual(products.count, 1)
        XCTAssertEqual(baskets.count, 1)
        XCTAssertEqual(orders.count, 1)
        XCTAssertEqual(transactions.count, 1)
    }
    
    // MARK: - Integration Tests
    
    func testCommerceWorkflow() throws {
        let product = MockProduct()
        var basketItem = MockBasketItem()
        var basket = MockBasket()
        var orderItem = MockOrderItem()
        var order = MockOrder()
        var transaction = MockTransaction()
        
        // Test product -> basket workflow
        basketItem.productId = product.id
        basketItem.unitPrice = product.price
        basket.items = [basketItem]
        
        XCTAssertEqual(basketItem.productId, product.id)
        XCTAssertEqual(basketItem.unitPrice?.price, product.price?.price)
        
        // Test basket -> order workflow
        orderItem.productId = product.id
        orderItem.unitPrice = product.price
        order.items = [orderItem]
        order.status = .pending
        
        XCTAssertEqual(orderItem.productId, product.id)
        XCTAssertEqual(order.status, .pending)
        
        // Test order -> transaction workflow
        transaction.orderId = order.id
        transaction.amount = order.totalAmount ?? DAOCommerceProtocolTests.createPrice(0)
        transaction.transactionType = "payment"
        
        XCTAssertEqual(transaction.orderId, order.id)
        XCTAssertEqual(transaction.transactionType, "payment")
        
        // Test order fulfillment
        order.status = .processing
        XCTAssertEqual(order.status, .processing)
        
        order.status = .completed
        XCTAssertEqual(order.status, .completed)
    }
    
    // MARK: - Price Calculation Tests
    
    func testPriceCalculations() throws {
        let unitPrice = DAOCommerceProtocolTests.createPrice(19.99)
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
    
    func testCommerceProtocolValidation() throws {
        var product = MockProduct()
        var basket = MockBasket()
        var order = MockOrder()
        var transaction = MockTransaction()
        
        // Test empty names and IDs
        product.name = ""
        basket.userId = nil
        order.orderNumber = nil
        transaction.transactionType = ""
        
        XCTAssertEqual(product.name, "")
        XCTAssertNil(basket.userId)
        XCTAssertNil(order.orderNumber)
        XCTAssertEqual(transaction.transactionType, "")
        
        // Test required properties remain valid
        XCTAssertNotEqual(product.id, "")
        XCTAssertNotEqual(basket.id, "")
        XCTAssertNotEqual(order.id, "")
        XCTAssertNotEqual(transaction.id, "")
    }
    
    func testProtocolInstanceChecking() throws {
        let product = MockProduct()
        let basket = MockBasket()
        let basketItem = MockBasketItem()
        let order = MockOrder()
        let orderItem = MockOrderItem()
        let transaction = MockTransaction()
        
        // Test protocol conformance
        XCTAssertTrue(product is DAOProductProtocol)
        XCTAssertTrue(basket is DAOBasketProtocol)
        XCTAssertTrue(basketItem is DAOBasketItemProtocol)
        XCTAssertTrue(order is DAOOrderProtocol)
        XCTAssertTrue(orderItem is DAOOrderItemProtocol)
        XCTAssertTrue(transaction is DAOTransactionProtocol)
        
        // Test base object conformance
        XCTAssertTrue(product is DAOBaseObjectProtocol)
        XCTAssertTrue(basket is DAOBaseObjectProtocol)
        XCTAssertTrue(basketItem is DAOBaseObjectProtocol)
        XCTAssertTrue(order is DAOBaseObjectProtocol)
        XCTAssertTrue(orderItem is DAOBaseObjectProtocol)
        XCTAssertTrue(transaction is DAOBaseObjectProtocol)
    }
}