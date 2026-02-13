//
//  SoundSettingsView.swift
//  TicTacToe
//
//  Sound settings interface
//

import SwiftUI

struct SoundSettingsView: View {
    @ObservedObject var soundManager = SoundManager.shared
    @State private var showingPreview = false
    
    var body: some View {
        NavigationStack {
            List {
                // Master Controls
                Section("Audio") {
                    Toggle("Sound Effects", isOn: $soundManager.isSoundEnabled)
                        .onChange(of: soundManager.isSoundEnabled) { enabled in
                            if enabled {
                                soundManager.playUISound(for: .success)
                            }
                        }
                    
                    Toggle("Background Music", isOn: $soundManager.isMusicEnabled)
                        .onChange(of: soundManager.isMusicEnabled) { enabled in
                            HapticFeedbackManager.shared.playLight()
                        }
                }
                
                // Volume Controls
                if soundManager.isSoundEnabled || soundManager.isMusicEnabled {
                    Section("Volume") {
                        if soundManager.isSoundEnabled {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Sound Effects")
                                    Spacer()
                                    Text("\(Int(soundManager.soundVolume * 100))%")
                                        .foregroundColor(.secondary)
                                }
                                
                                Slider(value: $soundManager.soundVolume, in: 0...1)
                                    .onChange(of: soundManager.soundVolume) { _ in
                                        soundManager.playSound(.tap)
                                    }
                            }
                        }
                        
                        if soundManager.isMusicEnabled {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Background Music")
                                    Spacer()
                                    Text("\(Int(soundManager.musicVolume * 100))%")
                                        .foregroundColor(.secondary)
                                }
                                
                                Slider(value: $soundManager.musicVolume, in: 0...1)
                            }
                        }
                    }
                }
                
                // Sound Preview
                Section("Preview Sounds") {
                    Button(action: {
                        soundManager.playSound(.victory)
                        HapticFeedbackManager.shared.playSuccess()
                    }) {
                        SoundPreviewRow(title: "Victory", icon: "crown.fill", color: .yellow)
                    }
                    
                    Button(action: {
                        soundManager.playSound(.coinEarn)
                        HapticFeedbackManager.shared.playLight()
                    }) {
                        SoundPreviewRow(title: "Coin Earned", icon: "dollarsign.circle.fill", color: .green)
                    }
                    
                    Button(action: {
                        soundManager.playSound(.achievementUnlock)
                        HapticFeedbackManager.shared.playSuccess()
                    }) {
                        SoundPreviewRow(title: "Achievement", icon: "trophy.fill", color: .orange)
                    }
                    
                    Button(action: {
                        soundManager.playSound(.premiumUpgrade)
                        HapticFeedbackManager.shared.playSuccess()
                    }) {
                        SoundPreviewRow(title: "Premium Upgrade", icon: "star.fill", color: .purple)
                    }
                    
                    Button(action: {
                        soundManager.playSound(.error)
                        HapticFeedbackManager.shared.playError()
                    }) {
                        SoundPreviewRow(title: "Error", icon: "exclamationmark.triangle.fill", color: .red)
                    }
                }
                
                // Background Music Controls
                if soundManager.isMusicEnabled {
                    Section("Background Music") {
                        HStack {
                            Button("Play") {
                                soundManager.playBackgroundMusic()
                                HapticFeedbackManager.shared.playLight()
                            }
                            .disabled(soundManager.backgroundMusicPlayer?.isPlaying == true)
                            
                            Spacer()
                            
                            Button("Pause") {
                                soundManager.pauseBackgroundMusic()
                                HapticFeedbackManager.shared.playLight()
                            }
                            .disabled(soundManager.backgroundMusicPlayer?.isPlaying != true)
                            
                            Spacer()
                            
                            Button("Stop") {
                                soundManager.stopBackgroundMusic()
                                HapticFeedbackManager.shared.playLight()
                            }
                        }
                    }
                }
                
                // Audio Info
                Section(footer: Text("Sound effects enhance gameplay experience. Background music provides ambient atmosphere during play.")) {
                    EmptyView()
                }
            }
            .navigationTitle("Audio Settings")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct SoundPreviewRow: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title2)
                .frame(width: 30)
            
            Text(title)
                .foregroundColor(.primary)
            
            Spacer()
            
            Image(systemName: "speaker.wave.2.fill")
                .foregroundColor(.secondary)
                .font(.caption)
        }
    }
}

// Extension for SoundManager to expose background music player state
extension SoundManager {
    var backgroundMusicPlayer: AVAudioPlayer? {
        return backgroundMusicPlayer
    }
}

#Preview {
    SoundSettingsView()
}
