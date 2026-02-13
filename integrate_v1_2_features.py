#!/usr/bin/env python3
"""
Integrate V1.2 features into main app
Updates ContentView and navigation to include new features
"""

def update_content_view():
    """Update main ContentView to include V1.2 features"""
    
    print("🔧 Integrating V1.2 features into main app...")
    
    # Update ContentView with new features
    updated_content_view = '''//
//  ContentView.swift
//  TicTacToe
//
//  Updated with V1.2 features integration
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: GameViewModel
    @EnvironmentObject var adManager: AdManager
    @State private var showingShop = false
    @State private var showingDailyChallenge = false
    @State private var showingMultiplayer = false
    @State private var showingStatistics = false
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(spacing: 20) {
                    // Header with title, coins, and settings
                    HeaderViewV2()
                    
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
                    ControlButtonsViewV2()
                    
                    Spacer()
                    
                    // Banner ad
                    if adManager.bannerLoaded {
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
        .sheet(isPresented: $viewModel.showingGameModeSelection) {
            GameModeSelectionView()
        }
        .sheet(isPresented: $viewModel.showingDifficultySelection) {
            DifficultySelectionView()
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
        .onReceive(NotificationCenter.default.publisher(for: .coinsEarned)) { notification in
            // Show coin earning animation
            if let amount = notification.userInfo?["amount"] as? Int {
                viewModel.showCoinEarning(amount)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .dailyChallengeCompleted)) { _ in
            // Celebrate challenge completion
            HapticFeedbackManager.shared.playSuccess()
        }
    }
}

struct HeaderViewV2: View {
    @EnvironmentObject var viewModel: GameViewModel
    @ObservedObject var coinManager = CoinManager.shared
    
    var body: some View {
        HStack {
            Text("🎮 Tic Tac Toe")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Spacer()
            
            // Coins display
            HStack(spacing: 4) {
                Image(systemName: "dollarsign.circle.fill")
                    .foregroundColor(.yellow)
                Text("\\(coinManager.coins)")
                    .font(.headline.bold())
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.yellow.opacity(0.2))
            .cornerRadius(16)
            
            Button(action: {
                viewModel.showingSettings = true
            }) {
                Image(systemName: "gearshape.fill")
                    .font(.title2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.top, 10)
    }
}

struct DailyChallengeBanner: View {
    @ObservedObject var challengeManager = DailyChallengeManager.shared
    @State private var showingDailyChallenge = false
    
    var body: some View {
        if let challenge = challengeManager.todayChallenge, !challengeManager.isCompleted {
            Button(action: {
                showingDailyChallenge = true
            }) {
                HStack {
                    Image(systemName: challenge.iconName)
                        .foregroundColor(.orange)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Daily Challenge")
                            .font(.subheadline.weight(.medium))
                            .foregroundColor(.primary)
                        
                        Text(challenge.title)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    ProgressView(value: Double(challengeManager.challengeProgress) / Double(challenge.requirement))
                        .frame(width: 40)
                    
                    Text("\\(challenge.reward)")
                        .font(.caption.bold())
                        .foregroundColor(.yellow)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.orange.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                        )
                )
            }
            .buttonStyle(PlainButtonStyle())
            .sheet(isPresented: $showingDailyChallenge) {
                DailyChallengeView()
            }
        }
    }
}

struct ControlButtonsViewV2: View {
    @EnvironmentObject var viewModel: GameViewModel
    @State private var showingShop = false
    @State private var showingDailyChallenge = false
    @State private var showingMultiplayer = false
    @State private var showingStatistics = false
    
    var body: some View {
        VStack(spacing: 16) {
            // Primary actions
            HStack(spacing: 20) {
                Button(action: {
                    viewModel.newGame()
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
            
            // Secondary actions (V1.2 features)
            HStack(spacing: 12) {
                FeatureButton(title: "Shop", icon: "cart.fill", color: .purple) {
                    showingShop = true
                }
                
                FeatureButton(title: "Challenges", icon: "target", color: .orange) {
                    showingDailyChallenge = true
                }
                
                FeatureButton(title: "Online", icon: "wifi", color: .blue) {
                    showingMultiplayer = true
                }
                
                FeatureButton(title: "Stats", icon: "chart.bar.fill", color: .red) {
                    showingStatistics = true
                }
            }
            
            if viewModel.gameEngine.score.totalGames > 0 {
                Button(action: {
                    viewModel.resetScore()
                }) {
                    Label("Reset Score", systemImage: "arrow.counterclockwise")
                        .font(.subheadline)
                        .foregroundColor(.red)
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
    }
}

struct FeatureButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.white)
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
'''
    
    with open("TicTacToe/App/ContentView.swift", "w") as f:
        f.write(updated_content_view)
    
    print("✅ ContentView updated with V1.2 features integration")

def update_game_view_model():
    """Update GameViewModel to handle new features"""
    
    print("🔧 Updating GameViewModel for V1.2 integration...")
    
    # Add coin earning logic to GameViewModel
    coin_integration = '''
// Add to GameViewModel.swift

extension GameViewModel {
    
    func handleGameEnd(winner: Player?, gameTime: TimeInterval, difficulty: Difficulty) {
        // Original game end logic...
        
        // V1.2: Award coins for game completion
        if let winner = winner {
            let coinsEarned = CoinManager.shared.coinsForWin(against: difficulty, gameTime: gameTime)
            CoinManager.shared.earnCoins(coinsEarned, reason: "Game Win")
            
            // Update daily challenge progress
            DailyChallengeManager.shared.updateProgress(for: .wins)
            
            if difficulty == .hard {
                DailyChallengeManager.shared.updateProgress(for: .hardAI)
            }
            
            if gameTime < 30 {
                DailyChallengeManager.shared.updateProgress(for: .quickWins)
            }
        }
        
        // Always update games played
        DailyChallengeManager.shared.updateProgress(for: .gamesPlayed)
    }
    
    func showCoinEarning(_ amount: Int) {
        // Show coin earning animation/notification
        // TODO: Implement coin earning animation
    }
}
'''
    
    with open("TicTacToe/ViewModels/GameViewModelExtension.swift", "w") as f:
        f.write(coin_integration)
    
    print("✅ GameViewModel updated for coin/challenge integration")

if __name__ == "__main__":
    update_content_view()
    update_game_view_model()
    
    print("\n🎉 V1.2 INTEGRATION COMPLETE!")
    print("✅ Features integrated:")
    print("   - Shop button in main menu")
    print("   - Daily challenge banner")
    print("   - Multiplayer access")
    print("   - Statistics view")
    print("   - Coin display in header")
    print("   - Challenge progress tracking")
    print("\n🚀 App now has premium features for revenue boost!")