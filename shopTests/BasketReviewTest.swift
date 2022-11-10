//
//  BasketReviewTest.swift
//  shopTests
//
//  Created by Ke4a on 15.09.2022.
//

@testable import shop
import XCTest

class BasketServiceTest: XCTestCase {
    // MARK: - Properties

    var network: NetworkMock!
    var parser: DecoderResponseProtocol!
    var service: BasketService!

    // MARK: - Initialization

    override func setUp() {
        super.setUp()
        network = .init()
        parser = DecoderResponse()
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
    func testFetchBasketDouble() {
        var lastFetch: [ResponseBasketModel]?

        let expectationFirst = expectation(description: "testFetchBasketFirst")

        service.fetchBasketAsync()
        network.completionRequest = {
            expectationFirst.fulfill()
        }

        waitForExpectations(timeout: 1)
        XCTAssertNotNil(service.data)
        lastFetch = service.data

        let expectationSecond = expectation(description: "testFetchBasketSecond")

        service.fetchBasketAsync()
        network.completionRequest = {
            expectationSecond.fulfill()
        }

        waitForExpectations(timeout: 1)
        XCTAssertNotNil(lastFetch)
        XCTAssertNotEqual(lastFetch?.first?.quantity, service.data?.first?.quantity)
    }

    /// Test  fetch add item.
    /// The first request for data is checked. The second request is getting data and difference from the first one.
    func testFetchAddToBasket() {
        let expectationFirst = expectation(description: "testFetchAddToBasketFirst")

        service.fetchBasketAsync()
        network.completionRequest = {
            expectationFirst.fulfill()
        }

        waitForExpectations(timeout: 1)
        XCTAssertNotNil(service.data)

        let expectationSecond = expectation(description: "testFetchAddToBasketSecond")

        service.fetchAddItemToBasketAsync()
        network.completionRequest = {
            expectationSecond.fulfill()
        }

        waitForExpectations(timeout: 1)
        XCTAssertEqual(service.data?.first?.quantity, 2)
    }

    /// Test  fetch remove item.
    /// The first request for data is checked. The second request is getting data and difference from the first one.
    func testFetchRemoveToBasket() {
        let expectationFirst = expectation(description: "testFetchRemoveToBasketFirst")

        service.fetchBasketAsync()
        network.completionRequest = {
            expectationFirst.fulfill()
        }

        waitForExpectations(timeout: 1)
        XCTAssertNotNil(service.data)

        let expectationSecond = expectation(description: "testFetchRemoveToBasketSecond")

        service.fetchRemoveItemToBasketAsync()
        network.completionRequest = {
            expectationSecond.fulfill()
        }

        waitForExpectations(timeout: 1)
        XCTAssertEqual(service.data?.count, 0)
    }

    /// Test  fetch remove all.
    /// The first request for data is checked. The second request is getting data and difference from the first one.
    func testFetchRemoveAllToBasket() {
        let expectationFirst = expectation(description: "testFetchRemoveAllToBasketFirst")

        service.fetchBasketAsync()
        network.completionRequest = {
            expectationFirst.fulfill()
        }

        waitForExpectations(timeout: 1)
        XCTAssertNotNil(service.data)

        let expectationSecond = expectation(description: "testFetchRemoveAllToBasketSecond")

        service.fetchRemoveAllToBasketAsync()
        network.completionRequest = {
            expectationSecond.fulfill()
        }

        waitForExpectations(timeout: 1)
        XCTAssertEqual(service.data?.count, 0)
    }

    /// Test  fetch pay.
    /// The first request for data is checked. The second request is getting data and difference from the first one.
    func testFetchPayBasket() {
        let expectationFirst = expectation(description: "FetchPayBaskeFirst")

        service.fetchBasketAsync()
        network.completionRequest = {
            expectationFirst.fulfill()
        }

        waitForExpectations(timeout: 1)
        XCTAssertNotNil(service.data)

        let expectationSecond = expectation(description: "FetchPayBaskeSecond")

        service.fetchPayBasketAsync()
        network.completionRequest = {
            expectationSecond.fulfill()
        }

        waitForExpectations(timeout: 1)
        XCTAssertEqual(service.data?.count, 0)
    }
}
