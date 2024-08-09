//
//  CoreDataManager.swift
//  PasswordManager
//
//  Created by Darshan on 09/08/24.
//
import Foundation
import CoreData
import CryptoKit
import Security

class CoreDataManager {
    static let shared = CoreDataManager()

    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Unresolved error \(error), \((error as NSError).userInfo)")
            }
        }
    }

    func addAccount(accountName: String, usernameEmail: String, password: String) {
        let context = CoreDataManager.shared.context
        let account = AccountDetails(context: context)
        account.id = UUID().uuidString
        account.accountName = accountName
        account.username_email = usernameEmail
        
        // Encrypt password before saving
        if let encryptedPassword = encrypt(text: password) {
            account.password = encryptedPassword.base64EncodedString()
        } else {
            print("Failed to encrypt password")
        }

        CoreDataManager.shared.saveContext()
    }
    
    func updateAccount(id: UUID, accountName: String, usernameEmail: String, password: String) {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<AccountDetails> = AccountDetails.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id.uuidString)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let account = results.first {
                account.accountName = accountName
                account.username_email = usernameEmail
                if let encryptedPassword = encrypt(text: password) {
                    account.password = encryptedPassword.base64EncodedString()
                } else {
                    print("Failed to encrypt password")
                }
                
                CoreDataManager.shared.saveContext()
            }
        } catch {
            fatalError("Failed to fetch AccountDetails: \(error)")
        }
    }
    
    func deleteAccount(id: UUID) {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<AccountDetails> = AccountDetails.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id.uuidString)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let account = results.first {
                context.delete(account)
                CoreDataManager.shared.saveContext()
            }
        } catch {
            fatalError("Failed to fetch AccountDetails: \(error)")
        }
    }
    
    func fetchAccounts() -> [Account] {
        let request: NSFetchRequest<AccountDetails> = AccountDetails.fetchRequest()
        do {
            let results = try context.fetch(request)
            return results.map { accountDetails in
                let decryptedPassword: String
                if let encryptedPasswordBase64 = accountDetails.password,
                   let encryptedData = Data(base64Encoded: encryptedPasswordBase64),
                   let decrypted = decrypt(data: encryptedData) {
                    decryptedPassword = decrypted
                } else {
                    decryptedPassword = "Error decrypting password"
                }
                
                return Account(
                    id: UUID(uuidString: accountDetails.id ?? "") ?? UUID(),
                    accountName: accountDetails.accountName ?? "",
                    username_email: accountDetails.username_email ?? "",
                    password: decryptedPassword
                )
            }
        } catch {
            print("Failed to fetch accounts: \(error)")
            return []
        }
    }

    private func encrypt(text: String) -> Data? {
        guard let key = retrieveSymmetricKey() else {
            print("No encryption key found")
            return nil
        }
        let data = text.data(using: .utf8)!
        let sealedBox = try? AES.GCM.seal(data, using: key)
        return sealedBox?.combined
    }
    
    private func decrypt(data: Data) -> String? {
        guard let key = retrieveSymmetricKey() else {
            print("No encryption key found")
            return nil
        }
        guard let sealedBox = try? AES.GCM.SealedBox(combined: data),
              let decryptedData = try? AES.GCM.open(sealedBox, using: key),
              let decryptedString = String(data: decryptedData, encoding: .utf8) else {
            return nil
        }
        return decryptedString
    }

    private func generateSymmetricKey() -> SymmetricKey {
        return SymmetricKey(size: .bits256)
    }

    private func storeKeyInKeychain(_ keyData: Data) {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "encryptionKey",
            kSecValueData as String: keyData
        ] as [String: Any]

        SecItemAdd(query as CFDictionary, nil)
    }
    
    private func retrieveSymmetricKey() -> SymmetricKey? {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "encryptionKey",
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ] as [String: Any]

        var keyDataTypeRef: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &keyDataTypeRef)

        if status == errSecSuccess, let keyData = keyDataTypeRef as? Data {
            return SymmetricKey(data: keyData)
        } else {
            let key = generateSymmetricKey()
            let keyData = key.withUnsafeBytes { Data($0) }
            storeKeyInKeychain(keyData)
            return key
        }
    }
}
