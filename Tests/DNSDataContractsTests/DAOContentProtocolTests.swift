//
//  DAOContentProtocolTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts Tests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
@testable import DNSDataContracts

final class DAOContentProtocolTests: XCTestCase {
    
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
    
    struct MockSection: DAOSectionProtocol {
        var id: String = "section_123"
        var meta: any DAOMetadataProtocol = MockMetadata()
        var analyticsData: [any DAOAnalyticsDataProtocol] = []
        
        var name: String = "Test Section"
        var sectionDescription: String? = "A test section for unit tests"
        var parentId: String? = nil
        var children: [any DAOSectionProtocol] = []
        var status: DNSStatus = .open
        var visibility: DNSVisibility = .everyone
    }
    
    struct MockMedia: DAOMediaProtocol {
        var id: String = "media_123"
        var meta: any DAOMetadataProtocol = MockMetadata()
        var analyticsData: [any DAOAnalyticsDataProtocol] = []
        
        var name: String = "Test Media"
        var mediaDescription: String? = "A test media file"
        var mediaType: DNSMediaType = .image
        var url: String? = "https://example.com/media/test.jpg"
        var thumbnailUrl: String? = "https://example.com/media/test_thumb.jpg"
        var size: Int64 = 1024000 // 1MB
        var status: DNSStatus = .open
    }
    
    struct MockEvent: DAOEventProtocol {
        var id: String = "event_123"
        var meta: any DAOMetadataProtocol = MockMetadata()
        var analyticsData: [any DAOAnalyticsDataProtocol] = []
        
        var name: String = "Test Event"
        var eventDescription: String? = "A test event for unit tests"
        var startTime: Date? = Date()
        var endTime: Date? = Date().addingTimeInterval(3600) // 1 hour later
        var placeId: String? = "place_456"
        var status: DNSStatus = .open
        var visibility: DNSVisibility = .everyone
    }
    
    struct MockEventDayItem: DAOEventDayItemProtocol {
        var id: String = "event_day_item_123"
        var meta: any DAOMetadataProtocol = MockMetadata()
        var analyticsData: [any DAOAnalyticsDataProtocol] = []
        
        var eventDayId: String = "event_day_123"
        var name: String = "Morning Session"
        var itemDescription: String? = "Morning session description"
        var startTime: Date? = Date()
        var endTime: Date? = Date().addingTimeInterval(1800) // 30 minutes
        var status: DNSStatus = .open
    }
    
    struct MockEventDay: DAOEventDayProtocol {
        var id: String = "event_day_123"
        var meta: any DAOMetadataProtocol = MockMetadata()
        var analyticsData: [any DAOAnalyticsDataProtocol] = []
        
        var eventId: String = "event_123"
        var date: Date = Calendar.current.startOfDay(for: Date())
        var startTime: Date? = Date()
        var endTime: Date? = Date().addingTimeInterval(28800) // 8 hours
        var items: [any DAOEventDayItemProtocol] = [MockEventDayItem()]
        var status: DNSStatus = .open
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
    
    struct MockAnnouncement: DAOAnnouncementProtocol {
        var id: String = "announcement_123"
        var meta: any DAOMetadataProtocol = MockMetadata()
        var analyticsData: [any DAOAnalyticsDataProtocol] = []
        
        var title: String = "Test Announcement"
        var content: String = "This is a test announcement content."
        var authorId: String? = "user_admin"
        var publishDate: Date? = Date()
        var expiryDate: Date? = Date().addingTimeInterval(2592000) // 30 days
        var status: DNSStatus = .open
        var visibility: DNSVisibility = .everyone
    }
    
    struct MockAlert: DAOAlertProtocol {
        var id: String = "alert_123"
        var meta: any DAOMetadataProtocol = MockMetadata()
        var analyticsData: [any DAOAnalyticsDataProtocol] = []
        
        var title: String = "Test Alert"
        var message: String = "This is a test alert message."
        var alertType: String = "info"
        var userId: String? = "user_456"
        var isRead: Bool = false
        var timestamp: Date = Date()
        var status: DNSStatus = .open
    }
    
    // MARK: - Section Protocol Tests
    
    func testDAOSectionProtocolInheritance() throws {
        let section = MockSection()
        
        XCTAssertTrue(section is DAOBaseObjectProtocol)
        XCTAssertTrue(section is DAOSectionProtocol)
        
        XCTAssertEqual(section.id, "section_123")
        XCTAssertNotNil(section.meta)
        XCTAssertTrue(section.analyticsData.isEmpty)
    }
    
    func testSectionProtocolProperties() throws {
        let section = MockSection()
        
        XCTAssertEqual(section.name, "Test Section")
        XCTAssertEqual(section.sectionDescription, "A test section for unit tests")
        XCTAssertNil(section.parentId)
        XCTAssertTrue(section.children.isEmpty)
        XCTAssertEqual(section.status, .open)
        XCTAssertEqual(section.visibility, .everyone)
    }
    
    func testSectionHierarchy() throws {
        var parentSection = MockSection()
        var childSection = MockSection()
        
        childSection.id = "section_child_123"
        childSection.name = "Child Section"
        childSection.parentId = parentSection.id
        
        parentSection.children = [childSection]
        
        XCTAssertEqual(parentSection.children.count, 1)
        XCTAssertEqual(parentSection.children[0].id, "section_child_123")
        XCTAssertEqual(childSection.parentId, parentSection.id)
    }
    
    // MARK: - Media Protocol Tests
    
    func testDAOMediaProtocolInheritance() throws {
        let media = MockMedia()
        
        XCTAssertTrue(media is DAOBaseObjectProtocol)
        XCTAssertTrue(media is DAOMediaProtocol)
        
        XCTAssertEqual(media.id, "media_123")
        XCTAssertNotNil(media.meta)
    }
    
    func testMediaProtocolProperties() throws {
        let media = MockMedia()
        
        XCTAssertEqual(media.name, "Test Media")
        XCTAssertEqual(media.mediaDescription, "A test media file")
        XCTAssertEqual(media.mediaType, .image)
        XCTAssertEqual(media.url, "https://example.com/media/test.jpg")
        XCTAssertEqual(media.thumbnailUrl, "https://example.com/media/test_thumb.jpg")
        XCTAssertEqual(media.size, 1024000)
        XCTAssertEqual(media.status, .open)
    }
    
    func testMediaTypesValues() throws {
        var media = MockMedia()
        
        let mediaTypes: [DNSMediaType] = [.image, .video, .audio, .document, .other]
        
        for mediaType in mediaTypes {
            media.mediaType = mediaType
            XCTAssertEqual(media.mediaType, mediaType)
        }
    }
    
    func testMediaSizeHandling() throws {
        var media = MockMedia()
        
        // Test various file sizes
        let sizes: [Int64] = [1024, 1048576, 10485760, 104857600] // 1KB, 1MB, 10MB, 100MB
        
        for size in sizes {
            media.size = size
            XCTAssertEqual(media.size, size)
        }
        
        // Test zero size
        media.size = 0
        XCTAssertEqual(media.size, 0)
    }
    
    // MARK: - Event Protocol Tests
    
    func testDAOEventProtocolInheritance() throws {
        let event = MockEvent()
        
        XCTAssertTrue(event is DAOBaseObjectProtocol)
        XCTAssertTrue(event is DAOEventProtocol)
        
        XCTAssertEqual(event.id, "event_123")
        XCTAssertNotNil(event.meta)
    }
    
    func testEventProtocolProperties() throws {
        let event = MockEvent()
        
        XCTAssertEqual(event.name, "Test Event")
        XCTAssertEqual(event.eventDescription, "A test event for unit tests")
        XCTAssertNotNil(event.startTime)
        XCTAssertNotNil(event.endTime)
        XCTAssertEqual(event.placeId, "place_456")
        XCTAssertEqual(event.status, .open)
        XCTAssertEqual(event.visibility, .everyone)
        
        // Test that end time is after start time
        if let startTime = event.startTime,
           let endTime = event.endTime {
            XCTAssertLessThan(startTime, endTime)
        }
    }
    
    func testEventDayProtocolProperties() throws {
        let eventDay = MockEventDay()
        
        XCTAssertEqual(eventDay.eventId, "event_123")
        XCTAssertNotNil(eventDay.date)
        XCTAssertNotNil(eventDay.startTime)
        XCTAssertNotNil(eventDay.endTime)
        XCTAssertEqual(eventDay.items.count, 1)
        XCTAssertEqual(eventDay.status, .open)
        
        // Test that the date is start of day
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.hour, .minute, .second], from: eventDay.date)
        XCTAssertEqual(dateComponents.hour, 0)
        XCTAssertEqual(dateComponents.minute, 0)
        XCTAssertEqual(dateComponents.second, 0)
    }
    
    func testEventDayItemProtocolProperties() throws {
        let eventDayItem = MockEventDayItem()
        
        XCTAssertEqual(eventDayItem.eventDayId, "event_day_123")
        XCTAssertEqual(eventDayItem.name, "Morning Session")
        XCTAssertEqual(eventDayItem.itemDescription, "Morning session description")
        XCTAssertNotNil(eventDayItem.startTime)
        XCTAssertNotNil(eventDayItem.endTime)
        XCTAssertEqual(eventDayItem.status, .open)
        
        // Test that end time is after start time
        if let startTime = eventDayItem.startTime,
           let endTime = eventDayItem.endTime {
            XCTAssertLessThan(startTime, endTime)
        }
    }
    
    // MARK: - Communication Protocol Tests
    
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
    
    // MARK: - Announcement Protocol Tests
    
    func testDAOAnnouncementProtocolInheritance() throws {
        let announcement = MockAnnouncement()
        
        XCTAssertTrue(announcement is DAOBaseObjectProtocol)
        XCTAssertTrue(announcement is DAOAnnouncementProtocol)
        
        XCTAssertEqual(announcement.id, "announcement_123")
        XCTAssertNotNil(announcement.meta)
    }
    
    func testAnnouncementProtocolProperties() throws {
        let announcement = MockAnnouncement()
        
        XCTAssertEqual(announcement.title, "Test Announcement")
        XCTAssertEqual(announcement.content, "This is a test announcement content.")
        XCTAssertEqual(announcement.authorId, "user_admin")
        XCTAssertNotNil(announcement.publishDate)
        XCTAssertNotNil(announcement.expiryDate)
        XCTAssertEqual(announcement.status, .open)
        XCTAssertEqual(announcement.visibility, .everyone)
        
        // Test that expiry date is after publish date
        if let publishDate = announcement.publishDate,
           let expiryDate = announcement.expiryDate {
            XCTAssertLessThan(publishDate, expiryDate)
        }
    }
    
    func testAnnouncementDateLogic() throws {
        var announcement = MockAnnouncement()
        
        let now = Date()
        let publishDate = now.addingTimeInterval(-86400) // 1 day ago
        let expiryDate = now.addingTimeInterval(86400)   // 1 day from now
        
        announcement.publishDate = publishDate
        announcement.expiryDate = expiryDate
        
        // Test announcement is currently active
        XCTAssertLessThan(publishDate, now)
        XCTAssertGreaterThan(expiryDate, now)
        
        // Test expired announcement
        let expiredDate = now.addingTimeInterval(-3600) // 1 hour ago
        announcement.expiryDate = expiredDate
        XCTAssertLessThan(announcement.expiryDate!, now)
    }
    
    // MARK: - Alert Protocol Tests
    
    func testDAOAlertProtocolInheritance() throws {
        let alert = MockAlert()
        
        XCTAssertTrue(alert is DAOBaseObjectProtocol)
        XCTAssertTrue(alert is DAOAlertProtocol)
        
        XCTAssertEqual(alert.id, "alert_123")
        XCTAssertNotNil(alert.meta)
    }
    
    func testAlertProtocolProperties() throws {
        let alert = MockAlert()
        
        XCTAssertEqual(alert.title, "Test Alert")
        XCTAssertEqual(alert.message, "This is a test alert message.")
        XCTAssertEqual(alert.alertType, "info")
        XCTAssertEqual(alert.userId, "user_456")
        XCTAssertFalse(alert.isRead)
        XCTAssertNotNil(alert.timestamp)
        XCTAssertEqual(alert.status, .open)
    }
    
    func testAlertTypeValues() throws {
        var alert = MockAlert()
        
        let alertTypes = ["info", "warning", "error", "success", "notification"]
        
        for alertType in alertTypes {
            alert.alertType = alertType
            XCTAssertEqual(alert.alertType, alertType)
        }
    }
    
    func testAlertReadStatus() throws {
        var alert = MockAlert()
        
        // Test unread alert
        alert.isRead = false
        XCTAssertFalse(alert.isRead)
        
        // Test marking as read
        alert.isRead = true
        XCTAssertTrue(alert.isRead)
    }
    
    // MARK: - Business Logic Tests
    
    func testContentHierarchy() throws {
        var parentSection = MockSection()
        var childSection1 = MockSection()
        var childSection2 = MockSection()
        
        childSection1.id = "child_1"
        childSection1.name = "Child Section 1"
        childSection1.parentId = parentSection.id
        
        childSection2.id = "child_2"
        childSection2.name = "Child Section 2"
        childSection2.parentId = parentSection.id
        
        parentSection.children = [childSection1, childSection2]
        
        XCTAssertEqual(parentSection.children.count, 2)
        XCTAssertEqual(parentSection.children[0].parentId, parentSection.id)
        XCTAssertEqual(parentSection.children[1].parentId, parentSection.id)
    }
    
    func testEventScheduling() throws {
        var event = MockEvent()
        let eventDay = MockEventDay()
        let eventDayItem = MockEventDayItem()
        
        // Test event day belongs to event
        XCTAssertEqual(eventDay.eventId, event.id)
        
        // Test event day item belongs to event day
        XCTAssertEqual(eventDayItem.eventDayId, eventDay.id)
        
        // Test scheduling logic
        let startDate = Calendar.current.startOfDay(for: Date())
        event.startTime = startDate
        event.endTime = startDate.addingTimeInterval(86400) // 1 day later
        
        if let startTime = event.startTime,
           let endTime = event.endTime {
            let duration = endTime.timeIntervalSince(startTime)
            XCTAssertEqual(duration, 86400, accuracy: 1) // 1 day = 86400 seconds
        }
    }
    
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
    
    func testContentProtocolsAsTypes() throws {
        let section: any DAOSectionProtocol = MockSection()
        let media: any DAOMediaProtocol = MockMedia()
        let event: any DAOEventProtocol = MockEvent()
        let chat: any DAOChatProtocol = MockChat()
        let announcement: any DAOAnnouncementProtocol = MockAnnouncement()
        let alert: any DAOAlertProtocol = MockAlert()
        
        XCTAssertEqual(section.id, "section_123")
        XCTAssertEqual(media.id, "media_123")
        XCTAssertEqual(event.id, "event_123")
        XCTAssertEqual(chat.id, "chat_123")
        XCTAssertEqual(announcement.id, "announcement_123")
        XCTAssertEqual(alert.id, "alert_123")
        
        // Test protocol arrays
        let contentObjects: [any DAOBaseObjectProtocol] = [
            section, media, event, chat, announcement, alert
        ]
        XCTAssertEqual(contentObjects.count, 6)
    }
    
    // MARK: - Integration Tests
    
    func testContentWorkflow() throws {
        let section = MockSection()
        let media = MockMedia()
        let event = MockEvent()
        let eventDay = MockEventDay()
        let announcement = MockAnnouncement()
        
        // Test content organization within section
        var sectionWithMedia = section
        sectionWithMedia.name = "Media Section"
        
        // In a real implementation, section might contain media references
        XCTAssertEqual(sectionWithMedia.name, "Media Section")
        XCTAssertEqual(media.mediaType, .image)
        
        // Test event with place relationship
        XCTAssertEqual(event.placeId, "place_456")
        XCTAssertEqual(eventDay.eventId, event.id)
        
        // Test announcement publication
        if let publishDate = announcement.publishDate {
            XCTAssertLessThanOrEqual(publishDate, Date())
        }
    }
    
    // MARK: - Error Handling Tests
    
    func testContentProtocolValidation() throws {
        var section = MockSection()
        var media = MockMedia()
        var event = MockEvent()
        var alert = MockAlert()
        
        // Test empty names and required fields
        section.name = ""
        media.name = ""
        event.name = ""
        alert.title = ""
        alert.message = ""
        
        XCTAssertEqual(section.name, "")
        XCTAssertEqual(media.name, "")
        XCTAssertEqual(event.name, "")
        XCTAssertEqual(alert.title, "")
        XCTAssertEqual(alert.message, "")
        
        // Test required properties remain valid
        XCTAssertNotEqual(section.id, "")
        XCTAssertNotEqual(media.id, "")
        XCTAssertNotEqual(event.id, "")
        XCTAssertNotEqual(alert.id, "")
    }
    
    func testProtocolInstanceChecking() throws {
        let section = MockSection()
        let media = MockMedia()
        let event = MockEvent()
        let eventDay = MockEventDay()
        let eventDayItem = MockEventDayItem()
        let chat = MockChat()
        let chatMessage = MockChatMessage()
        let announcement = MockAnnouncement()
        let alert = MockAlert()
        
        // Test protocol conformance
        XCTAssertTrue(section is DAOSectionProtocol)
        XCTAssertTrue(media is DAOMediaProtocol)
        XCTAssertTrue(event is DAOEventProtocol)
        XCTAssertTrue(eventDay is DAOEventDayProtocol)
        XCTAssertTrue(eventDayItem is DAOEventDayItemProtocol)
        XCTAssertTrue(chat is DAOChatProtocol)
        XCTAssertTrue(chatMessage is DAOChatMessageProtocol)
        XCTAssertTrue(announcement is DAOAnnouncementProtocol)
        XCTAssertTrue(alert is DAOAlertProtocol)
        
        // Test base object conformance
        XCTAssertTrue(section is DAOBaseObjectProtocol)
        XCTAssertTrue(media is DAOBaseObjectProtocol)
        XCTAssertTrue(event is DAOBaseObjectProtocol)
        XCTAssertTrue(eventDay is DAOBaseObjectProtocol)
        XCTAssertTrue(eventDayItem is DAOBaseObjectProtocol)
        XCTAssertTrue(chat is DAOBaseObjectProtocol)
        XCTAssertTrue(chatMessage is DAOBaseObjectProtocol)
        XCTAssertTrue(announcement is DAOBaseObjectProtocol)
        XCTAssertTrue(alert is DAOBaseObjectProtocol)
    }
}