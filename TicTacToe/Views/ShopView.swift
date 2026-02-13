//
//  ShopView.swift
//  TicTacToe
//
//  Virtual shop interface
//

import SwiftUI

struct ShopView: View {
    @ObservedObject var coinManager = CoinManager.shared
    @ObservedObject var shopManager = ShopManager.shared
    @State private var selectedCategory: ShopItem.ShopCategory = .themes
    @State private var showingInsufficientFunds = false
    @State private var showingPurchaseSuccess = false
    @State private var purchasedItemName = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Coin display header
                CoinHeader()
                
                // Category picker
                CategoryPicker(selectedCategory: $selectedCategory)
                
                // Shop items
                ShopItemGrid(
                    category: selectedCategory,
                    onPurchase: handlePurchase
                )
            }
            .navigationTitle("Shop")
            .navigationBarTitleDisplayMode(.large)
            .alert("Insufficient Coins", isPresented: $showingInsufficientFunds) {
                Button("Watch Ad for 25 Coins") {
                    // TODO: Show rewarded ad
                    coinManager.earnCoins(25, reason: "Watched Ad")
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("You don't have enough coins for this purchase. Watch an ad to earn more coins!")
            }
            .alert("Purchase Successful!", isPresented: $showingPurchaseSuccess) {
                Button("Awesome!") {}
            } message: {
                Text("You've successfully purchased \(purchasedItemName)!")
            }
        }
    }
    
    private func handlePurchase(_ item: ShopItem) {
        if shopManager.purchaseItem(item) {
            purchasedItemName = item.name
            showingPurchaseSuccess = true
            HapticFeedbackManager.shared.playSuccess()
        } else {
            showingInsufficientFunds = true
            HapticFeedbackManager.shared.playError()
        }
    }
}

struct CoinHeader: View {
    @ObservedObject var coinManager = CoinManager.shared
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "dollarsign.circle.fill")
                        .foregroundColor(.yellow)
                        .font(.title2)
                    
                    Text("\(coinManager.coins)")
                        .font(.title.bold())
                        .foregroundColor(.primary)
                    
                    Text("coins")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Text("Total earned: \(coinManager.totalCoinsEarned)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: {
                // TODO: Show rewarded ad for coins
                coinManager.earnCoins(25, reason: "Watched Ad")
            }) {
                HStack {
                    Image(systemName: "play.rectangle.fill")
                    Text("Free Coins")
                        .font(.subheadline.weight(.medium))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.green)
                .cornerRadius(20)
            }
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
    }
}

struct CategoryPicker: View {
    @Binding var selectedCategory: ShopItem.ShopCategory
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(ShopItem.ShopCategory.allCases, id: \.self) { category in
                    CategoryTab(
                        category: category,
                        isSelected: category == selectedCategory
                    ) {
                        withAnimation(.easeInOut) {
                            selectedCategory = category
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct CategoryTab: View {
    let category: ShopItem.ShopCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(category.rawValue)
                .font(.subheadline.weight(.medium))
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color.blue : Color.secondary.opacity(0.1))
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ShopItemGrid: View {
    let category: ShopItem.ShopCategory
    let onPurchase: (ShopItem) -> Void
    @ObservedObject var shopManager = ShopManager.shared
    
    private var filteredItems: [ShopItem] {
        shopManager.availableItems.filter { $0.category == category }
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                ForEach(filteredItems) { item in
                    ShopItemCard(item: item, onPurchase: onPurchase)
                }
            }
            .padding()
        }
    }
}

struct ShopItemCard: View {
    let item: ShopItem
    let onPurchase: (ShopItem) -> Void
    @ObservedObject var coinManager = CoinManager.shared
    @ObservedObject var shopManager = ShopManager.shared
    
    private var isPurchased: Bool {
        shopManager.isPurchased(item)
    }
    
    private var canAfford: Bool {
        coinManager.canAfford(item.price)
    }
    
    var body: some View {
        VStack(spacing: 12) {
            // Icon
            Image(systemName: item.iconName)
                .font(.system(size: 40))
                .foregroundColor(isPurchased ? .green : .blue)
                .frame(height: 60)
            
            // Name and description
            VStack(spacing: 4) {
                Text(item.name)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                
                Text(item.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            
            Spacer()
            
            // Purchase button
            Button(action: {
                if !isPurchased {
                    onPurchase(item)
                }
            }) {
                if isPurchased {
                    HStack {
                        Image(systemName: "checkmark")
                        Text("Owned")
                    }
                    .foregroundColor(.green)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                } else {
                    HStack {
                        Image(systemName: "dollarsign.circle")
                        Text("\(item.price)")
                    }
                    .foregroundColor(canAfford ? .white : .secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(canAfford ? Color.blue : Color.secondary.opacity(0.3))
                    .cornerRadius(8)
                }
            }
            .disabled(isPurchased || !canAfford)
        }
        .padding()
        .frame(height: 200)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.secondary.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isPurchased ? Color.green : Color.secondary.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

#Preview {
    ShopView()
}
