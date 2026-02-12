//
//  Extensions.swift
//  TicTacToe
//
//  Created by Marcos Conceição on 2026-02-12.
//

import SwiftUI
import Foundation

// MARK: - Color Extensions
extension Color {
    static let gameBackground = Color(.systemBackground)
    static let gameForeground = Color(.label)
    static let gameSecondary = Color(.secondaryLabel)
    static let gameTertiary = Color(.tertiaryLabel)
    
    // Custom game colors
    static let playerXColor = Color.red
    static let playerOColor = Color.blue
    static let winningColor = Color.green
    static let boardColor = Color.secondary.opacity(0.1)
    
    // Ad colors
    static let adBackground = Color.secondary.opacity(0.05)
}

// MARK: - View Extensions
extension View {
    func gameButtonStyle() -> some View {
        self
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.blue)
            )
    }
    
    func secondaryButtonStyle() -> some View {
        self
            .font(.subheadline)
            .foregroundColor(.blue)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.blue, lineWidth: 1)
            )
    }
    
    func cardStyle() -> some View {
        self
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.secondary.opacity(0.1))
            )
    }
}

// MARK: - String Extensions
extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

// MARK: - UserDefaults Extensions
extension UserDefaults {
    // Game settings keys
    static let soundEnabledKey = "soundEnabled"
    static let vibrationEnabledKey = "vibrationEnabled"
    static let totalGamesKey = "totalGames"
    static let playerXWinsKey = "playerXWins"
    static let playerOWinsKey = "playerOWins"
    static let drawsKey = "draws"
    static let lastPlayedModeKey = "lastPlayedMode"
    static let lastDifficultyKey = "lastDifficulty"
    
    // Convenience methods
    func gameScore() -> GameScore {
        var score = GameScore()
        score.playerXWins = integer(forKey: Self.playerXWinsKey)
        score.playerOWins = integer(forKey: Self.playerOWinsKey)
        score.draws = integer(forKey: Self.drawsKey)
        return score
    }
    
    func saveGameScore(_ score: GameScore) {
        set(score.playerXWins, forKey: Self.playerXWinsKey)
        set(score.playerOWins, forKey: Self.playerOWinsKey)
        set(score.draws, forKey: Self.drawsKey)
    }
    
    func resetGameData() {
        removeObject(forKey: Self.playerXWinsKey)
        removeObject(forKey: Self.playerOWinsKey)
        removeObject(forKey: Self.drawsKey)
        removeObject(forKey: Self.totalGamesKey)
    }
}

// MARK: - Animation Extensions
extension Animation {
    static let gameMove = Animation.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0)
    static let gameWin = Animation.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0)
    static let uiTransition = Animation.easeInOut(duration: 0.3)
}

// MARK: - Geometry Extensions
extension CGSize {
    static let boardCellSize = CGSize(width: 80, height: 80)
    static let boardSpacing: CGFloat = 8
    
    var boardSize: CGSize {
        let totalWidth = (Self.boardCellSize.width * 3) + (Self.boardSpacing * 2)
        let totalHeight = (Self.boardCellSize.height * 3) + (Self.boardSpacing * 2)
        return CGSize(width: totalWidth, height: totalHeight)
    }
}

// MARK: - Array Extensions
extension Array where Element == Int {
    func randomElement() -> Element? {
        guard !isEmpty else { return nil }
        let randomIndex = Int.random(in: 0..<count)
        return self[randomIndex]
    }
}

// MARK: - Bundle Extensions
extension Bundle {
    var appVersionString: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }
    
    var appBuildString: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
    }
    
    var appName: String {
        return infoDictionary?["CFBundleDisplayName"] as? String ?? "Tic Tac Toe"
    }
}