//
//  MultiplayerView.swift
//  TicTacToe
//
//  Multiplayer interface
//

import SwiftUI
import GameKit

struct MultiplayerView: View {
    @ObservedObject var multiplayerManager = MultiplayerManager.shared
    @State private var showingGameCenterAuth = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                if !multiplayerManager.isAuthenticated {
                    // Authentication needed
                    GameCenterAuthView()
                } else if multiplayerManager.isMatchmaking {
                    // Matchmaking in progress
                    MatchmakingView()
                } else if multiplayerManager.currentMatch != nil {
                    // Game in progress
                    Text("Game in progress!")
                        .font(.title)
                    // TODO: Navigate to multiplayer game view
                } else {
                    // Ready to play
                    MultiplayerMenuView()
                }
            }
            .padding()
            .navigationTitle("Multiplayer")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct GameCenterAuthView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "gamecontroller.fill")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            Text("Connect to Game Center")
                .font(.title.bold())
            
            Text("Sign in to Game Center to play online with friends and track your achievements.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Sign In to Game Center") {
                // This would trigger GameCenter auth
                MultiplayerManager.shared.authenticatePlayer()
            }
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .cornerRadius(12)
        }
        .padding()
    }
}

struct MatchmakingView: View {
    @ObservedObject var multiplayerManager = MultiplayerManager.shared
    
    var body: some View {
        VStack(spacing: 24) {
            ProgressView()
                .scaleEffect(1.5)
            
            Text("Finding Opponent...")
                .font(.title2.bold())
            
            Text("Searching for another player to match with. This usually takes less than 30 seconds.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Cancel") {
                multiplayerManager.cancelMatchmaking()
            }
            .font(.subheadline)
            .foregroundColor(.red)
        }
        .padding()
    }
}

struct MultiplayerMenuView: View {
    @ObservedObject var multiplayerManager = MultiplayerManager.shared
    
    var body: some View {
        VStack(spacing: 20) {
            // Player info
            PlayerInfoCard()
            
            // Play options
            VStack(spacing: 16) {
                PlayButton(
                    title: "Quick Match",
                    description: "Find a random opponent",
                    icon: "bolt.fill",
                    color: .blue
                ) {
                    multiplayerManager.startMatchmaking()
                }
                
                PlayButton(
                    title: "Invite Friends",
                    description: "Play with Game Center friends",
                    icon: "person.2.fill",
                    color: .green
                ) {
                    // TODO: Implement friend invitation
                    print("Friend invitation not implemented yet")
                }
                
                PlayButton(
                    title: "Leaderboards",
                    description: "View global rankings",
                    icon: "chart.bar.fill",
                    color: .purple
                ) {
                    // TODO: Show leaderboards
                    print("Leaderboards not implemented yet")
                }
                
                PlayButton(
                    title: "Achievements",
                    description: "View Game Center achievements",
                    icon: "trophy.fill",
                    color: .yellow
                ) {
                    // TODO: Show GameCenter achievements
                    print("GameCenter achievements not implemented yet")
                }
            }
            
            Spacer()
        }
    }
}

struct PlayerInfoCard: View {
    @ObservedObject var multiplayerManager = MultiplayerManager.shared
    
    var body: some View {
        HStack {
            AsyncImage(url: nil) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.blue)
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(multiplayerManager.localPlayer.displayName)
                    .font(.headline)
                
                Text("Game Center Player")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
                .font(.title2)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.secondary.opacity(0.1))
        )
    }
}

struct PlayButton: View {
    let title: String
    let description: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(Circle().fill(color))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.secondary.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    MultiplayerView()
}
