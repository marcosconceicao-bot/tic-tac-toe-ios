//
// ContentView.swift - Premium Integration Update
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: GameViewModel
    @EnvironmentObject var adManager: AdManager
    @ObservedObject var premiumManager = PremiumManager.shared
    @State private var showingShop = false
    @State private var showingDailyChallenge = false
    @State private var showingMultiplayer = false
    @State private var showingStatistics = false
    @State private var showingPremium = false
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(spacing: 20) {
                    // Header with premium status
                    HeaderViewPremium()
                    
                    // Premium banner (if not premium)
                    if !premiumManager.isPremium {
                        PremiumBannerView()
                    }
                    
                    // Daily Challenge Banner (if available)
                    DailyChallengeBanner()
                    
                    // Score display
                    ScoreView()
                    
                    // Game status
                    GameStatusView()
                    
                    // Game board
                    BoardView()
                        .frame(width: min(geometry.size.width - 40, 350))
                    
                    // Control buttons
                    ControlButtonsViewPremium()
                    
                    Spacer()
                    
                    // Banner ad (only if not premium)
                    if !premiumManager.isPremium && adManager.bannerLoaded {
                        AdBannerView()
                            .frame(height: 50)
                    }
                }
                .padding(.horizontal, 20)
                .navigationBarHidden(true)
            }
        }
        .sheet(isPresented: $viewModel.showingSettings) {
            SettingsView()
        }
        .sheet(isPresented: $showingPremium) {
            PremiumView()
        }
        .onReceive(NotificationCenter.default.publisher(for: .premiumPurchased)) { _ in
            // Celebrate premium purchase
            HapticFeedbackManager.shared.playSuccess()
            showingPremium = false
        }
    }
}

struct HeaderViewPremium: View {
    @EnvironmentObject var viewModel: GameViewModel
    @ObservedObject var coinManager = CoinManager.shared
    @ObservedObject var premiumManager = PremiumManager.shared
    @State private var showingPremium = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("🎮 Tic Tac Toe")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    if premiumManager.isPremium {
                        Image(systemName: "crown.fill")
                            .foregroundColor(.yellow)
                            .font(.title2)
                    }
                }
                
                if premiumManager.isPremium {
                    Text("Premium Member")
                        .font(.caption)
                        .foregroundColor(.yellow)
                }
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                // Coins display
                HStack(spacing: 4) {
                    Image(systemName: "dollarsign.circle.fill")
                        .foregroundColor(.yellow)
                    Text("\(coinManager.coins)")
                        .font(.headline.bold())
                    
                    if premiumManager.hasUnlimitedCoins {
                        Text("∞")
                            .font(.headline.bold())
                            .foregroundColor(.yellow)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.yellow.opacity(0.2))
                .cornerRadius(16)
                
                // Premium button (if not premium)
                if !premiumManager.isPremium {
                    Button(action: {
                        showingPremium = true
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "crown.fill")
                            Text("PRO")
                                .font(.caption.bold())
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            LinearGradient(
                                colors: [.purple, .blue],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                    }
                }
                
                // Settings
                Button(action: {
                    viewModel.showingSettings = true
                }) {
                    Image(systemName: "gearshape.fill")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.top, 10)
        .sheet(isPresented: $showingPremium) {
            PremiumView()
        }
    }
}

struct PremiumBannerView: View {
    @State private var showingPremium = false
    
    var body: some View {
        Button(action: {
            showingPremium = true
        }) {
            HStack {
                Image(systemName: "crown.fill")
                    .foregroundColor(.yellow)
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Upgrade to Premium")
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.white)
                    
                    Text("Remove ads & unlock exclusive features")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                Text("Try Free")
                    .font(.caption.bold())
                    .foregroundColor(.purple)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color.white)
                    .cornerRadius(12)
            }
            .padding()
            .background(
                LinearGradient(
                    colors: [.purple, .blue],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingPremium) {
            PremiumView()
        }
    }
}

struct ControlButtonsViewPremium: View {
    @EnvironmentObject var viewModel: GameViewModel
    @ObservedObject var premiumManager = PremiumManager.shared
    @State private var showingShop = false
    @State private var showingDailyChallenge = false
    @State private var showingMultiplayer = false
    @State private var showingStatistics = false
    @State private var showingPremium = false
    
    var body: some View {
        VStack(spacing: 16) {
            // Primary actions
            HStack(spacing: 20) {
                Button(action: {
                    viewModel.newGame()
                    
                    // Show interstitial ad sometimes (only for free users)
                    if !premiumManager.isPremium && Int.random(in: 1...3) == 1 {
                        AdManager.shared.showInterstitialAd()
                    }
                }) {
                    Label("New Game", systemImage: "play.fill")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                
                Button(action: {
                    viewModel.showingGameModeSelection = true
                }) {
                    Label("Mode", systemImage: "person.2.fill")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(12)
                }
            }
            
            // Secondary actions
            HStack(spacing: 12) {
                FeatureButtonPremium(
                    title: "Shop", 
                    icon: "cart.fill", 
                    color: .purple,
                    isPremium: false
                ) {
                    showingShop = true
                }
                
                FeatureButtonPremium(
                    title: "Challenges", 
                    icon: "target", 
                    color: .orange,
                    isPremium: false
                ) {
                    showingDailyChallenge = true
                }
                
                FeatureButtonPremium(
                    title: "Online", 
                    icon: "wifi", 
                    color: .blue,
                    isPremium: true
                ) {
                    if premiumManager.isPremium {
                        showingMultiplayer = true
                    } else {
                        showingPremium = true
                    }
                }
                
                FeatureButtonPremium(
                    title: "Stats", 
                    icon: "chart.bar.fill", 
                    color: .red,
                    isPremium: premiumManager.hasAdvancedStats
                ) {
                    if premiumManager.hasAdvancedStats || !premiumManager.isPremium {
                        showingStatistics = true
                    } else {
                        showingPremium = true
                    }
                }
            }
        }
        .sheet(isPresented: $showingShop) {
            ShopView()
        }
        .sheet(isPresented: $showingDailyChallenge) {
            DailyChallengeView()
        }
        .sheet(isPresented: $showingMultiplayer) {
            MultiplayerView()
        }
        .sheet(isPresented: $showingStatistics) {
            StatisticsView()
        }
        .sheet(isPresented: $showingPremium) {
            PremiumView()
        }
    }
}

struct FeatureButtonPremium: View {
    let title: String
    let icon: String
    let color: Color
    let isPremium: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack {
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(.white)
                    
                    if isPremium {
                        VStack {
                            HStack {
                                Spacer()
                                Image(systemName: "crown.fill")
                                    .font(.caption2)
                                    .foregroundColor(.yellow)
                                    .background(Color.white.opacity(0.8))
                                    .clipShape(Circle())
                            }
                            Spacer()
                        }
                    }
                }
                
                Text(title)
                    .font(.caption.weight(.medium))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(color)
            .cornerRadius(8)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(GameViewModel())
        .environmentObject(AdManager())
}
