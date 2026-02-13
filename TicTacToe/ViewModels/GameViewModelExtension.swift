
// Add to GameViewModel.swift

extension GameViewModel {
    
    func handleGameEnd(winner: Player?, gameTime: TimeInterval, difficulty: Difficulty) {
        // Original game end logic...
        
        // V1.2: Award coins for game completion
        if let winner = winner {
            let coinsEarned = CoinManager.shared.coinsForWin(against: difficulty, gameTime: gameTime)
            CoinManager.shared.earnCoins(coinsEarned, reason: "Game Win")
            
            // Update daily challenge progress
            DailyChallengeManager.shared.updateProgress(for: .wins)
            
            if difficulty == .hard {
                DailyChallengeManager.shared.updateProgress(for: .hardAI)
            }
            
            if gameTime < 30 {
                DailyChallengeManager.shared.updateProgress(for: .quickWins)
            }
        }
        
        // Always update games played
        DailyChallengeManager.shared.updateProgress(for: .gamesPlayed)
    }
    
    func showCoinEarning(_ amount: Int) {
        // Show coin earning animation/notification
        // TODO: Implement coin earning animation
    }
}
