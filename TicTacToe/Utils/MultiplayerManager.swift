//
//  MultiplayerManager.swift
//  TicTacToe
//
//  Multiplayer foundation with GameCenter
//

import Foundation
import GameKit
import SwiftUI

class MultiplayerManager: NSObject, ObservableObject {
    static let shared = MultiplayerManager()
    
    @Published var isAuthenticated = false
    @Published var isMatchmaking = false
    @Published var currentMatch: GKMatch?
    @Published var localPlayer: GKLocalPlayer { GKLocalPlayer.local }
    
    override init() {
        super.init()
        authenticatePlayer()
    }
    
    // MARK: - GameCenter Authentication
    private func authenticatePlayer() {
        localPlayer.authenticateHandler = { viewController, error in
            DispatchQueue.main.async {
                if let viewController = viewController {
                    // Present authentication view controller
                    // This would be handled by the main app
                    print("Need to present authentication VC")
                } else if self.localPlayer.isAuthenticated {
                    self.isAuthenticated = true
                    print("Player authenticated: \(self.localPlayer.displayName)")
                    self.loadAchievements()
                } else if let error = error {
                    print("Authentication failed: \(error.localizedDescription)")
                    self.isAuthenticated = false
                }
            }
        }
    }
    
    // MARK: - Matchmaking
    func startMatchmaking() {
        guard isAuthenticated else {
            print("Player not authenticated")
            return
        }
        
        isMatchmaking = true
        
        let request = GKMatchRequest()
        request.minPlayers = 2
        request.maxPlayers = 2
        request.defaultNumberOfPlayers = 2
        
        GKMatchmaker.shared().findMatch(for: request) { match, error in
            DispatchQueue.main.async {
                self.isMatchmaking = false
                
                if let match = match {
                    self.currentMatch = match
                    match.delegate = self
                    print("Match found with \(match.players.count) players")
                } else if let error = error {
                    print("Matchmaking failed: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func cancelMatchmaking() {
        GKMatchmaker.shared().cancel()
        isMatchmaking = false
    }
    
    // MARK: - Game Data Transmission
    func sendGameMove(_ move: GameMove) {
        guard let match = currentMatch else { return }
        
        do {
            let data = try JSONEncoder().encode(move)
            try match.sendData(toAllPlayers: data, with: .reliable)
        } catch {
            print("Failed to send move: \(error)")
        }
    }
    
    func sendGameState(_ state: MultiplayerGameState) {
        guard let match = currentMatch else { return }
        
        do {
            let data = try JSONEncoder().encode(state)
            try match.sendData(toAllPlayers: data, with: .reliable)
        } catch {
            print("Failed to send game state: \(error)")
        }
    }
    
    // MARK: - Achievements & Leaderboards
    private func loadAchievements() {
        GKAchievement.loadAchievements { achievements, error in
            if let achievements = achievements {
                print("Loaded \(achievements.count) achievements")
            }
        }
    }
    
    func submitScore(_ score: Int, category: String) {
        guard isAuthenticated else { return }
        
        let scoreReporter = GKScore(leaderboardID: category)
        scoreReporter.value = Int64(score)
        
        GKScore.report([scoreReporter]) { error in
            if let error = error {
                print("Score submission failed: \(error.localizedDescription)")
            } else {
                print("Score submitted successfully")
            }
        }
    }
    
    func unlockAchievement(_ identifier: String, percentComplete: Double = 100.0) {
        guard isAuthenticated else { return }
        
        let achievement = GKAchievement(identifier: identifier)
        achievement.percentComplete = percentComplete
        achievement.showsCompletionBanner = true
        
        GKAchievement.report([achievement]) { error in
            if let error = error {
                print("Achievement unlock failed: \(error.localizedDescription)")
            } else {
                print("Achievement unlocked: \(identifier)")
            }
        }
    }
}

// MARK: - GKMatchDelegate
extension MultiplayerManager: GKMatchDelegate {
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        // Handle received game data
        if let move = try? JSONDecoder().decode(GameMove.self, from: data) {
            // Process opponent move
            NotificationCenter.default.post(
                name: .multiplayerMoveReceived,
                object: nil,
                userInfo: ["move": move, "player": player]
            )
        } else if let gameState = try? JSONDecoder().decode(MultiplayerGameState.self, from: data) {
            // Process game state update
            NotificationCenter.default.post(
                name: .multiplayerGameStateReceived,
                object: nil,
                userInfo: ["gameState": gameState, "player": player]
            )
        }
    }
    
    func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
        switch state {
        case .connected:
            print("Player \(player.displayName) connected")
        case .disconnected:
            print("Player \(player.displayName) disconnected")
            // Handle disconnection
            DispatchQueue.main.async {
                self.currentMatch = nil
            }
        default:
            break
        }
    }
    
    func match(_ match: GKMatch, didFailWithError error: Error?) {
        print("Match failed with error: \(error?.localizedDescription ?? "Unknown error")")
        DispatchQueue.main.async {
            self.currentMatch = nil
        }
    }
}

// MARK: - Multiplayer Data Models
struct GameMove: Codable {
    let position: Int
    let player: String // Player identifier
    let timestamp: Date
}

struct MultiplayerGameState: Codable {
    let board: [String?] // Board state
    let currentPlayer: String
    let gameStatus: String // "in_progress", "won", "draw"
    let winner: String?
    let timestamp: Date
}

// MARK: - Notification Extensions
extension Notification.Name {
    static let multiplayerMoveReceived = Notification.Name("multiplayerMoveReceived")
    static let multiplayerGameStateReceived = Notification.Name("multiplayerGameStateReceived")
}
