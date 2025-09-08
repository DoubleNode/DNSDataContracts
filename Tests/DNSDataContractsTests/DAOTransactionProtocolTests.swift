//
//  DAOTransactionProtocolTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts Tests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import XCTest
@testable import DNSDataContracts

final class DAOTransactionProtocolTests: XCTestCase {
    
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
    
    struct MockTransaction: DAOTransactionProtocol {
        var id: String = "transaction_123"
        var meta: any DAOMetadataProtocol = MockMetadata()
        var analyticsData: [any DAOAnalyticsDataProtocol] = []
        
        var userId: String? = "user_456"
        var orderId: String? = "order_123"
        var amount: DNSPrice = DAOTransactionProtocolTests.createPrice(39.98)
        var transactionType: String = "payment"
        var status: DNSStatus = .open
        var transactionDate: Date? = Date()
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
        
        let refundAmount = DAOTransactionProtocolTests.createPrice(-39.98)
        transaction.amount = refundAmount
        XCTAssertEqual(transaction.amount.price, -39.98, accuracy: 0.01)
        
        transaction.status = .closed
        XCTAssertEqual(transaction.status, .closed)
    }
    
    // MARK: - Business Logic Tests
    
    func testTransactionBusinessLogic() throws {
        var transaction = MockTransaction()
        
        // Test payment transaction
        transaction.transactionType = "payment"
        transaction.amount = DAOTransactionProtocolTests.createPrice(39.98)
        XCTAssertEqual(transaction.transactionType, "payment")
        XCTAssertGreaterThan(transaction.amount.price, 0)
        
        // Test refund transaction
        transaction.transactionType = "refund"
        transaction.amount = DAOTransactionProtocolTests.createPrice(-39.98)
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
    
    func testTransactionProtocolAsType() throws {
        let transaction: any DAOTransactionProtocol = MockTransaction()
        
        XCTAssertEqual(transaction.id, "transaction_123")
        
        // Test protocol arrays
        let transactionObjects: [any DAOBaseObjectProtocol] = [transaction]
        XCTAssertEqual(transactionObjects.count, 1)
        
        // Test type filtering
        let transactions = transactionObjects.compactMap { $0 as? DAOTransactionProtocol }
        XCTAssertEqual(transactions.count, 1)
    }
    
    // MARK: - Integration Tests
    
    func testTransactionIntegration() throws {
        let transaction = MockTransaction()
        
        // Test transaction relates to order and user
        XCTAssertEqual(transaction.orderId, "order_123")
        XCTAssertEqual(transaction.userId, "user_456")
        
        // Test transaction amount matches expected order total
        XCTAssertEqual(transaction.amount.price, 39.98, accuracy: 0.01)
        XCTAssertEqual(transaction.transactionType, "payment")
    }
    
    // MARK: - Error Handling Tests
    
    func testTransactionProtocolValidation() throws {
        var transaction = MockTransaction()
        
        // Test empty transaction type
        transaction.transactionType = ""
        
        XCTAssertEqual(transaction.transactionType, "")
        
        // Test required properties remain valid
        XCTAssertNotEqual(transaction.id, "")
    }
    
    func testProtocolInstanceChecking() throws {
        let transaction = MockTransaction()
        
        // Test protocol conformance
        XCTAssertTrue(transaction is DAOTransactionProtocol)
        
        // Test base object conformance
        XCTAssertTrue(transaction is DAOBaseObjectProtocol)
    }
}
