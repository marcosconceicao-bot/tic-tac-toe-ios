//
//  DailyChallengeManager.swift
//  TicTacToe
//
//  Daily challenges for user retention
//

import Foundation
import SwiftUI
import UserNotifications

class DailyChallengeManager: ObservableObject {
    static let shared = DailyChallengeManager()
    
    @Published var todayChallenge: DailyChallenge?
    @Published var challengeProgress: Int = 0
    @Published var isCompleted: Bool = false
    @Published var streak: Int = 0
    
    private init() {
        loadTodayChallenge()
        loadStreak()
    }
    
    // MARK: - Challenge Generation
    private func generateTodayChallenge() -> DailyChallenge {
        let challenges = [
            DailyChallenge(
                id: "win_3_games",
                title: "Triple Threat",
                description: "Win 3 games today",
                requirement: 3,
                reward: 75,
                type: .wins,
                iconName: "star.fill"
            ),
            DailyChallenge(
                id: "beat_hard_ai",
                title: "AI Challenger",
                description: "Defeat the Hard AI once",
                requirement: 1,
                reward: 100,
                type: .hardAI,
                iconName: "cpu"
            ),
            DailyChallenge(
                id: "play_5_games",
                title: "Dedicated Player",
                description: "Play 5 games (win or lose)",
                requirement: 5,
                reward: 50,
                type: .gamesPlayed,
                iconName: "gamecontroller.fill"
            ),
            DailyChallenge(
                id: "quick_wins",
                title: "Speed Demon",
                description: "Win 2 games in under 30 seconds each",
                requirement: 2,
                reward: 125,
                type: .quickWins,
                iconName: "bolt.fill"
            ),
            DailyChallenge(
                id: "perfect_games",
                title: "Perfectionist",
                description: "Win without opponent scoring any moves",
                requirement: 1,
                reward: 150,
                type: .perfectGames,
                iconName: "target"
            ),
            DailyChallenge(
                id: "use_different_themes",
                title: "Style Explorer",
                description: "Play games with 3 different themes",
                requirement: 3,
                reward: 60,
                type: .themesUsed,
                iconName: "paintbrush.fill"
            ),
            DailyChallenge(
                id: "comeback_win",
                title: "Comeback King",
                description: "Win a game after being behind",
                requirement: 1,
                reward: 100,
                type: .comebackWins,
                iconName: "arrow.up.circle.fill"
            )
        ]
        
        // Rotate challenges based on day of year
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let challengeIndex = dayOfYear % challenges.count
        return challenges[challengeIndex]
    }
    
    // MARK: - Progress Tracking
    func updateProgress(for type: DailyChallengeType, amount: Int = 1) {
        guard let challenge = todayChallenge,
              challenge.type == type,
              !isCompleted else { return }
        
        challengeProgress += amount
        saveChallengeProgress()
        
        if challengeProgress >= challenge.requirement {
            completeChallenge()
        }
    }
    
    private func completeChallenge() {
        guard let challenge = todayChallenge else { return }
        
        isCompleted = true
        streak += 1
        
        // Award coins
        CoinManager.shared.earnCoins(challenge.reward, reason: "Daily Challenge")
        
        // Show completion notification
        NotificationCenter.default.post(
            name: .dailyChallengeCompleted,
            object: nil,
            userInfo: ["challenge": challenge]
        )
        
        // Schedule notification for tomorrow
        scheduleNotificationForTomorrow()
        
        // Save progress
        saveChallengeProgress()
        saveStreak()
        
        // Analytics
        AnalyticsManager.shared.trackDailyChallengeCompleted(challenge: challenge, streak: streak)
    }
    
    // MARK: - Data Management
    private func loadTodayChallenge() {
        let today = Calendar.current.startOfDay(for: Date())
        let savedDate = UserDefaults.standard.object(forKey: "last_challenge_date") as? Date ?? Date.distantPast
        
        if Calendar.current.isDate(today, inSameDayAs: savedDate) {
            // Load existing challenge for today
            if let data = UserDefaults.standard.data(forKey: "today_challenge"),
               let challenge = try? JSONDecoder().decode(DailyChallenge.self, from: data) {
                todayChallenge = challenge
                challengeProgress = UserDefaults.standard.integer(forKey: "challenge_progress")
                isCompleted = UserDefaults.standard.bool(forKey: "challenge_completed")
            }
        } else {
            // Generate new challenge for today
            todayChallenge = generateTodayChallenge()
            challengeProgress = 0
            isCompleted = false
            saveChallengeProgress()
            
            // Reset streak if missed a day (unless it's first time)
            if !Calendar.current.isDate(savedDate, inSameDayAs: today.addingTimeInterval(-86400)) {
                if savedDate != Date.distantPast { // Not first time
                    streak = 0
                    saveStreak()
                }
            }
            
            UserDefaults.standard.set(today, forKey: "last_challenge_date")
        }
    }
    
    private func saveChallengeProgress() {
        if let challenge = todayChallenge,
           let encoded = try? JSONEncoder().encode(challenge) {
            UserDefaults.standard.set(encoded, forKey: "today_challenge")
        }
        UserDefaults.standard.set(challengeProgress, forKey: "challenge_progress")
        UserDefaults.standard.set(isCompleted, forKey: "challenge_completed")
    }
    
    private func loadStreak() {
        streak = UserDefaults.standard.integer(forKey: "daily_challenge_streak")
    }
    
    private func saveStreak() {
        UserDefaults.standard.set(streak, forKey: "daily_challenge_streak")
    }
    
    // MARK: - Notifications
    private func scheduleNotificationForTomorrow() {
        let content = UNMutableNotificationContent()
        content.title = "New Daily Challenge!"
        content.body = "A fresh challenge is waiting for you. Come back and earn coins!"
        content.sound = .default
        
        // Schedule for 10 AM tomorrow
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        let components = Calendar.current.dateComponents([.year, .month, .day], from: tomorrow)
        var notificationComponents = components
        notificationComponents.hour = 10
        notificationComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: notificationComponents, repeats: false)
        let request = UNNotificationRequest(identifier: "daily_challenge", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}

// MARK: - Daily Challenge Model
struct DailyChallenge: Codable, Identifiable {
    let id: String
    let title: String
    let description: String
    let requirement: Int
    let reward: Int
    let type: DailyChallengeType
    let iconName: String
}

enum DailyChallengeType: String, Codable {
    case wins
    case hardAI
    case gamesPlayed
    case quickWins
    case perfectGames
    case themesUsed
    case comebackWins
}

// MARK: - Notification Extension
extension Notification.Name {
    static let dailyChallengeCompleted = Notification.Name("dailyChallengeCompleted")
}
