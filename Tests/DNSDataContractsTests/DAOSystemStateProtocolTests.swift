//
//  DAOSystemStateProtocolTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts Tests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import XCTest
@testable import DNSDataContracts

final class DAOSystemStateProtocolTests: XCTestCase {
    
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
    
    struct MockSystemState: DAOSystemStateProtocol {
        var id: String = "system_state_123"
        var meta: any DAOMetadataProtocol = MockMetadata()
        var analyticsData: [any DAOAnalyticsDataProtocol] = []
        
        var referenceId: String = "system_123"
        var name: String = "health_check"
        var value: String? = "healthy"
        var timestamp: Date = Date()
        var status: DNSStatus = .open
    }
    
    // MARK: - DAOSystemStateProtocol Tests
    
    func testSystemStateProtocolInheritance() throws {
        let systemState = MockSystemState()
        
        XCTAssertTrue(systemState is DAOBaseObjectProtocol)
        XCTAssertTrue(systemState is DAOSystemStateProtocol)
        
        XCTAssertEqual(systemState.id, "system_state_123")
        XCTAssertNotNil(systemState.meta)
    }
    
    func testSystemStateProtocolProperties() throws {
        let systemState = MockSystemState()
        
        XCTAssertEqual(systemState.referenceId, "system_123")
        XCTAssertEqual(systemState.name, "health_check")
        XCTAssertEqual(systemState.value, "healthy")
        XCTAssertNotNil(systemState.timestamp)
        XCTAssertEqual(systemState.status, .open)
    }
    
    func testSystemStateMutability() throws {
        var systemState = MockSystemState()
        
        systemState.referenceId = "system_456"
        XCTAssertEqual(systemState.referenceId, "system_456")
        
        systemState.name = "cpu_usage"
        XCTAssertEqual(systemState.name, "cpu_usage")
        
        systemState.value = "85"
        XCTAssertEqual(systemState.value, "85")
        
        let newTimestamp = Date().addingTimeInterval(3600)
        systemState.timestamp = newTimestamp
        XCTAssertEqual(systemState.timestamp, newTimestamp)
        
        systemState.status = .closed
        XCTAssertEqual(systemState.status, .closed)
        
        systemState.value = nil
        XCTAssertNil(systemState.value)
    }
    
    // MARK: - Business Logic Tests
    
    func testSystemStateValues() throws {
        var systemState = MockSystemState()
        
        let systemStates: [DNSSystemState] = [.green, .red, .orange, .yellow]
        
        // Test that we can set state values as strings corresponding to enum cases
        for state in systemStates {
            systemState.value = state.rawValue
            XCTAssertEqual(systemState.value, state.rawValue)
            XCTAssertNotNil(state)
        }
    }
    
    func testSystemStateMonitoring() throws {
        var systemState = MockSystemState()
        
        // Test system health states
        systemState.name = "cpu_usage"
        systemState.value = "75"
        
        XCTAssertEqual(systemState.name, "cpu_usage")
        XCTAssertEqual(systemState.value, "75")
        
        // Test degraded performance
        systemState.value = "95"
        XCTAssertEqual(systemState.value, "95")
        
        // Test system offline
        systemState.value = nil
        XCTAssertNil(systemState.value)
    }
    
    // MARK: - Protocol as Type Tests
    
    func testSystemStateProtocolAsType() throws {
        let systemStates: [any DAOSystemStateProtocol] = [
            MockSystemState()
        ]
        
        XCTAssertEqual(systemStates.count, 1)
        
        if let firstState = systemStates.first {
            XCTAssertEqual(firstState.id, "system_state_123")
            XCTAssertEqual(firstState.referenceId, "system_123")
            XCTAssertEqual(firstState.name, "health_check")
        } else {
            XCTFail("Should have first system state")
        }
    }
    
    // MARK: - Error Handling Tests
    
    func testSystemStateProtocolValidation() throws {
        var systemState = MockSystemState()
        
        // Test empty name and reference ID
        systemState.name = ""
        systemState.referenceId = ""
        
        XCTAssertEqual(systemState.name, "")
        XCTAssertEqual(systemState.referenceId, "")
        
        // Test required properties remain valid
        XCTAssertNotEqual(systemState.id, "")
        XCTAssertNotNil(systemState.timestamp)
        XCTAssertNotNil(systemState.status)
    }
    
    func testProtocolInstanceChecking() throws {
        let systemState = MockSystemState()
        
        // Test protocol conformance
        XCTAssertTrue(systemState is DAOSystemStateProtocol)
        
        // Test base object conformance
        XCTAssertTrue(systemState is DAOBaseObjectProtocol)
        
        // Test type checking with casting
        XCTAssertNotNil(systemState as? DAOSystemStateProtocol)
        XCTAssertNotNil(systemState as? DAOBaseObjectProtocol)
    }
}
