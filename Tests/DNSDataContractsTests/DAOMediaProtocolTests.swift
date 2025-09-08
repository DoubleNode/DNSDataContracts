//
//  DAOMediaProtocolTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts Tests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import XCTest
@testable import DNSDataContracts

final class DAOMediaProtocolTests: XCTestCase {
    
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
    
    struct MockMedia: DAOMediaProtocol {
        var id: String = "media_123"
        var meta: any DAOMetadataProtocol = MockMetadata()
        var analyticsData: [any DAOAnalyticsDataProtocol] = []
        
        var name: String = "Test Media"
        var mediaDescription: String? = "A test media file"
        var mediaType: DNSMediaType = .staticImage
        var url: String? = "https://example.com/media/test.jpg"
        var thumbnailUrl: String? = "https://example.com/media/test_thumb.jpg"
        var size: Int64 = 1024000 // 1MB
        var status: DNSStatus = .open
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
        XCTAssertEqual(media.mediaType, .staticImage)
        XCTAssertEqual(media.url, "https://example.com/media/test.jpg")
        XCTAssertEqual(media.thumbnailUrl, "https://example.com/media/test_thumb.jpg")
        XCTAssertEqual(media.size, 1024000)
        XCTAssertEqual(media.status, .open)
    }
    
    func testMediaTypesValues() throws {
        var media = MockMedia()
        
        let mediaTypes: [DNSMediaType] = [.unknown, .animatedImage, .pdfDocument, .staticImage, .text, .video]

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
    
    // MARK: - Protocol as Type Tests
    
    func testMediaProtocolAsType() throws {
        let media: any DAOMediaProtocol = MockMedia()
        
        XCTAssertEqual(media.id, "media_123")
        
        // Test protocol arrays
        let mediaObjects: [any DAOBaseObjectProtocol] = [media]
        XCTAssertEqual(mediaObjects.count, 1)
    }
    
    // MARK: - Integration Tests
    
    func testMediaWorkflow() throws {
        let media = MockMedia()
        
        // Test media type and URL validation
        XCTAssertEqual(media.mediaType, .staticImage)
        XCTAssertNotNil(media.url)
        XCTAssertNotNil(media.thumbnailUrl)
        
        // Test media file properties
        XCTAssertGreaterThan(media.size, 0)
    }
    
    // MARK: - Error Handling Tests
    
    func testMediaProtocolValidation() throws {
        var media = MockMedia()
        
        // Test empty names and required fields
        media.name = ""
        
        XCTAssertEqual(media.name, "")
        
        // Test required properties remain valid
        XCTAssertNotEqual(media.id, "")
    }
    
    func testProtocolInstanceChecking() throws {
        let media = MockMedia()
        
        // Test protocol conformance
        XCTAssertTrue(media is DAOMediaProtocol)
        
        // Test base object conformance
        XCTAssertTrue(media is DAOBaseObjectProtocol)
    }
}
