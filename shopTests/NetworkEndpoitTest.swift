//
//  NetworkEndpoitTest.swift
//  shopTests
//
//  Created by Ke4a on 07.09.2022.
//

@testable import shop
import XCTest

/// Checking the endpoint for a valid request address.
class NetworkEndpoitTest: XCTestCase {
    // MARK: - Properties

    var endpoint: NetworkEndpoint!

    // MARK: - Initialization

    override func setUp() {
        super.setUp()
        endpoint = .none
    }

    // MARK: - Deinitialization

    override func tearDown() {
        endpoint = nil
        super.tearDown()
    }

    // MARK: - Methods

    func testRegistrationEndpoint() {
        endpoint = .registration(.init())

        let url = "https://raw.githubusercontent.com/GeekBrainsTutorial/online-store-api/master/responses/registerUser.json?id_user=0&username=&password=&email=&gender=&credit_card=&bio="
        do {
            let answerEndpoint = try getUrl(endpoint)

            XCTAssertEqual(answerEndpoint, url)
        } catch {
            XCTFail("testRegistrationEndpoint = fail")
        }
    }

    func testLoginEndpoint() {
        let userName = "1234"
        let password = "4321"
        endpoint = .login(.init(username: userName, password: password))

        let url = "https://raw.githubusercontent.com/GeekBrainsTutorial/online-store-api/master/responses/login.json?username=\(userName)&password=\(password)"
        do {
            let answerEndpoint = try getUrl(endpoint)

            XCTAssertEqual(answerEndpoint, url)
        } catch {
            XCTFail("testLoginEndpoint = fail")
        }
    }

    func testLogoutEndpoint() {
        let id = 12424
        endpoint = .logout(id)

        let url = "https://raw.githubusercontent.com/GeekBrainsTutorial/online-store-api/master/responses/logout.json?id_user=\(id)"
        do {
            let answerEndpoint = try getUrl(endpoint)

            XCTAssertEqual(answerEndpoint, url)
        } catch {
            XCTFail("testLogoutEndpoint = fail")
        }
    }

    func testChangeUserDataEndpoint() {
        let id = 12424
        endpoint = .logout(id)

        let url = "https://raw.githubusercontent.com/GeekBrainsTutorial/online-store-api/master/responses/logout.json?id_user=\(id)"
        do {
            let answerEndpoint = try getUrl(endpoint)

            XCTAssertEqual(answerEndpoint, url)
        } catch {
            XCTFail("testChangeUserDataEndpoint = fail")
        }
    }

    func testCatalogEndpoint() {
        let page = 1
        let category = 1
        endpoint = .catalog(page, category)

        let url = "https://raw.githubusercontent.com/GeekBrainsTutorial/online-store-api/master/responses/catalogData.json?page_number=\(page)&id_category=\(category)"
        do {
            let answerEndpoint = try getUrl(endpoint)

            XCTAssertEqual(answerEndpoint, url)
        } catch {
            XCTFail("testCatalogEndpoint = fail")
        }
    }

    func testProductEndpoint() {
        let id = 1
        endpoint = .product(id)

        let url = "https://raw.githubusercontent.com/GeekBrainsTutorial/online-store-api/master/responses/getGoodById.json?id_product=\(id)"
        do {
            let answerEndpoint = try getUrl(endpoint)

            XCTAssertEqual(answerEndpoint, url)
        } catch {
            XCTFail("testProductEndpoint = fail")
        }
    }
}

// MARK: - Extension

extension NetworkEndpoitTest {
    /// Creates a URL, string returned.
    /// - Parameter endpoint: Request address.
    /// - Returns: Url string.
    private func getUrl(_ endpoint: Endpoint) throws -> String {
        var urlComponents: URLComponents = endpoint.baseURL
        urlComponents.path = endpoint.path
        urlComponents.queryItems = endpoint.params

        guard let stringUrl = urlComponents.string else {
            throw RequestError.invalidURL
        }

        return stringUrl
    }
}
