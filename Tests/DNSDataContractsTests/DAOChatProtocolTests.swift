//
//  DAOChatProtocolTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts Tests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import XCTest
@testable import DNSDataContracts

final class DAOChatProtocolTests: XCTestCase {
    
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
    
    struct MockChatMessage: DAOChatMessageProtocol {
        var id: String = "chat_message_123"
        var meta: any DAOMetadataProtocol = MockMetadata()
        var analyticsData: [any DAOAnalyticsDataProtocol] = []
        
        var chatId: String = "chat_123"
        var senderId: String = "user_456"
        var content: String = "Hello, this is a test message!"
        var timestamp: Date = Date()
        var status: DNSStatus = .open
    }
    
    struct MockChat: DAOChatProtocol {
        var id: String = "chat_123"
        var meta: any DAOMetadataProtocol = MockMetadata()
        var analyticsData: [any DAOAnalyticsDataProtocol] = []
        
        var name: String? = "Test Chat Room"
        var participants: [String] = ["user_456", "user_789"]
        var messages: [any DAOChatMessageProtocol] = [MockChatMessage()]
        var lastMessageTime: Date? = Date()
        var status: DNSStatus = .open
    }
    
    // MARK: - Chat Protocol Tests
    
    func testDAOChatProtocolInheritance() throws {
        let chat = MockChat()
        
        XCTAssertTrue(chat is DAOBaseObjectProtocol)
        XCTAssertTrue(chat is DAOChatProtocol)
        
        XCTAssertEqual(chat.id, "chat_123")
        XCTAssertNotNil(chat.meta)
    }
    
    func testChatProtocolProperties() throws {
        let chat = MockChat()
        
        XCTAssertEqual(chat.name, "Test Chat Room")
        XCTAssertEqual(chat.participants.count, 2)
        XCTAssertEqual(chat.participants[0], "user_456")
        XCTAssertEqual(chat.participants[1], "user_789")
        XCTAssertEqual(chat.messages.count, 1)
        XCTAssertNotNil(chat.lastMessageTime)
        XCTAssertEqual(chat.status, .open)
    }
    
    func testChatMessageProtocolProperties() throws {
        let chatMessage = MockChatMessage()
        
        XCTAssertEqual(chatMessage.chatId, "chat_123")
        XCTAssertEqual(chatMessage.senderId, "user_456")
        XCTAssertEqual(chatMessage.content, "Hello, this is a test message!")
        XCTAssertNotNil(chatMessage.timestamp)
        XCTAssertEqual(chatMessage.status, .open)
    }
    
    func testChatMessageMutability() throws {
        var chatMessage = MockChatMessage()
        
        chatMessage.content = "Updated message content"
        XCTAssertEqual(chatMessage.content, "Updated message content")
        
        let newTimestamp = Date().addingTimeInterval(-3600) // 1 hour ago
        chatMessage.timestamp = newTimestamp
        XCTAssertEqual(chatMessage.timestamp, newTimestamp)
        
        chatMessage.status = .closed
        XCTAssertEqual(chatMessage.status, .closed)
    }
    
    // MARK: - Business Logic Tests
    
    func testChatMessageOrdering() throws {
        var chat = MockChat()
        var message1 = MockChatMessage()
        var message2 = MockChatMessage()
        
        message1.id = "message_1"
        message1.timestamp = Date().addingTimeInterval(-3600) // 1 hour ago
        
        message2.id = "message_2"
        message2.timestamp = Date() // now
        
        chat.messages = [message1, message2]
        
        // Test that messages can be ordered by timestamp
        let sortedMessages = chat.messages.sorted { $0.timestamp < $1.timestamp }
        XCTAssertEqual(sortedMessages[0].id, "message_1")
        XCTAssertEqual(sortedMessages[1].id, "message_2")
        
        // Test last message time
        chat.lastMessageTime = message2.timestamp
        XCTAssertEqual(chat.lastMessageTime, message2.timestamp)
    }
    
    // MARK: - Protocol as Type Tests
    
    func testChatProtocolsAsTypes() throws {
        let chat: any DAOChatProtocol = MockChat()
        let chatMessage: any DAOChatMessageProtocol = MockChatMessage()
        
        XCTAssertEqual(chat.id, "chat_123")
        XCTAssertEqual(chatMessage.id, "chat_message_123")
        
        // Test protocol arrays
        let chatObjects: [any DAOBaseObjectProtocol] = [chat, chatMessage]
        XCTAssertEqual(chatObjects.count, 2)
    }
    
    // MARK: - Integration Tests
    
    func testChatIntegration() throws {
        let chat = MockChat()
        let chatMessage = MockChatMessage()
        
        // Test message belongs to chat
        XCTAssertEqual(chatMessage.chatId, chat.id)
        
        // Test chat contains messages
        XCTAssertEqual(chat.messages.count, 1)
        XCTAssertEqual(chat.messages[0].chatId, chat.id)
    }
    
    // MARK: - Error Handling Tests
    
    func testChatProtocolValidation() throws {
        var chat = MockChat()
        
        // Test empty names and required fields
        chat.name = nil
        
        XCTAssertNil(chat.name)
        
        // Test required properties remain valid
        XCTAssertNotEqual(chat.id, "")
    }
    
    func testProtocolInstanceChecking() throws {
        let chat = MockChat()
        let chatMessage = MockChatMessage()
        
        // Test protocol conformance
        XCTAssertTrue(chat is DAOChatProtocol)
        XCTAssertTrue(chatMessage is DAOChatMessageProtocol)
        
        // Test base object conformance
        XCTAssertTrue(chat is DAOBaseObjectProtocol)
        XCTAssertTrue(chatMessage is DAOBaseObjectProtocol)
    }
}
