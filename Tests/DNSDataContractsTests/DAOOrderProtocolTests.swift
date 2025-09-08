//
//  DAOOrderProtocolTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts Tests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import XCTest
@testable import DNSDataContracts

final class DAOOrderProtocolTests: XCTestCase {
    
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
    
    struct MockOrderItem: DAOOrderItemProtocol {
        var id: String = "order_item_123"
        var meta: any DAOMetadataProtocol = MockMetadata()
        var analyticsData: [any DAOAnalyticsDataProtocol] = []
        
        var orderId: String = "order_123"
        var productId: String = "product_123"
        var quantity: Int = 2
        var unitPrice: DNSPrice? = DAOOrderProtocolTests.createPrice(19.99)
        var totalPrice: DNSPrice? = DAOOrderProtocolTests.createPrice(39.98)
    }
    
    struct MockOrder: DAOOrderProtocol {
        var id: String = "order_123"
        var meta: any DAOMetadataProtocol = MockMetadata()
        var analyticsData: [any DAOAnalyticsDataProtocol] = []
        
        var userId: String? = "user_456"
        var orderNumber: String? = "ORD-2025-001"
        var items: [any DAOOrderItemProtocol] = [MockOrderItem()]
        var status: DNSOrderState = .pending
        var totalAmount: DNSPrice? = DAOOrderProtocolTests.createPrice(39.98)
        var orderDate: Date? = Date()
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
    
    // MARK: - Business Logic Tests
    
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
    
    // MARK: - Protocol as Type Tests
    
    func testOrderProtocolsAsTypes() throws {
        let order: any DAOOrderProtocol = MockOrder()
        let orderItem: any DAOOrderItemProtocol = MockOrderItem()
        
        XCTAssertEqual(order.id, "order_123")
        XCTAssertEqual(orderItem.id, "order_item_123")
        
        // Test protocol arrays
        let orderObjects: [any DAOBaseObjectProtocol] = [order, orderItem]
        XCTAssertEqual(orderObjects.count, 2)
        
        // Test type filtering
        let orders = orderObjects.compactMap { $0 as? DAOOrderProtocol }
        let orderItems = orderObjects.compactMap { $0 as? DAOOrderItemProtocol }
        
        XCTAssertEqual(orders.count, 1)
        XCTAssertEqual(orderItems.count, 1)
    }
    
    // MARK: - Integration Tests
    
    func testOrderItemIntegration() throws {
        let order = MockOrder()
        var orderItem = MockOrderItem()
        
        // Test order item belongs to order
        orderItem.orderId = order.id
        XCTAssertEqual(orderItem.orderId, order.id)
        
        // Test order contains items
        XCTAssertEqual(order.items.count, 1)
        XCTAssertEqual(order.items[0].orderId, order.id)
    }
    
    // MARK: - Error Handling Tests
    
    func testOrderProtocolValidation() throws {
        var order = MockOrder()
        
        // Test empty order number
        order.orderNumber = nil
        
        XCTAssertNil(order.orderNumber)
        
        // Test required properties remain valid
        XCTAssertNotEqual(order.id, "")
    }
    
    func testProtocolInstanceChecking() throws {
        let order = MockOrder()
        let orderItem = MockOrderItem()
        
        // Test protocol conformance
        XCTAssertTrue(order is DAOOrderProtocol)
        XCTAssertTrue(orderItem is DAOOrderItemProtocol)
        
        // Test base object conformance
        XCTAssertTrue(order is DAOBaseObjectProtocol)
        XCTAssertTrue(orderItem is DAOBaseObjectProtocol)
    }
}
