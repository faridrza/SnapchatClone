//
//  File.swift
//  SnapchatClone
//
//  Created by Farid Rzayev on 22.01.22.
//

import Foundation
class UserInfoSingleton {
    static let SharedUserInfo = UserInfoSingleton()
    var KeptUsername = String()
    var KeptEmail = String()
}
