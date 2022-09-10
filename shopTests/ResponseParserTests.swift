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

    // MARK: - Initialization

    override func setUp() {
        super.setUp()
        network = NetworkMock()
    }

    // MARK: - Methods

    func testRegistrationDecoder() async throws {
        typealias Model = ResponseMessageModel

        let decoder = DecoderResponse<Model>()
        
        network.fetch(.registration(.init())) { result in
            switch result {
            case .success(let data):
                guard let decodeResult = try? decoder.decode(data: data)
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

        let decoder = DecoderResponse<Model>()
        
        do {
            let data = try await network.fetch(.registration(.init()))
            let decodeResult = try await decoder.decode(data: data)
            
            XCTAssertEqual(decodeResult.message, "Регистрация прошла успешно!")
            XCTAssertTrue(type(of: decodeResult) == Model.self)
        } catch {
            XCTFail("testRegistrationDecoderIos13 = Fail")
        }
    }
    
    func testLoginDecoder() async throws {
        typealias Model = ResponseLoginModel

        let decoder = DecoderResponse<Model>()
        
        network.fetch(.login(.init())) { result in
            switch result {
            case .success(let data):
                guard let decodeResult = try? decoder.decode(data: data)
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

        let decoder = DecoderResponse<Model>()
        
        do {
            let data = try await network.fetch(.login(.init()))
            let decodeResult = try await decoder.decode(data: data)
            
            XCTAssertEqual(decodeResult.user.login, "admin")
            XCTAssertTrue(type(of: decodeResult.user) == UserResponse.self)
        } catch {
            XCTFail("testLoginDecoderIos13 = Fail")
        }
    }
    
    func testLogoutDecoder() async throws {
        typealias Model = ResponseMessageModel

        let decoder = DecoderResponse<Model>()
        
        network.fetch(.logout("ff68g8gw8g18gwf8gf")) { result in
            switch result {
            case .success(let data):
                guard let decodeResult = try? decoder.decode(data: data)
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

        let decoder = DecoderResponse<Model>()
        
        do {
            let data = try await network.fetch(.logout("agfwghaiwgfu02gf10197fg902gf"))
            let decodeResult = try await decoder.decode(data: data)
            
            XCTAssertEqual(decodeResult.message, "Вы успешно вышли из приложения")
            XCTAssertTrue(type(of: decodeResult) == Model.self)
        } catch {
            XCTFail("testLogoutDecoderIos13 = Fail")
        }
    }
    
    func testCatalogDecoder() async throws {
        typealias Model = ResponseCatalogModel

        let decoder = DecoderResponse<Model>()
        
        network.fetch(.catalog(1, 1)) { result in
            switch result {
            case .success(let data):
                guard let decodeResult = try? decoder.decode(data: data)
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

        let decoder = DecoderResponse<Model>()
        
        do {
            let data = try await network.fetch(.catalog(1, 1))
            let decodeResult = try await decoder.decode(data: data)
            
            XCTAssertEqual(decodeResult.products.count, 2)
            XCTAssertTrue(type(of: decodeResult) == Model.self)
        } catch {
            XCTFail("testCatalogDecoderIos13 = Fail")
        }
    }
    
    func testProductDecoder() throws {
        typealias Model = ResponseProductModel

        let decoder = DecoderResponse<Model>()
        
        network.fetch(.product(1)) { result in
            switch result {
            case .success(let data):
                guard let decodeResult = try? decoder.decode(data: data)
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

        let decoder = DecoderResponse<Model>()
        
        do {
            let data = try await network.fetch(.product(1))
            let decodeResult = try await decoder.decode(data: data)
            
            XCTAssertEqual(decodeResult.id, 1)
            XCTAssertTrue(type(of: decodeResult) == Model.self)
            
        } catch {
            XCTFail("testProductDecoderIos13 = Fail")
        }
    }
}
