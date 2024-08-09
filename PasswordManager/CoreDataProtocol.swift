//
//  CoreDataProtocol.swift
//  PasswordManager
//
//  Created by Darshan on 09/08/24.
//

import Foundation
import CoreData

protocol CoreDataProtocol {
    func addAccount(accountName: String, usernameEmail: String, password: String)
    func updateAccount(id: UUID, accountName: String, usernameEmail: String, password: String)
    func deleteAccount(id: UUID)
    func fetchAccounts() -> [Account]
}

