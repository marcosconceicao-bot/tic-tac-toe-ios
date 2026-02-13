
// GameViewModel+SoundIntegration.swift
// Add sound integration to existing GameViewModel

import Foundation

extension GameViewModel {
    
    func playMoveSound() {
        SoundManager.shared.playUISound(for: .cellTap)
    }
    
    func playGameResultSound() {
        if gameEngine.isGameOver {
            if let winner = gameEngine.winner {
                if winner == .player1 {
                    SoundManager.shared.playSound(.victory)
                } else {
                    SoundManager.shared.playSound(.defeat)
                }
            } else {
                SoundManager.shared.playSound(.draw)
            }
        }
    }
    
    func playNewGameSound() {
        SoundManager.shared.playSound(.gameStart)
    }
    
    func playErrorSound() {
        SoundManager.shared.playUISound(for: .error)
    }
}

// CoinManager+SoundIntegration.swift
// Add sound integration to coin earning

extension CoinManager {
    func playCoinsEarnedSound() {
        SoundManager.shared.playSound(.coinEarn)
    }
}

// PremiumManager+SoundIntegration.swift
// Add sound integration to premium purchases

extension PremiumManager {
    func playPurchaseSound() {
        SoundManager.shared.playSound(.purchase)
    }
    
    func playPremiumUpgradeSound() {
        SoundManager.shared.playSound(.premiumUpgrade)
    }
}

// DailyChallengeManager+SoundIntegration.swift
// Add sound integration to challenge completion

extension DailyChallengeManager {
    func playChallengeCompleteSound() {
        SoundManager.shared.playSound(.challengeComplete)
    }
}

// AchievementManager+SoundIntegration.swift
// Add sound integration to achievement unlocks

extension AchievementManager {
    func playAchievementSound() {
        SoundManager.shared.playSound(.achievementUnlock)
    }
}
