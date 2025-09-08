//
//  DAOSystemEndPointProtocolTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts Tests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import XCTest
@testable import DNSDataContracts

final class DAOSystemEndPointProtocolTests: XCTestCase {
    
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
    
    struct MockSystemEndPoint: DAOSystemEndPointProtocol {
        var id: String = "endpoint_123"
        var meta: any DAOMetadataProtocol = MockMetadata()
        var analyticsData: [any DAOAnalyticsDataProtocol] = []
        
        var systemId: String = "system_123"
        var name: String = "API Endpoint"
        var url: String = "https://api.example.com/v1"
        var endpointType: String = "REST"
        var status: DNSStatus = .open
        var currentState: DNSSystemState? = .green
    }
    
    // MARK: - DAOSystemEndPointProtocol Tests
    
    func testSystemEndPointProtocolInheritance() throws {
        let endpoint = MockSystemEndPoint()
        
        XCTAssertTrue(endpoint is DAOBaseObjectProtocol)
        XCTAssertTrue(endpoint is DAOSystemEndPointProtocol)
        
        XCTAssertEqual(endpoint.id, "endpoint_123")
        XCTAssertNotNil(endpoint.meta)
    }
    
    func testSystemEndPointProperties() throws {
        let endpoint = MockSystemEndPoint()
        
        XCTAssertEqual(endpoint.systemId, "system_123")
        XCTAssertEqual(endpoint.name, "API Endpoint")
        XCTAssertEqual(endpoint.url, "https://api.example.com/v1")
        XCTAssertEqual(endpoint.endpointType, "REST")
        XCTAssertEqual(endpoint.status, .open)
        XCTAssertEqual(endpoint.currentState, .green)
    }
    
    func testSystemEndPointMutability() throws {
        var endpoint = MockSystemEndPoint()
        
        endpoint.systemId = "system_456"
        XCTAssertEqual(endpoint.systemId, "system_456")
        
        endpoint.name = "GraphQL Endpoint"
        XCTAssertEqual(endpoint.name, "GraphQL Endpoint")
        
        endpoint.url = "https://api.example.com/graphql"
        XCTAssertEqual(endpoint.url, "https://api.example.com/graphql")
        
        endpoint.endpointType = "GraphQL"
        XCTAssertEqual(endpoint.endpointType, "GraphQL")
        
        endpoint.status = .closed
        XCTAssertEqual(endpoint.status, .closed)
        
        endpoint.currentState = .red
        XCTAssertEqual(endpoint.currentState, .red)
    }
    
    // MARK: - Business Logic Tests
    
    func testEndpointMonitoring() throws {
        var endpoint = MockSystemEndPoint()
        
        // Test endpoint types
        let endpointTypes = ["REST", "GraphQL", "WebSocket", "gRPC", "SOAP"]
        
        for endpointType in endpointTypes {
            endpoint.endpointType = endpointType
            XCTAssertEqual(endpoint.endpointType, endpointType)
        }
        
        // Test endpoint states
        endpoint.currentState = .green
        XCTAssertEqual(endpoint.currentState, .green)
        
        endpoint.currentState = .orange
        XCTAssertEqual(endpoint.currentState, .orange)
        
        endpoint.currentState = nil
        XCTAssertNil(endpoint.currentState)
    }
    
    // MARK: - Protocol as Type Tests
    
    func testSystemEndPointProtocolAsType() throws {
        let endpoints: [any DAOSystemEndPointProtocol] = [
            MockSystemEndPoint()
        ]
        
        XCTAssertEqual(endpoints.count, 1)
        
        if let firstEndpoint = endpoints.first {
            XCTAssertEqual(firstEndpoint.id, "endpoint_123")
            XCTAssertEqual(firstEndpoint.systemId, "system_123")
            XCTAssertEqual(firstEndpoint.name, "API Endpoint")
        } else {
            XCTFail("Should have first endpoint")
        }
    }
    
    // MARK: - Error Handling Tests
    
    func testSystemEndPointProtocolValidation() throws {
        var endpoint = MockSystemEndPoint()
        
        // Test empty names and URLs
        endpoint.name = ""
        endpoint.url = ""
        endpoint.endpointType = ""
        
        XCTAssertEqual(endpoint.name, "")
        XCTAssertEqual(endpoint.url, "")
        XCTAssertEqual(endpoint.endpointType, "")
        
        // Test required properties remain valid
        XCTAssertNotEqual(endpoint.id, "")
        XCTAssertNotEqual(endpoint.systemId, "")
    }
    
    func testProtocolInstanceChecking() throws {
        let endpoint = MockSystemEndPoint()
        
        // Test protocol conformance
        XCTAssertTrue(endpoint is DAOSystemEndPointProtocol)
        
        // Test base object conformance
        XCTAssertTrue(endpoint is DAOBaseObjectProtocol)
        
        // Test type checking with casting
        XCTAssertNotNil(endpoint as? DAOSystemEndPointProtocol)
        XCTAssertNotNil(endpoint as? DAOBaseObjectProtocol)
    }
}
