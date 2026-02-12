//
//  SettingsView.swift
//  TicTacToe
//
//  Created by Marcos Conceição on 2026-02-12.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: GameViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                // Audio Settings
                SettingsSection(title: "Audio") {
                    SettingsToggle(
                        title: "Sound Effects",
                        description: "Play sounds for moves and game events",
                        isOn: $viewModel.soundEnabled,
                        action: { viewModel.toggleSound() }
                    )
                }
                
                // Haptic Settings
                SettingsSection(title: "Haptics") {
                    SettingsToggle(
                        title: "Vibration",
                        description: "Haptic feedback for moves",
                        isOn: $viewModel.vibrationEnabled,
                        action: { viewModel.toggleVibration() }
                    )
                }
                
                // Game Info
                SettingsSection(title: "Game Info") {
                    VStack(alignment: .leading, spacing: 12) {
                        InfoRow(title: "Total Games", value: "\(viewModel.gameEngine.score.totalGames)")
                        InfoRow(title: "Current Mode", value: viewModel.gameEngine.gameMode.displayName)
                        if viewModel.gameEngine.gameMode == .playerVsAI {
                            InfoRow(title: "Difficulty", value: viewModel.gameEngine.difficulty.rawValue)
                        }
                    }
                }
                
                // About
                SettingsSection(title: "About") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Tic Tac Toe iOS")
                            .font(.headline)
                        Text("Version 1.0.0")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("Made with ❤️ by Marcos Conceição")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct SettingsSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            content
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.secondary.opacity(0.1))
                )
        }
    }
}

struct SettingsToggle: View {
    let title: String
    let description: String
    @Binding var isOn: Bool
    let action: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .onChange(of: isOn) { _, _ in
                    action()
                }
        }
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
        }
    }
}

struct GameModeSelectionView: View {
    @EnvironmentObject var viewModel: GameViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Choose Game Mode")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                VStack(spacing: 16) {
                    GameModeButton(
                        mode: .playerVsPlayer,
                        icon: "person.2.fill",
                        description: "Play against a friend locally"
                    ) {
                        viewModel.setGameMode(.playerVsPlayer)
                    }
                    
                    GameModeButton(
                        mode: .playerVsAI,
                        icon: "cpu",
                        description: "Challenge the AI with different difficulties"
                    ) {
                        viewModel.setGameMode(.playerVsAI)
                    }
                }
                .padding()
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct GameModeButton: View {
    let mode: GameMode
    let icon: String
    let description: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title)
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(Circle().fill(Color.blue))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(mode.displayName)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.secondary.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct DifficultySelectionView: View {
    @EnvironmentObject var viewModel: GameViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Choose Difficulty")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                VStack(spacing: 16) {
                    ForEach(Difficulty.allCases, id: \.self) { difficulty in
                        DifficultyButton(difficulty: difficulty) {
                            viewModel.setDifficulty(difficulty)
                        }
                    }
                }
                .padding()
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct DifficultyButton: View {
    let difficulty: Difficulty
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: difficultyIcon)
                    .font(.title)
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(Circle().fill(difficultyColor))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(difficulty.rawValue)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(difficulty.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.secondary.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(difficultyColor.opacity(0.5), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var difficultyIcon: String {
        switch difficulty {
        case .easy: return "tortoise.fill"
        case .medium: return "hare.fill"
        case .hard: return "bolt.fill"
        }
    }
    
    private var difficultyColor: Color {
        switch difficulty {
        case .easy: return .green
        case .medium: return .orange
        case .hard: return .red
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(GameViewModel())
}