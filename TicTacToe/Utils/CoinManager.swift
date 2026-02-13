//
//  CoinManager.swift
//  TicTacToe
//
//  Virtual currency and economy system
//

import Foundation
import SwiftUI

class CoinManager: ObservableObject {
    static let shared = CoinManager()
    
    @Published var coins: Int = 0 {
        didSet {
            saveCoins()
        }
    }
    
    @Published var totalCoinsEarned: Int = 0
    
    private init() {
        loadCoins()
    }
    
    // MARK: - Coin Operations
    func earnCoins(_ amount: Int, reason: String = "Game Win") {
        coins += amount
        totalCoinsEarned += amount
        
        // Show earning notification
        NotificationCenter.default.post(
            name: .coinsEarned,
            object: nil,
            userInfo: ["amount": amount, "reason": reason]
        )
        
        // Track for analytics
        AnalyticsManager.shared.trackCoinEarned(amount: amount, reason: reason)
    }
    
    func spendCoins(_ amount: Int, on item: String) -> Bool {
        guard coins >= amount else {
            return false // Insufficient funds
        }
        
        coins -= amount
        
        // Track spending
        AnalyticsManager.shared.trackCoinSpent(amount: amount, item: item)
        
        return true
    }
    
    func canAfford(_ amount: Int) -> Bool {
        return coins >= amount
    }
    
    // MARK: - Earning Calculations
    func coinsForWin(against difficulty: Difficulty, gameTime: TimeInterval) -> Int {
        var baseCoins = 10
        
        // Bonus for difficulty
        switch difficulty {
        case .easy:
            baseCoins += 5
        case .medium:
            baseCoins += 10
        case .hard:
            baseCoins += 20
        }
        
        // Speed bonus
        if gameTime < 30 {
            baseCoins += 10 // Quick win bonus
        } else if gameTime < 60 {
            baseCoins += 5 // Good time bonus
        }
        
        return baseCoins
    }
    
    func coinsForAchievement(_ achievement: Achievement) -> Int {
        // Different achievements give different coin rewards
        switch achievement.name {
        case "First Victory": return 50
        case "Getting Good": return 100
        case "Expert Player": return 200
        case "AI Slayer": return 150
        case "Perfect Game": return 100
        case "Quick Draw": return 75
        default: return 25
        }
    }
    
    // MARK: - Persistence
    private func saveCoins() {
        UserDefaults.standard.set(coins, forKey: "user_coins")
        UserDefaults.standard.set(totalCoinsEarned, forKey: "total_coins_earned")
    }
    
    private func loadCoins() {
        coins = UserDefaults.standard.integer(forKey: "user_coins")
        totalCoinsEarned = UserDefaults.standard.integer(forKey: "total_coins_earned")
        
        // Give welcome bonus for new users
        if totalCoinsEarned == 0 {
            earnCoins(100, reason: "Welcome Bonus")
        }
    }
}

// MARK: - Shop Items
struct ShopItem: Identifiable, Codable {
    let id = UUID()
    let name: String
    let description: String
    let price: Int
    let category: ShopCategory
    let iconName: String
    var isPurchased: Bool = false
    
    enum ShopCategory: String, CaseIterable {
        case themes = "Themes"
        case symbols = "Symbols"
        case effects = "Effects"
        case powerups = "Power-ups"
    }
}

// MARK: - Shop Manager
class ShopManager: ObservableObject {
    static let shared = ShopManager()
    
    @Published var availableItems: [ShopItem] = []
    @Published var purchasedItems: [ShopItem] = []
    
    private init() {
        createShopItems()
        loadPurchases()
    }
    
    private func createShopItems() {
        availableItems = [
            // Premium Themes
            ShopItem(
                name: "Galaxy Theme",
                description: "Cosmic dark theme with stars",
                price: 200,
                category: .themes,
                iconName: "star.fill"
            ),
            ShopItem(
                name: "Ocean Theme",
                description: "Calm blue ocean vibes",
                price: 150,
                category: .themes,
                iconName: "drop.fill"
            ),
            ShopItem(
                name: "Forest Theme",
                description: "Natural green forest theme",
                price: 150,
                category: .themes,
                iconName: "leaf.fill"
            ),
            
            // Custom Symbols
            ShopItem(
                name: "Emoji Symbols",
                description: "Use 😊 and 😎 instead of X and O",
                price: 100,
                category: .symbols,
                iconName: "face.smiling"
            ),
            ShopItem(
                name: "Heart Symbols",
                description: "Use ❤️ and 💙 for a loving game",
                price: 75,
                category: .symbols,
                iconName: "heart.fill"
            ),
            ShopItem(
                name: "Gaming Symbols",
                description: "Use 🎮 and ⚡ for gamers",
                price: 125,
                category: .symbols,
                iconName: "gamecontroller.fill"
            ),
            
            // Effects
            ShopItem(
                name: "Particle Effects",
                description: "Winning celebrations with particles",
                price: 300,
                category: .effects,
                iconName: "sparkles"
            ),
            ShopItem(
                name: "Sound Pack Pro",
                description: "Premium sound effects collection",
                price: 250,
                category: .effects,
                iconName: "speaker.wave.3.fill"
            ),
            
            // Power-ups (for future use)
            ShopItem(
                name: "Hint System",
                description: "Get hints for your next move",
                price: 50,
                category: .powerups,
                iconName: "lightbulb.fill"
            ),
            ShopItem(
                name: "Undo Move",
                description: "Take back your last move",
                price: 25,
                category: .powerups,
                iconName: "arrow.uturn.left"
            )
        ]
    }
    
    func purchaseItem(_ item: ShopItem) -> Bool {
        guard CoinManager.shared.canAfford(item.price) else {
            return false
        }
        
        guard CoinManager.shared.spendCoins(item.price, on: item.name) else {
            return false
        }
        
        // Add to purchased items
        var purchasedItem = item
        purchasedItem.isPurchased = true
        purchasedItems.append(purchasedItem)
        
        // Remove from available or mark as purchased
        if let index = availableItems.firstIndex(where: { $0.id == item.id }) {
            availableItems[index].isPurchased = true
        }
        
        savePurchases()
        return true
    }
    
    func isPurchased(_ item: ShopItem) -> Bool {
        return purchasedItems.contains { $0.id == item.id }
    }
    
    private func savePurchases() {
        if let encoded = try? JSONEncoder().encode(purchasedItems) {
            UserDefaults.standard.set(encoded, forKey: "purchased_items")
        }
    }
    
    private func loadPurchases() {
        if let data = UserDefaults.standard.data(forKey: "purchased_items"),
           let decoded = try? JSONDecoder().decode([ShopItem].self, from: data) {
            purchasedItems = decoded
            
            // Update available items to reflect purchases
            for purchasedItem in purchasedItems {
                if let index = availableItems.firstIndex(where: { $0.id == purchasedItem.id }) {
                    availableItems[index].isPurchased = true
                }
            }
        }
    }
}

// MARK: - Notification Extension
extension Notification.Name {
    static let coinsEarned = Notification.Name("coinsEarned")
}
