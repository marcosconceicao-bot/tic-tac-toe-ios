//
//  TutorialView.swift
//  TicTacToe
//
//  Interactive tutorial and onboarding
//

import SwiftUI

struct TutorialView: View {
    @State private var currentStep = 0
    @State private var isComplete = false
    @Environment(\.dismiss) private var dismiss
    
    let tutorialSteps = [
        TutorialStep(
            title: "Welcome to Tic Tac Toe!",
            description: "Let's learn how to play and master the game",
            icon: "🎮",
            action: .none
        ),
        TutorialStep(
            title: "Objective",
            description: "Get three X's or O's in a row, column, or diagonal to win",
            icon: "🎯", 
            action: .demo
        ),
        TutorialStep(
            title: "AI Opponent",
            description: "Choose from 3 difficulty levels to match your skill",
            icon: "🤖",
            action: .selection
        ),
        TutorialStep(
            title: "Themes & Customization",
            description: "Personalize your game with beautiful themes",
            icon: "🎨",
            action: .preview
        ),
        TutorialStep(
            title: "Achievements",
            description: "Unlock achievements and track your progress",
            icon: "🏆",
            action: .showcase
        ),
        TutorialStep(
            title: "Ready to Play!",
            description: "You're all set! Start your first game",
            icon: "🚀",
            action: .complete
        )
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Progress indicator
            HStack {
                ForEach(0..<tutorialSteps.count, id: \.self) { index in
                    Circle()
                        .fill(index <= currentStep ? Color.blue : Color.secondary.opacity(0.3))
                        .frame(width: 8, height: 8)
                        .animation(.easeInOut, value: currentStep)
                }
                Spacer()
                
                Button("Skip") {
                    completeTutorial()
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
            .padding()
            
            // Main content
            VStack(spacing: 30) {
                // Icon
                Text(currentTutorialStep.icon)
                    .font(.system(size: 80))
                    .scaleEffect(currentStep == 0 ? 1.2 : 1.0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.7), value: currentStep)
                
                // Title and description
                VStack(spacing: 16) {
                    Text(currentTutorialStep.title)
                        .font(.title.bold())
                        .multilineTextAlignment(.center)
                    
                    Text(currentTutorialStep.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                // Interactive content based on step
                tutorialContentView
                
                Spacer()
                
                // Navigation buttons
                HStack {
                    if currentStep > 0 {
                        Button("Previous") {
                            withAnimation(.easeInOut) {
                                currentStep -= 1
                            }
                        }
                        .font(.headline)
                        .foregroundColor(.blue)
                    }
                    
                    Spacer()
                    
                    Button(currentStep == tutorialSteps.count - 1 ? "Get Started!" : "Next") {
                        if currentStep == tutorialSteps.count - 1 {
                            completeTutorial()
                        } else {
                            withAnimation(.easeInOut) {
                                currentStep += 1
                            }
                        }
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .cornerRadius(8)
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    private var currentTutorialStep: TutorialStep {
        tutorialSteps[currentStep]
    }
    
    @ViewBuilder
    private var tutorialContentView: some View {
        switch currentTutorialStep.action {
        case .demo:
            // Mini game demo
            MiniGameDemo()
        case .selection:
            // Difficulty preview
            DifficultyPreview()
        case .preview:
            // Theme preview
            ThemePreview()
        case .showcase:
            // Achievement showcase
            AchievementShowcase()
        default:
            EmptyView()
        }
    }
    
    private func completeTutorial() {
        UserDefaults.standard.set(true, forKey: "tutorial_completed")
        dismiss()
    }
}

struct TutorialStep {
    let title: String
    let description: String
    let icon: String
    let action: TutorialAction
}

enum TutorialAction {
    case none
    case demo
    case selection
    case preview
    case showcase
    case complete
}

struct MiniGameDemo: View {
    var body: some View {
        VStack {
            Text("Tap any square to place your symbol")
                .font(.caption)
                .foregroundColor(.secondary)
            
            // Mini 3x3 grid
            LazyVGrid(columns: Array(repeating: GridItem(.fixed(60)), count: 3), spacing: 4) {
                ForEach(0..<9, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.blue.opacity(0.1))
                        .frame(width: 60, height: 60)
                        .overlay(
                            Text(index == 0 ? "X" : index == 4 ? "O" : "")
                                .font(.title.bold())
                                .foregroundColor(index == 0 ? .red : .blue)
                        )
                }
            }
        }
    }
}

struct DifficultyPreview: View {
    var body: some View {
        VStack(spacing: 12) {
            DifficultyOption(name: "Easy", description: "Random moves", color: .green)
            DifficultyOption(name: "Medium", description: "Defensive play", color: .orange)
            DifficultyOption(name: "Hard", description: "Unbeatable", color: .red)
        }
        .padding(.horizontal)
    }
}

struct DifficultyOption: View {
    let name: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
            
            Text(name)
                .font(.headline)
            
            Spacer()
            
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.secondary.opacity(0.1))
        )
    }
}

struct ThemePreview: View {
    var body: some View {
        HStack(spacing: 12) {
            ThemeCircle(color: .blue, name: "Classic")
            ThemeCircle(color: .black, name: "Dark")
            ThemeCircle(color: .pink, name: "Neon")
            ThemeCircle(color: .brown, name: "Paper")
        }
    }
}

struct ThemeCircle: View {
    let color: Color
    let name: String
    
    var body: some View {
        VStack(spacing: 8) {
            Circle()
                .fill(color)
                .frame(width: 50, height: 50)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                )
            
            Text(name)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct AchievementShowcase: View {
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "trophy.fill")
                    .foregroundColor(.yellow)
                Text("First Victory")
                    .font(.subheadline.weight(.medium))
                Spacer()
            }
            
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.blue)
                Text("Getting Good")
                    .font(.subheadline.weight(.medium))
                Spacer()
            }
            
            HStack {
                Image(systemName: "crown.fill")
                    .foregroundColor(.purple)
                Text("Expert Player")
                    .font(.subheadline.weight(.medium))
                Spacer()
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.secondary.opacity(0.1))
        )
        .padding(.horizontal)
    }
}

#Preview {
    TutorialView()
}
