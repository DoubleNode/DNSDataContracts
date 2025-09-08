//
//  DNSDataContractsTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts Tests
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
@testable import DNSDataContracts

final class DNSDataContractsTests: XCTestCase {
    
    func testProtocolsAreAvailable() {
        // Test that all major protocols are accessible
        XCTAssertTrue(DAOBaseObjectProtocol.self is Any.Type)
        XCTAssertTrue(DAOUserProtocol.self is Any.Type)
        XCTAssertTrue(DAOAccountProtocol.self is Any.Type)
        XCTAssertTrue(DAOPlaceProtocol.self is Any.Type)
        XCTAssertTrue(DAOProductProtocol.self is Any.Type)
        XCTAssertTrue(DAOEventProtocol.self is Any.Type)
        XCTAssertTrue(DAOSystemProtocol.self is Any.Type)
    }
    
    func testSharedTypesAreAvailable() {
        // Test that shared types are accessible
        XCTAssertEqual(DNSUserType.admin.rawValue, "admin")
        XCTAssertEqual(DNSStatus.active.rawValue, "active")
        XCTAssertEqual(DNSVisibility.public.rawValue, "public")
        XCTAssertEqual(DNSOrderState.pending.rawValue, "pending")
        XCTAssertEqual(DNSMediaType.image.rawValue, "image")
        XCTAssertEqual(DNSSystemState.online.rawValue, "online")
    }
    
    func testDayOfWeekFlags() {
        // Test DNSDayOfWeekFlags functionality
        let weekdays = DNSDayOfWeekFlags.weekdays
        XCTAssertTrue(weekdays.contains(.monday))
        XCTAssertTrue(weekdays.contains(.friday))
        XCTAssertFalse(weekdays.contains(.saturday))
        
        let weekend = DNSDayOfWeekFlags.weekend
        XCTAssertTrue(weekend.contains(.saturday))
        XCTAssertTrue(weekend.contains(.sunday))
        XCTAssertFalse(weekend.contains(.monday))
    }
    
    func testDNSPrice() {
        // Test DNSPrice structure
        let price = DNSPrice(amount: 19.99, currency: "USD", displayString: "$19.99")
        XCTAssertEqual(price.amount, 19.99)
        XCTAssertEqual(price.currency, "USD")
        XCTAssertEqual(price.displayString, "$19.99")
    }
    
    func testUserReaction() {
        // Test DNSUserReaction structure
        let reaction = DNSUserReaction(userId: "user123", reactionType: .like)
        XCTAssertEqual(reaction.userId, "user123")
        XCTAssertEqual(reaction.reactionType, .like)
        XCTAssertTrue(reaction.timestamp <= Date())
    }
}