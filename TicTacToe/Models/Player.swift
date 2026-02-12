//
//  Player.swift
//  TicTacToe
//
//  Created by Marcos Conceição on 2026-02-12.
//

import Foundation

enum Player: String, CaseIterable {
    case x = "X"
    case o = "O"
    
    var symbol: String {
        return self.rawValue
    }
    
    var displayName: String {
        switch self {
        case .x:
            return "Player X"
        case .o:
            return "Player O"
        }
    }
    
    var opponent: Player {
        switch self {
        case .x:
            return .o
        case .o:
            return .x
        }
    }
}

enum GameMode {
    case playerVsPlayer
    case playerVsAI
    
    var displayName: String {
        switch self {
        case .playerVsPlayer:
            return "Player vs Player"
        case .playerVsAI:
            return "Player vs AI"
        }
    }
}

enum Difficulty: String, CaseIterable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    
    var description: String {
        switch self {
        case .easy:
            return "AI makes random moves"
        case .medium:
            return "AI plays defensively"
        case .hard:
            return "AI is unbeatable"
        }
    }
}