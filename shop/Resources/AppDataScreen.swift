//
//  AppDataScreen.swift
//  shop
//
//  Created by Ke4a on 01.11.2022.
//

import Foundation

/// Application data namespace to fill the screens.
enum AppDataScreen {
    // MARK: - Static Computed Properties

    /// Data for "sign up" screen.
    static var signUp: [SignUp] {
        [.login,
         .password,
         .firstName,
         .lastname,
         .email,
         .gender,
         .creditCard,
         .bio,
         .submitButton]
    }

    /// Data for "sign in" screen.
    static var login: SignIn {
        SignIn()
    }

    /// Data image for all screens.
    static var image: Image {
        Image()
    }
}

// MARK: - Image

extension AppDataScreen {
    struct Image {
        let eyeOpen: String = "eyeOpen"
        let eyeClose: String = "eyeClose"
        let signUp: String = "signUp"
        let checkMark: String = "checkMark"
    }
}

// MARK: - Sign Up

extension AppDataScreen {
    enum SignUp: String {
        case login = "Login"
        case password = "Password"
        case firstName = "Firstname"
        case lastname = "Lastname"
        case email = "E-mail"
        case gender = "Gender"
        case creditCard = "Credit Card"
        case bio = "Biography"
        case submitButton = "Submit"

        var placeholder: String {
            switch self {
            case .submitButton:
                return ""
            default :
                return "Your \(self.rawValue.lowercased()), min \(self.minChar) char."
            }
        }

        var minChar: Int {
            switch self {
            case .login, .password:
                return 6
            case .email:
                return 5
            case .creditCard:
                return 16
            case .bio:
                return 10
            default:
                return 3
            }
        }

        var maxChar: Int {
            switch self {
            case .creditCard:
                return 16
            default:
                return 0
            }
        }
    }
}

// MARK: - Sign In

extension AppDataScreen {
    struct SignIn {
        let logoName = "Shop"
        let loginPlaceholder = "Login"
        let passPlaceholder = "Password"
        let submitButton = "Sign in"
    }
}
