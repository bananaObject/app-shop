//
//  RequestUserInfo.swift
//  shop
//
//  Created by Ke4a on 31.08.2022.
//

import Foundation

/// Network request data for registration.
struct RequestUserInfo {
    var login: String = ""
    var password: String = ""
    var firstname: String = ""
    var lastname: String = ""
    var email: String = ""
    var gender: String = ""
    var creditCard: String = ""
    var bio: String = ""
}
