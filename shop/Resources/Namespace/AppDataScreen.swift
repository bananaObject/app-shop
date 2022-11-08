//
//  AppDataScreen.swift
//  shop
//
//  Created by Ke4a on 01.11.2022.
//
// swiftlint:disable type_name
// swiftlint:disable nesting

import Foundation

/// Application data namespace to fill the screens.
enum AppDataScreen {
    // MARK: - Image

    /// Data image for all screens.
    enum image {
        static var eyeOpen: String { "eyeOpen" }
        static var eyeClose: String { "eyeClose" }
        static var signUp: String { "signUp" }
        static var checkMark: String { "checkMark" }
    }
}

// MARK: - Sign Up

extension AppDataScreen {
    /// Data for "sign up" screen.
    enum signUp {
        static var tittleNav: String { "Sign up" }
        static var components: [Component] {
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

        enum Component: String {
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
                case .bio :
                    return 120
                default:
                    return 25
                }
            }
        }
    }
}

// MARK: - Sign In

extension AppDataScreen {
    /// Data for "sign in" screen.
    enum signIn {
        static var logoName: String { "Shop" }
        static var loginPlaceholder: String { "Login" }
        static var passPlaceholder: String { "Password" }
        static var submitButton: String { "Sign in" }
    }
}
