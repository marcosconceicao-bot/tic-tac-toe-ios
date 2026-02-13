//
//  PremiumManager.swift
//  TicTacToe
//
//  Premium subscription and in-app purchase system
//

import Foundation
import StoreKit
import SwiftUI

class PremiumManager: NSObject, ObservableObject {
    static let shared = PremiumManager()
    
    // Product IDs - Configure these in App Store Connect
    private let adFreeProductID = "com.marcos.tictactoe.adfree"
    private let premiumMonthlyID = "com.marcos.tictactoe.premium.monthly"
    private let premiumYearlyID = "com.marcos.tictactoe.premium.yearly"
    private let coinPackSmallID = "com.marcos.tictactoe.coins.small"
    private let coinPackLargeID = "com.marcos.tictactoe.coins.large"
    
    @Published var isAdFreeUnlocked = false
    @Published var isPremiumSubscribed = false
    @Published var availableProducts: [SKProduct] = []
    @Published var isLoading = false
    @Published var purchaseError: String?
    
    // Premium features flags
    @Published var hasUnlimitedCoins = false
    @Published var hasAllThemes = false
    @Published var hasPremiumChallenges = false
    @Published var hasAdvancedStats = false
    
    private override init() {
        super.init()
        SKPaymentQueue.default().add(self)
        loadPremiumStatus()
        requestProducts()
    }
    
    // MARK: - Premium Status
    
    var isPremium: Bool {
        return isAdFreeUnlocked || isPremiumSubscribed
    }
    
    var shouldShowAds: Bool {
        return !isPremium
    }
    
    // MARK: - Product Requests
    
    private func requestProducts() {
        isLoading = true
        
        let productIDs: Set<String> = [
            adFreeProductID,
            premiumMonthlyID,
            premiumYearlyID,
            coinPackSmallID,
            coinPackLargeID
        ]
        
        let request = SKProductsRequest(productIdentifiers: productIDs)
        request.delegate = self
        request.start()
    }
    
    // MARK: - Purchase Methods
    
    func purchaseAdFree() {
        guard let product = availableProducts.first(where: { $0.productIdentifier == adFreeProductID }) else {
            purchaseError = "Ad-free product not available"
            return
        }
        
        purchase(product: product)
    }
    
    func purchasePremiumMonthly() {
        guard let product = availableProducts.first(where: { $0.productIdentifier == premiumMonthlyID }) else {
            purchaseError = "Premium monthly not available"
            return
        }
        
        purchase(product: product)
    }
    
    func purchasePremiumYearly() {
        guard let product = availableProducts.first(where: { $0.productIdentifier == premiumYearlyID }) else {
            purchaseError = "Premium yearly not available"
            return
        }
        
        purchase(product: product)
    }
    
    func purchaseCoinPack(isLarge: Bool = false) {
        let productID = isLarge ? coinPackLargeID : coinPackSmallID
        guard let product = availableProducts.first(where: { $0.productIdentifier == productID }) else {
            purchaseError = "Coin pack not available"
            return
        }
        
        purchase(product: product)
    }
    
    private func purchase(product: SKProduct) {
        guard SKPaymentQueue.canMakePayments() else {
            purchaseError = "Purchases are disabled on this device"
            return
        }
        
        isLoading = true
        purchaseError = nil
        
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    // MARK: - Restore Purchases
    
    func restorePurchases() {
        isLoading = true
        purchaseError = nil
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    // MARK: - Product Information
    
    func priceString(for productID: String) -> String {
        guard let product = availableProducts.first(where: { $0.productIdentifier == productID }) else {
            return "Loading..."
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        
        return formatter.string(from: product.price) ?? "\(product.price)"
    }
    
    func localizedTitle(for productID: String) -> String {
        guard let product = availableProducts.first(where: { $0.productIdentifier == productID }) else {
            return "Loading..."
        }
        return product.localizedTitle
    }
    
    func localizedDescription(for productID: String) -> String {
        guard let product = availableProducts.first(where: { $0.productIdentifier == productID }) else {
            return "Loading..."
        }
        return product.localizedDescription
    }
    
    // MARK: - Premium Features
    
    private func unlockPremiumFeatures() {
        hasUnlimitedCoins = true
        hasAllThemes = true
        hasPremiumChallenges = true
        hasAdvancedStats = true
        
        // Give premium welcome bonus
        CoinManager.shared.earnCoins(1000, reason: "Premium Welcome Bonus")
        
        // Unlock all shop items
        for item in ShopManager.shared.availableItems {
            if !ShopManager.shared.isPurchased(item) {
                ShopManager.shared.unlockItemForPremium(item)
            }
        }
    }
    
    // MARK: - Persistence
    
    private func savePremiumStatus() {
        UserDefaults.standard.set(isAdFreeUnlocked, forKey: "ad_free_unlocked")
        UserDefaults.standard.set(isPremiumSubscribed, forKey: "premium_subscribed")
        UserDefaults.standard.set(hasUnlimitedCoins, forKey: "unlimited_coins")
        UserDefaults.standard.set(hasAllThemes, forKey: "all_themes")
        UserDefaults.standard.set(hasPremiumChallenges, forKey: "premium_challenges")
        UserDefaults.standard.set(hasAdvancedStats, forKey: "advanced_stats")
    }
    
    private func loadPremiumStatus() {
        isAdFreeUnlocked = UserDefaults.standard.bool(forKey: "ad_free_unlocked")
        isPremiumSubscribed = UserDefaults.standard.bool(forKey: "premium_subscribed")
        hasUnlimitedCoins = UserDefaults.standard.bool(forKey: "unlimited_coins")
        hasAllThemes = UserDefaults.standard.bool(forKey: "all_themes")
        hasPremiumChallenges = UserDefaults.standard.bool(forKey: "premium_challenges")
        hasAdvancedStats = UserDefaults.standard.bool(forKey: "advanced_stats")
    }
}

// MARK: - SKProductsRequestDelegate
extension PremiumManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            self.availableProducts = response.products
            self.isLoading = false
            
            print("📦 Loaded \(response.products.count) products")
            
            for product in response.products {
                print("  - \(product.localizedTitle): \(product.price)")
            }
            
            if !response.invalidProductIdentifiers.isEmpty {
                print("❌ Invalid product IDs: \(response.invalidProductIdentifiers)")
            }
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.isLoading = false
            self.purchaseError = error.localizedDescription
            print("❌ Product request failed: \(error.localizedDescription)")
        }
    }
}

// MARK: - SKPaymentTransactionObserver
extension PremiumManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                handlePurchase(transaction: transaction)
            case .restored:
                handleRestore(transaction: transaction)
            case .failed:
                handleFailure(transaction: transaction)
            case .deferred:
                print("⏳ Payment deferred")
            case .purchasing:
                print("💳 Payment processing...")
            @unknown default:
                break
            }
        }
    }
    
    private func handlePurchase(transaction: SKPaymentTransaction) {
        let productID = transaction.payment.productIdentifier
        
        DispatchQueue.main.async {
            switch productID {
            case self.adFreeProductID:
                self.isAdFreeUnlocked = true
                print("✅ Ad-free unlocked!")
                
            case self.premiumMonthlyID, self.premiumYearlyID:
                self.isPremiumSubscribed = true
                self.unlockPremiumFeatures()
                print("✅ Premium subscription activated!")
                
            case self.coinPackSmallID:
                CoinManager.shared.earnCoins(500, reason: "Coin Pack Purchase")
                print("✅ Small coin pack purchased!")
                
            case self.coinPackLargeID:
                CoinManager.shared.earnCoins(2000, reason: "Large Coin Pack Purchase")
                print("✅ Large coin pack purchased!")
                
            default:
                print("❓ Unknown product purchased: \(productID)")
            }
            
            self.savePremiumStatus()
            self.isLoading = false
            
            // Show success notification
            NotificationCenter.default.post(
                name: .premiumPurchased,
                object: nil,
                userInfo: ["productID": productID]
            )
            
            // Analytics
            AnalyticsManager.shared.trackPremiumPurchase(productID: productID)
        }
        
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func handleRestore(transaction: SKPaymentTransaction) {
        handlePurchase(transaction: transaction)
        print("✅ Purchase restored: \(transaction.payment.productIdentifier)")
    }
    
    private func handleFailure(transaction: SKPaymentTransaction) {
        DispatchQueue.main.async {
            self.isLoading = false
            
            if let error = transaction.error as NSError?,
               error.code != SKError.paymentCancelled.rawValue {
                self.purchaseError = error.localizedDescription
                print("❌ Purchase failed: \(error.localizedDescription)")
            } else {
                print("🚫 Purchase cancelled by user")
            }
        }
        
        SKPaymentQueue.default().finishTransaction(transaction)
    }
}

// MARK: - ShopManager Extension for Premium
extension ShopManager {
    func unlockItemForPremium(_ item: ShopItem) {
        var premiumItem = item
        premiumItem.isPurchased = true
        
        if !purchasedItems.contains(where: { $0.id == item.id }) {
            purchasedItems.append(premiumItem)
        }
        
        savePurchases()
    }
}

// MARK: - Notification Extensions
extension Notification.Name {
    static let premiumPurchased = Notification.Name("premiumPurchased")
}
