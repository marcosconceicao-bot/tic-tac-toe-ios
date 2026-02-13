//
//  PremiumView.swift
//  TicTacToe
//
//  Premium upgrade interface
//

import SwiftUI

struct PremiumView: View {
    @ObservedObject var premiumManager = PremiumManager.shared
    @State private var selectedOption: PremiumOption = .yearly
    @State private var showingRestoreAlert = false
    @State private var showingPurchaseSuccess = false
    @Environment(\.dismiss) private var dismiss
    
    enum PremiumOption: String, CaseIterable {
        case adFree = "ad_free"
        case monthly = "premium_monthly"
        case yearly = "premium_yearly"
        
        var title: String {
            switch self {
            case .adFree: return "Remove Ads"
            case .monthly: return "Premium Monthly"
            case .yearly: return "Premium Yearly"
            }
        }
        
        var subtitle: String {
            switch self {
            case .adFree: return "One-time purchase"
            case .monthly: return "Billed monthly"
            case .yearly: return "Best value - Save 60%"
            }
        }
        
        var features: [String] {
            switch self {
            case .adFree:
                return ["🚫 No more ads", "🎮 Uninterrupted gameplay"]
            case .monthly, .yearly:
                return [
                    "🚫 No ads",
                    "🪙 Unlimited coins",
                    "🎨 All themes unlocked",
                    "🎯 Premium challenges",
                    "📊 Advanced statistics",
                    "⚡ Priority support",
                    "🆕 Early access to features"
                ]
            }
        }
        
        var productID: String {
            switch self {
            case .adFree: return "com.marcos.tictactoe.adfree"
            case .monthly: return "com.marcos.tictactoe.premium.monthly"
            case .yearly: return "com.marcos.tictactoe.premium.yearly"
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    PremiumHeader()
                    
                    // Options
                    VStack(spacing: 16) {
                        ForEach(PremiumOption.allCases, id: \.self) { option in
                            PremiumOptionCard(
                                option: option,
                                isSelected: selectedOption == option,
                                onSelect: { selectedOption = option }
                            )
                        }
                    }
                    
                    // Purchase button
                    PurchaseButton(selectedOption: selectedOption)
                    
                    // Coin packs section
                    CoinPacksSection()
                    
                    // Features comparison
                    FeaturesComparisonView()
                    
                    // Legal text
                    LegalText()
                    
                    Spacer(minLength: 100)
                }
                .padding()
            }
            .navigationTitle("Upgrade to Premium")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Restore") {
                        premiumManager.restorePurchases()
                        showingRestoreAlert = true
                    }
                    .font(.subheadline)
                }
            }
            .alert("Purchase Successful! 🎉", isPresented: $showingPurchaseSuccess) {
                Button("Awesome!") {}
            } message: {
                Text("Thank you for upgrading to Premium! Enjoy your ad-free experience.")
            }
            .alert("Restore Complete", isPresented: $showingRestoreAlert) {
                Button("OK") {}
            } message: {
                Text("Your previous purchases have been restored.")
            }
            .onReceive(NotificationCenter.default.publisher(for: .premiumPurchased)) { _ in
                showingPurchaseSuccess = true
            }
        }
    }
}

struct PremiumHeader: View {
    var body: some View {
        VStack(spacing: 16) {
            // Premium icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.yellow, .orange],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                
                Image(systemName: "crown.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.white)
            }
            
            Text("Unlock Premium")
                .font(.largeTitle.bold())
            
            Text("Get the ultimate Tic Tac Toe experience with no ads and exclusive features")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
}

struct PremiumOptionCard: View {
    let option: PremiumView.PremiumOption
    let isSelected: Bool
    let onSelect: () -> Void
    @ObservedObject var premiumManager = PremiumManager.shared
    
    var body: some View {
        Button(action: onSelect) {
            VStack(alignment: .leading, spacing: 16) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(option.title)
                            .font(.headline.bold())
                            .foregroundColor(.primary)
                        
                        Text(option.subtitle)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text(premiumManager.priceString(for: option.productID))
                            .font(.title2.bold())
                            .foregroundColor(.primary)
                        
                        if option == .yearly {
                            Text("Save 60%")
                                .font(.caption)
                                .foregroundColor(.green)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(Color.green.opacity(0.2))
                                .cornerRadius(8)
                        }
                    }
                }
                
                // Features
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(option.features, id: \.self) { feature in
                        HStack {
                            Text(feature)
                                .font(.subheadline)
                                .foregroundColor(.primary)
                            Spacer()
                        }
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.secondary.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                isSelected ? Color.blue : Color.secondary.opacity(0.2),
                                lineWidth: isSelected ? 3 : 1
                            )
                    )
            )
            .overlay(
                // Selected indicator
                Group {
                    if isSelected {
                        HStack {
                            Spacer()
                            VStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                                    .background(Color.white)
                                    .clipShape(Circle())
                                Spacer()
                            }
                        }
                        .padding()
                    }
                }
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct PurchaseButton: View {
    let selectedOption: PremiumView.PremiumOption
    @ObservedObject var premiumManager = PremiumManager.shared
    
    var body: some View {
        Button(action: {
            switch selectedOption {
            case .adFree:
                premiumManager.purchaseAdFree()
            case .monthly:
                premiumManager.purchasePremiumMonthly()
            case .yearly:
                premiumManager.purchasePremiumYearly()
            }
        }) {
            HStack {
                if premiumManager.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                } else {
                    Image(systemName: "crown.fill")
                }
                
                Text(premiumManager.isLoading ? "Processing..." : "Upgrade Now")
                    .font(.headline.bold())
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                LinearGradient(
                    colors: [.blue, .purple],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(16)
        }
        .disabled(premiumManager.isLoading)
    }
}

struct CoinPacksSection: View {
    @ObservedObject var premiumManager = PremiumManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Need More Coins?")
                .font(.headline.bold())
            
            HStack(spacing: 16) {
                CoinPackCard(
                    title: "Small Pack",
                    coins: "500",
                    price: premiumManager.priceString(for: "com.marcos.tictactoe.coins.small"),
                    isLarge: false
                )
                
                CoinPackCard(
                    title: "Large Pack",
                    coins: "2,000",
                    price: premiumManager.priceString(for: "com.marcos.tictactoe.coins.large"),
                    isLarge: true
                )
            }
        }
    }
}

struct CoinPackCard: View {
    let title: String
    let coins: String
    let price: String
    let isLarge: Bool
    @ObservedObject var premiumManager = PremiumManager.shared
    
    var body: some View {
        Button(action: {
            premiumManager.purchaseCoinPack(isLarge: isLarge)
        }) {
            VStack(spacing: 8) {
                Image(systemName: "dollarsign.circle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.yellow)
                
                Text(title)
                    .font(.subheadline.bold())
                
                Text("\(coins) coins")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(price)
                    .font(.caption.bold())
                    .foregroundColor(.blue)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.secondary.opacity(0.05))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct FeaturesComparisonView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Feature Comparison")
                .font(.headline.bold())
            
            VStack(spacing: 12) {
                FeatureRow(feature: "Core Gameplay", free: true, premium: true)
                FeatureRow(feature: "Advertisements", free: true, premium: false)
                FeatureRow(feature: "Basic Themes", free: true, premium: true)
                FeatureRow(feature: "Daily Challenges", free: true, premium: true)
                FeatureRow(feature: "All Premium Themes", free: false, premium: true)
                FeatureRow(feature: "Unlimited Coins", free: false, premium: true)
                FeatureRow(feature: "Advanced Statistics", free: false, premium: true)
                FeatureRow(feature: "Premium Challenges", free: false, premium: true)
                FeatureRow(feature: "Priority Support", free: false, premium: true)
            }
        }
    }
}

struct FeatureRow: View {
    let feature: String
    let free: Bool
    let premium: Bool
    
    var body: some View {
        HStack {
            Text(feature)
                .font(.subheadline)
            
            Spacer()
            
            HStack(spacing: 24) {
                Image(systemName: free ? "checkmark" : "xmark")
                    .foregroundColor(free ? .green : .red)
                    .frame(width: 20)
                
                Image(systemName: premium ? "checkmark" : "xmark")
                    .foregroundColor(premium ? .green : .red)
                    .frame(width: 20)
            }
        }
    }
}

struct LegalText: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("• Subscriptions automatically renew unless cancelled")
            Text("• Payment charged to your Apple ID account")
            Text("• Manage subscriptions in your Account Settings")
            Text("• Cancel anytime to avoid future charges")
        }
        .font(.caption)
        .foregroundColor(.secondary)
        .multilineTextAlignment(.center)
    }
}

#Preview {
    PremiumView()
}
