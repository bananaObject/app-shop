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

        let url = "https://toxic-frog-company.herokuapp.com/user/registration"
        do {
            let answerEndpoint = try getUrl(endpoint)

            XCTAssertEqual(answerEndpoint, url)
        } catch {
            XCTFail("testRegistrationEndpoint = fail")
        }
    }

    func testLoginEndpoint() {
        let login = "1234"
        let password = "4321"
        endpoint = .login(.init(login: login, password: password))

        let url = "https://toxic-frog-company.herokuapp.com/auth/login"
        do {
            let answerEndpoint = try getUrl(endpoint)

            XCTAssertEqual(answerEndpoint, url)
        } catch {
            XCTFail("testLoginEndpoint = fail")
        }
    }

    func testLogoutEndpoint() {
        endpoint = .logout

        let url = "https://toxic-frog-company.herokuapp.com/auth/logout"
        do {
            let answerEndpoint = try getUrl(endpoint)
            
            XCTAssertEqual(answerEndpoint, url)
        } catch {
            XCTFail("testLogoutEndpoint = fail")
        }
    }

    func testChangeUserDataEndpoint() {
        let user = RequestUserInfo(login: "Somebody",
                                   password: "mypassword",
                                   firstname: "1" ,
                                   lastname: "1" ,
                                   email: "some@some.ru",
                                   gender: "m",
                                   creditCard: "9872389-2424-234224-234",
                                   bio: "This is good! I think I will switch to another language")

        endpoint = .changeUserData(user)

        let url = "https://toxic-frog-company.herokuapp.com/user/changeInfo"
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

        let url = "https://toxic-frog-company.herokuapp.com/catalog?page_number=\(page)&id_category=\(category)"
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

        let url = "https://toxic-frog-company.herokuapp.com/catalog/product/\(id)"
        do {
            let answerEndpoint = try getUrl(endpoint)

            XCTAssertEqual(answerEndpoint, url)
        } catch {
            XCTFail("testProductEndpoint = fail")
        }
    }


    func testReviewsEndpoint() {
        let id = 1
        let page = 1
        endpoint = .reviews(id, page)

        let url = "https://toxic-frog-company.herokuapp.com/catalog/product/\(id)/reviews?page_number=\(page)"
        do {
            let answerEndpoint = try getUrl(endpoint)

            XCTAssertEqual(answerEndpoint, url)
        } catch {
            XCTFail("testProductEndpoint = fail")
        }
    }

    func testAddReviewEndpoint() {
        let id = 1
        let text = "awfhufwuh9h 9hf9 h19"
        endpoint = .addReview(id, text)

        let url = "https://toxic-frog-company.herokuapp.com/catalog/product/\(id)/review/add"
        do {
            let answerEndpoint = try getUrl(endpoint)

            XCTAssertEqual(answerEndpoint, url)
        } catch {
            XCTFail("testProductEndpoint = fail")
        }
    }


    func testDeleteReviewEndpoint() {
        let id = 1
        let idReview = 1
        endpoint = .deleteReview(id, idReview)

        let url = "https://toxic-frog-company.herokuapp.com/catalog/product/\(id)/review/delete"
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
