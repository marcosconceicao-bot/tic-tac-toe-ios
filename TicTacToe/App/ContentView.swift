//
//  ContentView.swift
//  TicTacToe
//
//  Created by Marcos Conceição on 2026-02-12.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: GameViewModel
    @EnvironmentObject var adManager: AdManager
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(spacing: 20) {
                    // Header with title and settings
                    HeaderView()
                    
                    // Score display
                    ScoreView()
                    
                    // Game status
                    GameStatusView()
                    
                    // Game board
                    BoardView()
                        .frame(width: min(geometry.size.width - 40, 350))
                    
                    // Control buttons
                    ControlButtonsView()
                    
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
    }
}

struct HeaderView: View {
    @EnvironmentObject var viewModel: GameViewModel
    
    var body: some View {
        HStack {
            Text("🎮 Tic Tac Toe")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Spacer()
            
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

struct GameStatusView: View {
    @EnvironmentObject var viewModel: GameViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            Text(viewModel.gameEngine.gameState.displayMessage)
                .font(.headline)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
            if viewModel.gameEngine.gameState == .inProgress {
                Text("Current Player: \(viewModel.gameEngine.currentPlayer.symbol)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .animation(.easeInOut, value: viewModel.gameEngine.currentPlayer)
            }
            
            Text(viewModel.gameEngine.gameMode.displayName)
                .font(.caption)
                .foregroundColor(.secondary)
                .opacity(0.8)
        }
        .padding(.vertical, 8)
    }
}

struct ControlButtonsView: View {
    @EnvironmentObject var viewModel: GameViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 20) {
                Button(action: {
                    viewModel.newGame()
                }) {
                    Label("New Game", systemImage: "play.fill")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.blue)
                        )
                }
                
                Button(action: {
                    viewModel.showingGameModeSelection = true
                }) {
                    Label("Mode", systemImage: "person.2.fill")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.green)
                        )
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
    }
}

#Preview {
    ContentView()
        .environmentObject(GameViewModel())
        .environmentObject(AdManager())
}