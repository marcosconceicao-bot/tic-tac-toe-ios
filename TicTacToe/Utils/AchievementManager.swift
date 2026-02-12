//
//  AchievementManager.swift
//  TicTacToe
//
//  Achievement system for gamification
//

import Foundation
import SwiftUI

// MARK: - Achievement Model
struct Achievement: Identifiable, Codable {
    let id = UUID()
    let name: String
    let description: String
    let iconName: String
    let requirement: Int
    var isUnlocked: Bool = false
    var progress: Int = 0
    
    var progressPercentage: Double {
        return min(Double(progress) / Double(requirement), 1.0)
    }
}

// MARK: - Achievement Manager
class AchievementManager: ObservableObject {
    static let shared = AchievementManager()
    
    @Published var achievements: [Achievement] = []
    @Published var recentUnlock: Achievement?
    
    private init() {
        loadAchievements()
    }
    
    private func createDefaultAchievements() -> [Achievement] {
        return [
            Achievement(name: "First Victory", description: "Win your first game", iconName: "trophy.fill", requirement: 1),
            Achievement(name: "Getting Good", description: "Win 10 games", iconName: "star.fill", requirement: 10),
            Achievement(name: "Expert Player", description: "Win 50 games", iconName: "crown.fill", requirement: 50),
            Achievement(name: "AI Slayer", description: "Beat Hard AI", iconName: "cpu", requirement: 1),
            Achievement(name: "Perfect Game", description: "Win without opponent getting any moves", iconName: "target", requirement: 1),
            Achievement(name: "Quick Draw", description: "Win in under 30 seconds", iconName: "stopwatch.fill", requirement: 1),
            Achievement(name: "Comeback Kid", description: "Win from a losing position", iconName: "arrow.up.circle.fill", requirement: 1),
            Achievement(name: "Speedster", description: "Play 100 games", iconName: "flame.fill", requirement: 100),
            Achievement(name: "Dedicated", description: "Play 7 days in a row", iconName: "calendar", requirement: 7),
            Achievement(name: "Social Butterfly", description: "Win 10 multiplayer games", iconName: "person.2.fill", requirement: 10),
            Achievement(name: "Perfectionist", description: "Get 90% win rate over 20 games", iconName: "checkmark.seal.fill", requirement: 1),
            Achievement(name: "Theme Collector", description: "Try all 5 themes", iconName: "paintbrush.fill", requirement: 5),
            Achievement(name: "Achievement Hunter", description: "Unlock 10 achievements", iconName: "rosette", requirement: 10),
            Achievement(name: "Tic Tac Master", description: "Unlock all achievements", iconName: "diamond.fill", requirement: 1),
            Achievement(name: "Centurion", description: "Win 100 games", iconName: "100.circle.fill", requirement: 100)
        ]
    }
    
    func updateProgress(for achievementName: String, increment: Int = 1) {
        guard let index = achievements.firstIndex(where: { $0.name == achievementName }) else { return }
        
        if !achievements[index].isUnlocked {
            achievements[index].progress += increment
            
            if achievements[index].progress >= achievements[index].requirement {
                achievements[index].isUnlocked = true
                recentUnlock = achievements[index]
                saveAchievements()
                
                // Show unlock notification
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    HapticFeedbackManager.shared.playSuccess()
                }
            } else {
                saveAchievements()
            }
        }
    }
    
    func checkGameEndAchievements(winner: Player?, gameStats: GameStats) {
        if winner != nil {
            updateProgress(for: "First Victory")
            updateProgress(for: "Getting Good")
            updateProgress(for: "Expert Player")
            updateProgress(for: "Speedster")
            updateProgress(for: "Centurion")
            
            // Quick win check
            if gameStats.gameDuration < 30 {
                updateProgress(for: "Quick Draw")
            }
            
            // Perfect game check
            if gameStats.opponentMoves == 0 {
                updateProgress(for: "Perfect Game")
            }
        }
    }
    
    private func loadAchievements() {
        if let data = UserDefaults.standard.data(forKey: "achievements"),
           let decoded = try? JSONDecoder().decode([Achievement].self, from: data) {
            achievements = decoded
        } else {
            achievements = createDefaultAchievements()
            saveAchievements()
        }
    }
    
    private func saveAchievements() {
        if let encoded = try? JSONEncoder().encode(achievements) {
            UserDefaults.standard.set(encoded, forKey: "achievements")
        }
    }
}

// MARK: - Game Statistics Helper
struct GameStats {
    let gameDuration: TimeInterval
    let opponentMoves: Int
    let playerMoves: Int
}
