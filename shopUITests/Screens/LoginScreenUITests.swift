//
//  LoginScreenUITests.swift
//  shopUITests
//
//  Created by Ke4a on 21.11.2022.
//

import XCTest

final class LoginScreenUITests: XCTestCase {
    var app: XCUIApplication!
    var viewApp: XCUIElement!

    override func setUpWithError() throws {
        try super.setUpWithError()

        app = XCUIApplication()
        app.launchArguments.append(AppUITestsKey.loginView)
        app.launch()
        viewApp = app.otherElements["loginView"].firstMatch
    }

    // Checking items on the screen.
    func testElements() {
        app.launch()

        let viewApp = app.otherElements["loginView"].firstMatch

        let signUpButton = viewApp.buttons["signUpButton"].firstMatch
        let logoLabel = viewApp.staticTexts["logoLabel"].firstMatch
        let loginField = viewApp.textFields["loginTextfield"].firstMatch
        let passField = viewApp.secureTextFields["passTextfield"].firstMatch
        let signInButton = viewApp.buttons["signInButton"].firstMatch

        XCTAssertTrue(signUpButton.exists)
        XCTAssertTrue(logoLabel.exists)
        XCTAssertTrue(loginField.exists)
        XCTAssertTrue(passField.exists)
        XCTAssertTrue(signInButton.exists)
    }

    // Test script for completeness of fields.
    func testFields() {
        app.launch()

        let signInButton = viewApp.buttons["signInButton"].firstMatch

        enterFields(login: "123", pass: "123")
        XCTAssertFalse(signInButton.isEnabled)

        enterFields(login: "456", pass: "123456")
        XCTAssertTrue(signInButton.isEnabled)
    }

    // Test script password display.
    func testSecureButton() {
        let text = "12345"

        var passField = viewApp.secureTextFields["passTextfield"].firstMatch
        var secureButton = passField.buttons["secureButton"].firstMatch
        XCTAssertTrue(passField.exists)
        XCTAssertTrue(secureButton.exists)

        secureButton.tap()

        // After clicking on the secu button, the textfield and secure button has changed
        passField = viewApp.textFields["passTextfield"].firstMatch
        secureButton = passField.buttons["secureButton"].firstMatch
        XCTAssertTrue(passField.exists)
        XCTAssertTrue(secureButton.exists)

        passField.tap()
        passField.typeText(text)
        guard let value = passField.value as? String else {
            XCTFail("No value")
            return

        }
        XCTAssertEqual(value, text)

        secureButton.tap()

        // After clicking on the secu button, the textfield and secure button has changed
        passField = viewApp.secureTextFields["passTextfield"].firstMatch
        secureButton = passField.buttons["secureButton"].firstMatch
        XCTAssertTrue(secureButton.exists)
        XCTAssertTrue(passField.exists)
    }

    // Test script  sign up.
    func testSignUp() {
        app.launch()

        let signUpButton = viewApp.buttons["signUpButton"]
        signUpButton.tap()

        viewApp = app.otherElements["signUpView"].firstMatch
        XCTAssertTrue(viewApp.waitForExistence(timeout: 3))
    }

    // Test script  sign in.
    func testSignIn() {
        app.launch()

        let signInButton = viewApp.buttons["signInButton"].firstMatch

        enterFields(login: "admin", pass: "admin")
        signInButton.tap()

        viewApp = app.otherElements["catalogView"].firstMatch
        XCTAssertTrue(viewApp.waitForExistence(timeout: 15))
    }

    /// Type text in fields.
    /// - Parameters:
    ///   - login: Login text.
    ///   - pass: Password text.
    private func enterFields(login: String, pass: String) {
        let loginField = viewApp.textFields["loginTextfield"].firstMatch
        let passField = viewApp.secureTextFields["passTextfield"].firstMatch

        XCTAssertTrue(loginField.exists)
        XCTAssertTrue(passField.exists)

        loginField.tap()
        loginField.typeText(login)
        passField.tap()
        // If error "Failed to synthesize event: Neither element nor any descendant has keyboard focus."
        // Run the command once "defaults write com.apple.iphonesimulator ConnectHardwareKeyboard 0".
        // Disable by default hardware keyboard.
        passField.typeText(pass)
    }
}
