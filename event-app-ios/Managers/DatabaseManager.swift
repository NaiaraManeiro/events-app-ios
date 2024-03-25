//
//  DatabaseManager.swift
//  event-app-ios
//
//  Created by Naiara Maneiro on 15/3/24.
//

import Foundation
import SQLite
import CommonCrypto

class DatabaseManager {
    
    static let DIR_TASK_DB = "EventApp"
    static let STORE_NAME = "seidor.sqlite3"
    
    private let users = Table("users")
    private let email = Expression<String>("email")
    private let pass = Expression<String>("pass")
    private let salt = Expression<String>("salt")
    private let username = Expression<String>("username")
    private let name = Expression<String>("name")
    
    static let shared = DatabaseManager()
    
    private var db: Connection? = nil
    
    private init() {
        if let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let dirPath = docDir.appendingPathComponent(Self.DIR_TASK_DB)
            
            do {
                try FileManager.default.createDirectory(atPath: dirPath.path, withIntermediateDirectories: true, attributes: nil)
                let dbPath = dirPath.appendingPathComponent(Self.STORE_NAME).path
                db = try Connection(dbPath)
                //createTable()
                print("SQLiteDataStore init successfully at: \(dbPath) ")
            } catch {
                db = nil
                print("SQLiteDataStore init error: \(error)")
            }
        } else {
            db = nil
        }
    }
    
    private func createTable() {
        guard let database = db else {
            return
        }
        do {
            try database.run(users.create { table in
                table.column(email)
                table.column(pass)
                table.column(salt)
                table.column(username)
                table.column(name)
            })
            print("Tables Created...")
        } catch {
            print(error)
        }
    }
    
    //User
    
    func insertUser(email: String, pass: String) -> Int64? {
        guard let database = db else { return nil }
        
        let salt = generateSalt()
        let hashedPassword = hashPassword(pass, salt: salt)

        let insert = users.insert(self.email <- email,
                                  self.pass <- hashedPassword,
                                  self.salt <- salt,
                                  self.username <- "",
                                  self.name <- "" )

        do {
            let rowID = try database.run(insert)
            return rowID
        } catch {
            print(error)
            return nil
        }
    }
    
    func findUser(email: String) -> UserModel? {
        var user: UserModel? = nil
        guard let database = db else { return nil }

        let filter = self.users.filter(self.email == email)
        do {
            for t in try database.prepare(filter) {
                user = UserModel(email: email, pass: t[pass], salt: t[salt], username: t[username], name: t[name])
            }
        } catch {
            print(error)
        }
        return user
    }
    
    //Hash password
    
    func generateSalt() -> String {
        let randomBytesCount = 16 // You can adjust the size of the salt
        var randomBytes = [UInt8](repeating: 0, count: randomBytesCount)
        _ = SecRandomCopyBytes(kSecRandomDefault, randomBytesCount, &randomBytes)
        return Data(randomBytes).base64EncodedString()
    }
    
    func hashPassword(_ password: String, salt: String) -> String {
        let passwordWithSalt = password + salt

        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        if let data = passwordWithSalt.data(using: .utf8) {
            _ = data.withUnsafeBytes {
            CC_SHA256($0.baseAddress, CC_LONG(data.count), &digest)
            }
        }

        return Data(digest).base64EncodedString()
    }
}
