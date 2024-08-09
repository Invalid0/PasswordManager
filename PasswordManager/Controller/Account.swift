//
//  Account.swift
//  PasswordManager
//
//  Created by Darshan on 09/08/24.
//

import SwiftUI

struct Account: Identifiable,Equatable {
    var id = UUID()
    var accountName: String
    var username_email: String
    var password: String
}

