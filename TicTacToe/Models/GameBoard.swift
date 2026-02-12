//
//  GameBoard.swift
//  TicTacToe
//
//  Created by Marcos Conceição on 2026-02-12.
//

import Foundation

struct GameBoard {
    private var board: [Player?] = Array(repeating: nil, count: 9)
    
    // MARK: - Public Properties
    var isEmpty: Bool {
        return board.allSatisfy { $0 == nil }
    }
    
    var isFull: Bool {
        return board.allSatisfy { $0 != nil }
    }
    
    var availableMoves: [Int] {
        return board.enumerated().compactMap { index, player in
            player == nil ? index : nil
        }
    }
    
    // MARK: - Public Methods
    func getPlayer(at position: Int) -> Player? {
        guard position >= 0 && position < 9 else { return nil }
        return board[position]
    }
    
    mutating func placePlayer(_ player: Player, at position: Int) -> Bool {
        guard position >= 0 && position < 9 && board[position] == nil else {
            return false
        }
        board[position] = player
        return true
    }
    
    mutating func reset() {
        board = Array(repeating: nil, count: 9)
    }
    
    func checkWinner() -> Player? {
        let winningCombinations = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
            [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
            [0, 4, 8], [2, 4, 6]             // Diagonals
        ]
        
        for combination in winningCombinations {
            let players = combination.map { board[$0] }
            if let player = players.first,
               players.allSatisfy({ $0 == player }) {
                return player
            }
        }
        
        return nil
    }
    
    func isDraw() -> Bool {
        return isFull && checkWinner() == nil
    }
    
    func getWinningPositions() -> [Int]? {
        let winningCombinations = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
            [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
            [0, 4, 8], [2, 4, 6]             // Diagonals
        ]
        
        for combination in winningCombinations {
            let players = combination.map { board[$0] }
            if let player = players.first,
               players.allSatisfy({ $0 == player }) {
                return combination
            }
        }
        
        return nil
    }
    
    // MARK: - AI Helper Methods
    func copy() -> GameBoard {
        var newBoard = GameBoard()
        newBoard.board = self.board
        return newBoard
    }
}