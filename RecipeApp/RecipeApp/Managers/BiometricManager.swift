//
//  BiometricManager.swift
//  RecipeApp
//
//  Created by Dmitri Bondartchev on 22/11/2024.
//

import LocalAuthentication
import CryptoKit
import Foundation

class BiometricManager {
    
    private static let keyTag = "com.recipeapp.biometric.key"
    
    private static var encryptionKey: SymmetricKey? {
        if let storedKey = UserDefaults.standard.data(forKey: keyTag) {
            return SymmetricKey(data: storedKey)
        } else {
            let key = SymmetricKey(size: .bits256)
            UserDefaults.standard.set(key.withUnsafeBytes { Data($0) }, forKey: keyTag)
            return key
        }
    }
    
    static func encrypt<T: Encodable>(object: T, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let key = encryptionKey else {
            completion(.failure(NSError(domain: "Encryption key unavailable", code: -1)))
            return
        }
        
        do {
            let objectData = try JSONEncoder().encode(object)
            let sealedBox = try AES.GCM.seal(objectData, using: key)
            completion(.success(sealedBox.combined!))
        } catch {
            completion(.failure(error))
        }
    }
    
    static func decrypt<T: Decodable>(data: Data, type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let key = encryptionKey else {
            completion(.failure(NSError(domain: "Decryption key unavailable", code: -1)))
            return
        }
        
        let context = LAContext()
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Please Authenticate to view the data") { success, error in
            guard success, error == nil else {
                completion(.failure(error ?? NSError(domain: "Authentication failed", code: -1)))
                return
            }
            
            do {
                let sealedBox = try AES.GCM.SealedBox(combined: data)
                let decryptedData = try AES.GCM.open(sealedBox, using: key)
                let object = try JSONDecoder().decode(T.self, from: decryptedData)
                completion(.success(object))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
