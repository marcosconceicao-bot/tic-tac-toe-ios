//
//  GameViewModel.swift
//  TicTacToe
//
//  Created by Marcos Conceição on 2026-02-12.
//

import Foundation
import Combine

class GameViewModel: ObservableObject {
    @Published var gameEngine = GameEngine()
    @Published var showingGameModeSelection = false
    @Published var showingDifficultySelection = false
    @Published var showingSettings = false
    @Published var soundEnabled = true
    @Published var vibrationEnabled = true
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupBindings()
        loadSettings()
    }
    
    // MARK: - Public Methods
    func newGame() {
        gameEngine.startNewGame()
        
        // Show ad after every few games
        if gameEngine.score.totalGames > 0 && gameEngine.score.totalGames % 3 == 0 {
            AdManager.shared.showInterstitialAd()
        }
    }
    
    func makeMove(at position: Int) {
        gameEngine.makeMove(at: position)
        
        if vibrationEnabled {
            HapticFeedbackManager.shared.playHaptic(.light)
        }
    }
    
    func resetScore() {
        gameEngine.resetScore()
    }
    
    func setGameMode(_ mode: GameMode) {
        gameEngine.gameMode = mode
        showingGameModeSelection = false
        
        if mode == .playerVsAI {
            showingDifficultySelection = true
        } else {
            newGame()
        }
    }
    
    func setDifficulty(_ difficulty: Difficulty) {
        gameEngine.difficulty = difficulty
        showingDifficultySelection = false
        newGame()
    }
    
    func toggleSound() {
        soundEnabled.toggle()
        SoundManager.shared.isEnabled = soundEnabled
        saveSettings()
    }
    
    func toggleVibration() {
        vibrationEnabled.toggle()
        saveSettings()
    }
    
    // MARK: - Private Methods
    private func setupBindings() {
        // Listen to game state changes for achievements/analytics
        gameEngine.$gameState
            .sink { [weak self] state in
                if state.isGameOver {
                    self?.handleGameEnd(state)
                }
            }
            .store(in: &cancellables)
    }
    
    private func handleGameEnd(_ state: GameState) {
        // Analytics tracking
        AnalyticsManager.shared.trackGameEnd(state: state, mode: gameEngine.gameMode)
        
        // Haptic feedback for game end
        if vibrationEnabled {
            switch state {
            case .playerWon:
                HapticFeedbackManager.shared.playHaptic(.success)
            case .draw:
                HapticFeedbackManager.shared.playHaptic(.warning)
            default:
                break
            }
        }
    }
    
    private func loadSettings() {
        soundEnabled = UserDefaults.standard.bool(forKey: "soundEnabled")
        vibrationEnabled = UserDefaults.standard.bool(forKey: "vibrationEnabled")
        
        SoundManager.shared.isEnabled = soundEnabled
        
        // Default to true if first time
        if UserDefaults.standard.object(forKey: "soundEnabled") == nil {
            soundEnabled = true
            vibrationEnabled = true
            saveSettings()
        }
    }
    
    private func saveSettings() {
        UserDefaults.standard.set(soundEnabled, forKey: "soundEnabled")
        UserDefaults.standard.set(vibrationEnabled, forKey: "vibrationEnabled")
    }
}