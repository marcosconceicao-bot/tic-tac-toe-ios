//
//  GameEngine.swift
//  TicTacToe
//
//  Created by Marcos Conceição on 2026-02-12.
//

import Foundation

class GameEngine: ObservableObject {
    @Published var board = GameBoard()
    @Published var currentPlayer: Player = .x
    @Published var gameState: GameState = .notStarted
    @Published var gameMode: GameMode = .playerVsPlayer
    @Published var difficulty: Difficulty = .medium
    @Published var score = GameScore()
    
    private let aiPlayer = AIPlayer()
    private var isProcessingMove = false
    
    // MARK: - Public Methods
    func startNewGame() {
        board.reset()
        currentPlayer = .x
        gameState = .inProgress
        isProcessingMove = false
        
        // If it's AI mode and AI goes first, make AI move
        if gameMode == .playerVsAI && currentPlayer == .o {
            makeAIMove()
        }
    }
    
    func makeMove(at position: Int) {
        guard gameState == .inProgress && !isProcessingMove else { return }
        
        // Check if it's player's turn in AI mode
        if gameMode == .playerVsAI && currentPlayer == .o {
            return // It's AI's turn
        }
        
        if board.placePlayer(currentPlayer, at: position) {
            SoundManager.shared.playMoveSound()
            checkGameEnd()
            
            if !gameState.isGameOver {
                switchPlayer()
                
                // Make AI move if it's AI mode and now AI's turn
                if gameMode == .playerVsAI && currentPlayer == .o {
                    makeAIMove()
                }
            }
        }
    }
    
    func resetGame() {
        gameState = .notStarted
        board.reset()
        currentPlayer = .x
        isProcessingMove = false
    }
    
    func resetScore() {
        score.reset()
    }
    
    // MARK: - Private Methods
    private func makeAIMove() {
        guard gameMode == .playerVsAI && currentPlayer == .o else { return }
        
        isProcessingMove = true
        
        // Add slight delay for better UX
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            
            let aiMove = self.aiPlayer.getBestMove(
                board: self.board,
                player: .o,
                difficulty: self.difficulty
            )
            
            if let move = aiMove, self.board.placePlayer(.o, at: move) {
                SoundManager.shared.playMoveSound()
                self.checkGameEnd()
                
                if !self.gameState.isGameOver {
                    self.switchPlayer()
                }
            }
            
            self.isProcessingMove = false
        }
    }
    
    private func switchPlayer() {
        currentPlayer = currentPlayer.opponent
    }
    
    private func checkGameEnd() {
        if let winner = board.checkWinner() {
            gameState = .playerWon(winner)
            score.recordWin(for: winner)
            SoundManager.shared.playWinSound()
        } else if board.isDraw() {
            gameState = .draw
            score.recordDraw()
            SoundManager.shared.playDrawSound()
        }
    }
}