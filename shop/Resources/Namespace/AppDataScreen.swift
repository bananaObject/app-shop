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
        static var minus: String { "minus" }
        static var plus: String { "plus" }
        static var trash: String { "trash" }
        static var cross: String { "cross" }
        static var basket: String { "basket" }
        static var payment: String { "payment" }
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
                default:
                    return "Your \(self.rawValue.lowercased()), min \(self.minChar) char."
                }
            }

            var minChar: Int {
                switch self {
                case .login, .password:
                    return 5
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
                case .bio:
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

// MARK: - Catalog

extension AppDataScreen {
    /// Data for "catalog" screen.
    enum catalog {
        static var tittleNav: String { "Catalog" }
    }
}

// MARK: - Product info

extension AppDataScreen {
    /// Data for "product info" screen.
    enum productInfo {
        /// Number of items per cell other products.
        static var qtInCellOtherProducts: Int { 3 }

        static var sectionTableView: [Сomponent] {
            [ .info([.images]),
              .info([.productName, .description]),
              .info([.review]),
              .otherProducts ]
        }

        enum Сomponent {
            case info(_ components: [Info])
            case otherProducts
        }

        enum Info {
            case images
            case productName
            case review
            case description
        }
    }
}

// MARK: - Basket

extension AppDataScreen {
    /// Data for "catalog" screen.
    enum basket {
        static var tittleNav: String { "Basket" }
        /// Cell on screen.
        static var cellOnscreen: CGFloat { 7 }
    }
}
