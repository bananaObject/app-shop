//
//  ResponseParserTests.swift
//  ResponseParserTests
//
//  Created by Ke4a on 07.09.2022.
//

@testable import shop
import XCTest

/// Checking the decoder for the correct type and correct data.
class ResponseParserTests: XCTestCase {
    // MARK: - Properties

    var network: NetworkProtocol!
    var decoder: DecoderResponseProtocol!

    // MARK: - Initialization

    override func setUp() {
        super.setUp()
        network = NetworkMock()
        decoder = DecoderResponse()
    }

    override func tearDown() {
        network = nil
        decoder = nil
        super.tearDown()
    }

    // MARK: - Methods

    func testRegistrationDecoder() async throws {
        typealias Model = ResponseMessageModel

        let decoder = DecoderResponse()
        
        network.fetch(.registration(.init())) { result in
            switch result {
            case .success(let data):
                guard let decodeResult = try? decoder.decode(data: data, model: Model.self)
                else { return XCTFail("testRegistrationDecoder = Fail") }
                
                XCTAssertEqual(decodeResult.message, "Регистрация прошла успешно!")
                XCTAssertTrue(type(of: decodeResult) == Model.self)
            case .failure:
                break
            }
        }
    }
    
    func testRegistrationDecoderIos13() async throws {
        typealias Model = ResponseMessageModel

        let decoder = DecoderResponse()
        
        do {
            let data = try await network.fetch(.registration(.init()))
            let decodeResult = try await decoder.decode(data: data, model: Model.self)
            
            XCTAssertEqual(decodeResult.message, "Регистрация прошла успешно!")
            XCTAssertTrue(type(of: decodeResult) == Model.self)
        } catch {
            XCTFail("testRegistrationDecoderIos13 = Fail")
        }
    }
    
    func testLoginDecoder() async throws {
        typealias Model = ResponseLoginModel

        let decoder = DecoderResponse()
        
        network.fetch(.login(.init())) { result in
            switch result {
            case .success(let data):
                guard let decodeResult = try? decoder.decode(data: data, model: Model.self)
                else { return XCTFail("testLoginDecoder = Fail") }
                
                XCTAssertEqual(decodeResult.user.login, "admin")
                XCTAssertTrue(type(of: decodeResult.user) == UserResponse.self)
            case .failure:
                break
            }
        }
    }
    
    func testLoginDecoderIos13() async throws {
        typealias Model = ResponseLoginModel

        let decoder = DecoderResponse()
        
        do {
            let data = try await network.fetch(.login(.init()))
            let decodeResult = try await decoder.decode(data: data, model: Model.self)
            
            XCTAssertEqual(decodeResult.user.login, "admin")
            XCTAssertTrue(type(of: decodeResult.user) == UserResponse.self)
        } catch {
            XCTFail("testLoginDecoderIos13 = Fail")
        }
    }
    
    func testLogoutDecoder() async throws {
        typealias Model = ResponseMessageModel

        let decoder = DecoderResponse()
        
        network.fetch(.logout) { result in
            switch result {
            case .success(let data):
                guard let decodeResult = try? decoder.decode(data: data, model: Model.self)
                else { return XCTFail("testLogoutDecoder = Fail") }
                
                XCTAssertEqual(decodeResult.message, "Вы успешно вышли из приложения")
                XCTAssertTrue(type(of: decodeResult) == Model.self)
            case .failure:
                break
            }
        }
    }
    
    func testLogoutDecoderIos13() async throws {
        typealias Model = ResponseMessageModel

        let decoder = DecoderResponse()
        
        do {
            let data = try await network.fetch(.logout)
            let decodeResult = try await decoder.decode(data: data, model: Model.self)
            
            XCTAssertEqual(decodeResult.message, "Вы успешно вышли из приложения")
            XCTAssertTrue(type(of: decodeResult) == Model.self)
        } catch {
            XCTFail("testLogoutDecoderIos13 = Fail")
        }
    }
    
    func testCatalogDecoder() async throws {
        typealias Model = ResponseCatalogModel

        let decoder = DecoderResponse()
        
        network.fetch(.catalog(1, 1)) { result in
            switch result {
            case .success(let data):
                guard let decodeResult = try? decoder.decode(data: data, model: Model.self)
                else { return XCTFail("testCatalogDecoder = Fail") }
                
                XCTAssertEqual(decodeResult.products.count, 2)
                XCTAssertTrue(type(of: decodeResult) == Model.self)
            case .failure:
                break
            }
        }
    }
    
    func testCatalogDecoderIos13() async throws {
        typealias Model = ResponseCatalogModel

        let decoder = DecoderResponse()
        
        do {
            let data = try await network.fetch(.catalog(1, 1))
            let decodeResult = try await decoder.decode(data: data, model: Model.self)
            
            XCTAssertEqual(decodeResult.products.count, 2)
            XCTAssertTrue(type(of: decodeResult) == Model.self)
        } catch {
            XCTFail("testCatalogDecoderIos13 = Fail")
        }
    }
    
    func testProductDecoder() throws {
        typealias Model = ResponseProductModel

        let decoder = DecoderResponse()
        
        network.fetch(.product(1)) { result in
            switch result {
            case .success(let data):
                guard let decodeResult = try? decoder.decode(data: data, model: Model.self)
                else { return XCTFail("testProductDecoder = Fail") }
                
                XCTAssertEqual(decodeResult.id, 1)
                XCTAssertTrue(type(of: decodeResult) == Model.self)
            case .failure:
                break
            }
        }
    }
    
    func testProductDecoderIos13() async throws {
        typealias Model = ResponseProductModel

        do {
            let data = try await network.fetch(.product(1))
            let decodeResult = try await decoder.decode(data: data, model: Model.self)
            
            XCTAssertEqual(decodeResult.id, 1)
            XCTAssertTrue(type(of: decodeResult) == Model.self)
            
        } catch {
            XCTFail("testProductDecoderIos13 = Fail")
        }
    }

    func testReviewsDecoder() throws {
        typealias Model = ResponseReviewsProductModel

        let decoder = DecoderResponse()

        network.fetch(.reviews(1, 1)) { result in
            switch result {
            case .success(let data):
                guard let decodeResult = try? decoder.decode(data: data, model: Model.self)
                else { return XCTFail("testProductDecoder = Fail") }

                XCTAssertEqual(decodeResult.items.count, 1)
                XCTAssertTrue(type(of: decodeResult) == Model.self)
            case .failure:
                break
            }
        }
    }

    func testReviewsDecoderIos13() async throws {
        typealias Model = ResponseReviewsProductModel

        do {
            let data = try await network.fetch(.reviews(1, 1))
            let decodeResult = try await decoder.decode(data: data, model: Model.self)

            XCTAssertEqual(decodeResult.items.count, 1)
            XCTAssertTrue(type(of: decodeResult) == Model.self)

        } catch {
            XCTFail("testReviewsDecoderIos13 = Fail")
        }
    }

    func testAddReviewDecoder() throws {
        typealias Model = ResponseReviewModel

        let decoder = DecoderResponse()

        network.fetch(.addReview(1, "")) { result in
            switch result {
            case .success(let data):
                guard let decodeResult = try? decoder.decode(data: data, model: Model.self)
                else { return XCTFail("testProductDecoder = Fail") }

                XCTAssertEqual(decodeResult.idReview, 8332)
                XCTAssertTrue(type(of: decodeResult) == Model.self)
            case .failure:
                break
            }
        }
    }

    func testAddReviewDecoderIos13() async throws {
        typealias Model = ResponseReviewModel

        do {
            let data = try await network.fetch(.addReview(1, ""))
            let decodeResult = try await decoder.decode(data: data, model: Model.self)

            XCTAssertEqual(decodeResult.idReview, 8332)
            XCTAssertTrue(type(of: decodeResult) == Model.self)

        } catch {
            XCTFail("testAddReviewDecoderIos13 = Fail")
        }
    }

    func testDeleteReviewDecoder() throws {
        typealias Model = ResponseMessageModel

        let decoder = DecoderResponse()

        network.fetch(.deleteReview(1, 1)) { result in
            switch result {
            case .success(let data):
                guard let decodeResult = try? decoder.decode(data: data, model: Model.self)
                else { return XCTFail("testProductDecoder = Fail") }

                XCTAssertEqual(decodeResult.message, "succes! 0")
                XCTAssertTrue(type(of: decodeResult) == Model.self)
            case .failure:
                break
            }
        }
    }

    func testDeleteReviewDecoderIos13() async throws {
        typealias Model = ResponseMessageModel

        do {
            let data = try await network.fetch(.deleteReview(1, 1))
            let decodeResult = try await decoder.decode(data: data, model: Model.self)

            XCTAssertEqual(decodeResult.message, "succes! 0")
            XCTAssertTrue(type(of: decodeResult) == Model.self)

        } catch {
            XCTFail("testDeleteReviewDecoderIos13 = Fail")
        }
    }
}
