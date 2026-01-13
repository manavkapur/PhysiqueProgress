//
//  SubscriptionViewModel.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 03/01/26.
//

import StoreKit

@MainActor
final class SubscriptionViewModel {
    
    private let manager = SubscriptionManager.shared
    
    var products: [Product] = []
    
    var onProductsLoaded: (() -> Void)?
    var onPurchaseSuccess: (() -> Void)?
    var onError: ((String) -> Void)?
    
    func loadProducts() {
        Task {
            do {
                try await manager.loadProducts()
                products = manager.products
                onProductsLoaded?()
            } catch {
                onError?(error.localizedDescription)
            }
        }
    }
    
    func purchase() {
        guard let product = products.first else { return }
        
        Task {
            do {
                let success = try await manager.purchase(product)
                if success {
                    if await manager.hasPremiumAccess() {
                        onPurchaseSuccess?()
                    }
                }

                
            } catch {
                onError?(error.localizedDescription)
            }
        }
    }
    
    func restore() {
        Task {
            await manager.restore()
            if await manager.hasPremiumAccess() {
                onPurchaseSuccess?()
            }

        }
    }
    
}
