//
//  GameState.swift
//  TicTacToe
//
//  Created by Marcos Conceição on 2026-02-12.
//

import Foundation

enum GameState {
    case notStarted
    case inProgress
    case playerWon(Player)
    case draw
    case paused
    
    var isGameOver: Bool {
        switch self {
        case .playerWon, .draw:
            return true
        case .notStarted, .inProgress, .paused:
            return false
        }
    }
    
    var displayMessage: String {
        switch self {
        case .notStarted:
            return "Tap to start playing!"
        case .inProgress:
            return "Game in progress"
        case .playerWon(let player):
            return "\(player.displayName) Wins! 🎉"
        case .draw:
            return "It's a Draw! 🤝"
        case .paused:
            return "Game Paused"
        }
    }
}

struct GameScore {
    var playerXWins: Int = 0
    var playerOWins: Int = 0
    var draws: Int = 0
    
    var totalGames: Int {
        return playerXWins + playerOWins + draws
    }
    
    mutating func reset() {
        playerXWins = 0
        playerOWins = 0
        draws = 0
    }
    
    mutating func recordWin(for player: Player) {
        switch player {
        case .x:
            playerXWins += 1
        case .o:
            playerOWins += 1
        }
    }
    
    mutating func recordDraw() {
        draws += 1
    }
}