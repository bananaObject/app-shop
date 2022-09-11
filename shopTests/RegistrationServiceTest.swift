//
//  RegistrationServiceTest.swift
//  shopTests
//
//  Created by Ke4a on 07.09.2022.
//

@testable import shop
import XCTest

class RegistrationServiceTest: XCTestCase {
    typealias Model = ResponseMessageModel

    // MARK: - Properties

    var network: NetworkMock!
    var parser: DecoderResponse<Model>!
    var service: RegistrationService<DecoderResponse<Model>>!

    // MARK: - Initialization

    override func setUp() {
        super.setUp()
        network = .init()
        parser = .init()
        service = .init(network, parser)
    }

    // MARK: - Deinitialization

    override func tearDown() {
        network = nil
        service = nil
        parser = nil
        super.tearDown()
    }

    // MARK: - Methods

    /// Test double fetch.
    /// The first request for data is checked. The second request is getting data and difference from the first one.
    func testFetchDouble() {
        var lastFetch: Model?

        let expectationFirst = expectation(description: "RegistrationTestFirst")

        service.fetchAsync()
        network.completionRequest = {
            expectationFirst.fulfill()
        }

        waitForExpectations(timeout: 1)
        XCTAssertNotNil(service.data)
        lastFetch = service.data

        let expectationSecond = expectation(description: "RegistrationSecondTestSecond")

        service.fetchAsync()
        network.completionRequest = {
            expectationSecond.fulfill()
        }

        waitForExpectations(timeout: 1)
        XCTAssertNotNil(lastFetch)
        XCTAssertNotEqual(lastFetch?.message, service.data?.message)
    }
}
