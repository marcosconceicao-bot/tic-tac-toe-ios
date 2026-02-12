//
//  SoundManager.swift
//  TicTacToe
//
//  Created by Marcos Conceição on 2026-02-12.
//

import AVFoundation
import UIKit

class SoundManager: ObservableObject {
    static let shared = SoundManager()
    
    @Published var isEnabled = true
    
    private var movePlayer: AVAudioPlayer?
    private var winPlayer: AVAudioPlayer?
    private var drawPlayer: AVAudioPlayer?
    
    private init() {
        setupAudioSession()
        loadSounds()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }
    
    private func loadSounds() {
        // Create sound data programmatically since we don't have actual sound files
        // In a real app, you'd load from bundle resources
        loadSystemSounds()
    }
    
    private func loadSystemSounds() {
        // For now, we'll use system sounds
        // In production, replace with custom sound files
    }
    
    func playMoveSound() {
        guard isEnabled else { return }
        
        // Use system click sound
        AudioServicesPlaySystemSound(1104) // Tock sound
    }
    
    func playWinSound() {
        guard isEnabled else { return }
        
        // Use system success sound
        AudioServicesPlaySystemSound(1001) // Success sound
    }
    
    func playDrawSound() {
        guard isEnabled else { return }
        
        // Use system alert sound
        AudioServicesPlaySystemSound(1103) // Alert sound
    }
    
    func playButtonSound() {
        guard isEnabled else { return }
        
        // Use system button sound
        AudioServicesPlaySystemSound(1156) // Button sound
    }
    
    // MARK: - Custom Sound Loading (for when you add actual sound files)
    private func loadCustomSound(named fileName: String) -> AVAudioPlayer? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "mp3") else {
            print("Sound file \(fileName).mp3 not found")
            return nil
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            player.prepareToPlay()
            return player
        } catch {
            print("Error creating audio player: \(error)")
            return nil
        }
    }
}

// MARK: - Haptic Feedback Manager
class HapticFeedbackManager {
    static let shared = HapticFeedbackManager()
    
    private init() {}
    
    func playHaptic(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let impactFeedback = UIImpactFeedbackGenerator(style: style)
        impactFeedback.impactOccurred()
    }
    
    func playSuccess() {
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.success)
    }
    
    func playWarning() {
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.warning)
    }
    
    func playError() {
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.error)
    }
}

// MARK: - Analytics Manager (placeholder)
class AnalyticsManager {
    static let shared = AnalyticsManager()
    
    private init() {}
    
    func trackGameEnd(state: GameState, mode: GameMode) {
        // Implement analytics tracking here
        // Firebase Analytics, AppCenter, etc.
        print("Game ended: \(state), Mode: \(mode)")
    }
    
    func trackGameStart(mode: GameMode, difficulty: Difficulty? = nil) {
        print("Game started: \(mode), Difficulty: \(difficulty?.rawValue ?? "N/A")")
    }
    
    func trackAdShown(type: String) {
        print("Ad shown: \(type)")
    }
}