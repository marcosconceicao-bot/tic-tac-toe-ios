//
//  AIPlayer.swift
//  TicTacToe
//
//  Created by Marcos Conceição on 2026-02-12.
//

import Foundation

class AIPlayer {
    
    func getBestMove(board: GameBoard, player: Player, difficulty: Difficulty) -> Int? {
        let availableMoves = board.availableMoves
        guard !availableMoves.isEmpty else { return nil }
        
        switch difficulty {
        case .easy:
            return getRandomMove(availableMoves: availableMoves)
        case .medium:
            return getMediumMove(board: board, player: player, availableMoves: availableMoves)
        case .hard:
            return getMinimaxMove(board: board, player: player)
        }
    }
    
    // MARK: - Easy AI (Random moves)
    private func getRandomMove(availableMoves: [Int]) -> Int? {
        return availableMoves.randomElement()
    }
    
    // MARK: - Medium AI (Block opponent wins, make winning moves)
    private func getMediumMove(board: GameBoard, player: Player, availableMoves: [Int]) -> Int? {
        // First, check if AI can win
        if let winningMove = findWinningMove(board: board, player: player) {
            return winningMove
        }
        
        // Then, check if AI needs to block opponent
        let opponent = player.opponent
        if let blockingMove = findWinningMove(board: board, player: opponent) {
            return blockingMove
        }
        
        // Otherwise, prefer center, then corners, then edges
        let preferredMoves = [4, 0, 2, 6, 8, 1, 3, 5, 7]
        for move in preferredMoves {
            if availableMoves.contains(move) {
                return move
            }
        }
        
        return availableMoves.randomElement()
    }
    
    // MARK: - Hard AI (Minimax Algorithm)
    private func getMinimaxMove(board: GameBoard, player: Player) -> Int? {
        var bestScore = Int.min
        var bestMove: Int?
        
        for move in board.availableMoves {
            var boardCopy = board.copy()
            _ = boardCopy.placePlayer(player, at: move)
            
            let score = minimax(board: boardCopy, depth: 0, isMaximizing: false, player: player)
            
            if score > bestScore {
                bestScore = score
                bestMove = move
            }
        }
        
        return bestMove
    }
    
    private func minimax(board: GameBoard, depth: Int, isMaximizing: Bool, player: Player) -> Int {
        // Check terminal states
        if let winner = board.checkWinner() {
            if winner == player {
                return 10 - depth // Prefer faster wins
            } else {
                return depth - 10 // Minimize opponent wins
            }
        }
        
        if board.isDraw() {
            return 0
        }
        
        if isMaximizing {
            var maxEval = Int.min
            for move in board.availableMoves {
                var boardCopy = board.copy()
                _ = boardCopy.placePlayer(player, at: move)
                let eval = minimax(board: boardCopy, depth: depth + 1, isMaximizing: false, player: player)
                maxEval = max(maxEval, eval)
            }
            return maxEval
        } else {
            var minEval = Int.max
            let opponent = player.opponent
            for move in board.availableMoves {
                var boardCopy = board.copy()
                _ = boardCopy.placePlayer(opponent, at: move)
                let eval = minimax(board: boardCopy, depth: depth + 1, isMaximizing: true, player: player)
                minEval = min(minEval, eval)
            }
            return minEval
        }
    }
    
    // MARK: - Helper Methods
    private func findWinningMove(board: GameBoard, player: Player) -> Int? {
        for move in board.availableMoves {
            var boardCopy = board.copy()
            _ = boardCopy.placePlayer(player, at: move)
            
            if boardCopy.checkWinner() == player {
                return move
            }
        }
        return nil
    }
}