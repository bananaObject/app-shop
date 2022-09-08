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
    typealias Model = ResponseRegistrationModel

    // MARK: - Properties

    var network: NetworkProtocol!

    // MARK: - Initialization

    override func setUp() {
        super.setUp()
        network = NetworkMock()
    }

    // MARK: - Methods

    func testRegistrationDecoder() async throws {
        let decoder = ResponseParser<ResponseRegistrationModel>()
        
        network.fetch(.registration(.init())) { result in
            switch result {
            case .success(let data):
                guard let decodeResult = try? decoder.decode(data: data)
                else { return XCTFail("testRegistrationDecoder = Fail") }
                
                XCTAssertEqual(decodeResult.userMessage, "Регистрация прошла успешно!")
                XCTAssertTrue(type(of: decodeResult) == ResponseRegistrationModel.self)
            case .failure:
                break
            }
        }
    }
    
    func testRegistrationDecoderIos13() async throws {
        let decoder = ResponseParser<ResponseRegistrationModel>()
        
        do {
            let data = try await network.fetch(.registration(.init()))
            let decodeResult = try await decoder.decode(data: data)
            
            XCTAssertEqual(decodeResult.userMessage, "Регистрация прошла успешно!")
            XCTAssertTrue(type(of: decodeResult) == ResponseRegistrationModel.self)
        } catch {
            XCTFail("testRegistrationDecoderIos13 = Fail")
        }
    }
    
    func testLoginDecoder() async throws {
        let decoder = ResponseParser<ResponseLoginModel>()
        
        network.fetch(.login(.init())) { result in
            switch result {
            case .success(let data):
                guard let decodeResult = try? decoder.decode(data: data)
                else { return XCTFail("testLoginDecoder = Fail") }
                
                XCTAssertEqual(decodeResult.user.userLogin, "geekbrains")
                XCTAssertTrue(type(of: decodeResult.user) == UserModel.self)
            case .failure:
                break
            }
        }
    }
    
    func testLoginDecoderIos13() async throws {
        let decoder = ResponseParser<ResponseLoginModel>()
        
        do {
            let data = try await network.fetch(.login(.init()))
            let decodeResult = try await decoder.decode(data: data)
            
            XCTAssertEqual(decodeResult.user.userLogin, "geekbrains")
            XCTAssertTrue(type(of: decodeResult.user) == UserModel.self)
        } catch {
            XCTFail("testLoginDecoderIos13 = Fail")
        }
    }
    
    func testLogoutDecoder() async throws {
        let decoder = ResponseParser<ResponseResultModel>()
        
        network.fetch(.logout(123)) { result in
            switch result {
            case .success(let data):
                guard let decodeResult = try? decoder.decode(data: data)
                else { return XCTFail("testLogoutDecoder = Fail") }
                
                XCTAssertEqual(decodeResult.result, 1)
                XCTAssertTrue(type(of: decodeResult) == ResponseResultModel.self)
            case .failure:
                break
            }
        }
    }
    
    func testLogoutDecoderIos13() async throws {
        let decoder = ResponseParser<ResponseResultModel>()
        
        do {
            let data = try await network.fetch(.logout(123))
            let decodeResult = try await decoder.decode(data: data)
            
            XCTAssertEqual(decodeResult.result, 1)
            XCTAssertTrue(type(of: decodeResult) == ResponseResultModel.self)
        } catch {
            XCTFail("testLogoutDecoderIos13 = Fail")
        }
    }
    
    func testCatalogDecoder() async throws {
        let decoder = ResponseParser<[ResponseCatalogModel]>()
        
        network.fetch(.catalog(1, 1)) { result in
            switch result {
            case .success(let data):
                guard let decodeResult = try? decoder.decode(data: data)
                else { return XCTFail("testCatalogDecoder = Fail") }
                
                XCTAssertEqual(decodeResult.count, 2)
                XCTAssertTrue(type(of: decodeResult) == [ResponseCatalogModel].self)
            case .failure:
                break
            }
        }
    }
    
    func testCatalogDecoderIos13() async throws {
        let decoder = ResponseParser<[ResponseCatalogModel]>()
        
        do {
            let data = try await network.fetch(.catalog(1, 1))
            let decodeResult = try await decoder.decode(data: data)
            
            XCTAssertEqual(decodeResult.count, 2)
            XCTAssertTrue(type(of: decodeResult) == [ResponseCatalogModel].self)
        } catch {
            XCTFail("testCatalogDecoderIos13 = Fail")
        }
    }
    
    func testProductDecoder() throws {
        let decoder = ResponseParser<ResponseProductModel>()
        
        network.fetch(.product(1)) { result in
            switch result {
            case .success(let data):
                guard let decodeResult = try? decoder.decode(data: data)
                else { return XCTFail("testProductDecoder = Fail") }
                
                XCTAssertEqual(decodeResult.productPrice, 45600)
                XCTAssertTrue(type(of: decodeResult) == ResponseProductModel.self)
            case .failure:
                break
            }
        }
    }
    
    func testProductDecoderIos13() async throws {
        let decoder = ResponseParser<ResponseProductModel>()
        
        do {
            let data = try await network.fetch(.product(1))
            let decodeResult = try await decoder.decode(data: data)
            
            XCTAssertEqual(decodeResult.productPrice, 45600)
            XCTAssertTrue(type(of: decodeResult) == ResponseProductModel.self)
            
        } catch {
            XCTFail("testProductDecoderIos13 = Fail")
        }
    }
}
