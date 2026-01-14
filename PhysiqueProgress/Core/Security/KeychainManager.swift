//
//  KeychainManager.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 05/01/26.
//

import Security
import Foundation
import UIKit


final class KeychainManager {

    static let shared = KeychainManager()
    private init() {}

    func save(
        key: String,
        value: Data
    ) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: value,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]


        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }

    func read(key: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var data: AnyObject?
        SecItemCopyMatching(query as CFDictionary, &data)
        return data as? Data
    }

    func delete(key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)
    }
}
