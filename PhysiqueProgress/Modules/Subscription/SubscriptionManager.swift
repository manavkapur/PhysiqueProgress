//
//  SubscriptionManager.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 05/01/26.
//

import StoreKit

enum PurchaseError: Error {
    case failedVerification
}


@MainActor
final class SubscriptionManager {

    static let shared = SubscriptionManager()

    private let productIDs = [
        "com.physiqueprogress.premium.monthly"
    ]

    private(set) var products: [Product] = []

    // Load products from App Store
    func loadProducts() async throws {
        products = try await Product.products(for: productIDs)
    }

    // Purchase flow
    func purchase(_ product: Product) async throws -> Bool {
        let result = try await product.purchase()

        switch result {
        case .success(let verification):
            let transaction = try verify(verification)
            await transaction.finish()
            return true

        case .userCancelled, .pending:
            return false

        default:
            return false
        }
    }

    // 🔑 Source of truth
    func hasPremiumAccess() async -> Bool {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result,
               productIDs.contains(transaction.productID),
               transaction.revocationDate == nil {
                return true
            }
        }
        return false
    }

    // Restore purchases
    func restore() async {
        for await _ in Transaction.currentEntitlements { }
    }

    // Verification helper
    private func verify<T>(
        _ result: VerificationResult<T>
    ) throws -> T {
        switch result {
        case .verified(let safe):
            return safe
        case .unverified:
            throw PurchaseError.failedVerification
        }
    }
}
