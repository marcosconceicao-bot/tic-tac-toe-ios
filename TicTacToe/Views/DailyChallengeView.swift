//
//  DailyChallengeView.swift
//  TicTacToe
//
//  Daily challenges interface
//

import SwiftUI

struct DailyChallengeView: View {
    @ObservedObject var challengeManager = DailyChallengeManager.shared
    @State private var showingCompletionCelebration = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Header with streak
                StreakHeader()
                
                // Today's challenge
                if let challenge = challengeManager.todayChallenge {
                    ChallengeCard(challenge: challenge)
                } else {
                    Text("Loading today's challenge...")
                        .foregroundColor(.secondary)
                }
                
                // Progress section
                if let challenge = challengeManager.todayChallenge {
                    ProgressSection(challenge: challenge)
                }
                
                // Completion celebration
                if challengeManager.isCompleted {
                    CompletionCelebration()
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Daily Challenge")
            .navigationBarTitleDisplayMode(.large)
            .onReceive(NotificationCenter.default.publisher(for: .dailyChallengeCompleted)) { _ in
                showingCompletionCelebration = true
            }
            .alert("Challenge Complete! 🎉", isPresented: $showingCompletionCelebration) {
                Button("Awesome!") {}
            } message: {
                if let challenge = challengeManager.todayChallenge {
                    Text("You completed \(challenge.title) and earned \(challenge.reward) coins!")
                }
            }
        }
    }
}

struct StreakHeader: View {
    @ObservedObject var challengeManager = DailyChallengeManager.shared
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Current Streak")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                    Text("\(challengeManager.streak)")
                        .font(.title.bold())
                    Text(challengeManager.streak == 1 ? "day" : "days")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("Keep it up!")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("🔥")
                    .font(.title)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.orange.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct ChallengeCard: View {
    let challenge: DailyChallenge
    @ObservedObject var challengeManager = DailyChallengeManager.shared
    
    var body: some View {
        VStack(spacing: 16) {
            // Icon and title
            HStack {
                Image(systemName: challenge.iconName)
                    .font(.system(size: 30))
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading) {
                    Text(challenge.title)
                        .font(.title2.bold())
                    
                    Text(challenge.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            // Reward info
            HStack {
                Spacer()
                
                HStack {
                    Image(systemName: "dollarsign.circle.fill")
                        .foregroundColor(.yellow)
                    Text("\(challenge.reward) coins")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.yellow.opacity(0.2))
                )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(challengeManager.isCompleted ? Color.green.opacity(0.1) : Color.blue.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            challengeManager.isCompleted ? Color.green : Color.blue,
                            lineWidth: 2
                        )
                )
        )
    }
}

struct ProgressSection: View {
    let challenge: DailyChallenge
    @ObservedObject var challengeManager = DailyChallengeManager.shared
    
    private var progress: Double {
        Double(challengeManager.challengeProgress) / Double(challenge.requirement)
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Progress")
                    .font(.headline)
                
                Spacer()
                
                Text("\(challengeManager.challengeProgress)/\(challenge.requirement)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle())
                .scaleEffect(y: 2)
                .animation(.easeInOut, value: progress)
            
            if challengeManager.isCompleted {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("Completed!")
                        .font(.headline)
                        .foregroundColor(.green)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.secondary.opacity(0.05))
        )
    }
}

struct CompletionCelebration: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("🎉")
                .font(.system(size: 60))
                .scaleEffect(1.0)
                .animation(.spring(response: 0.5, dampingFraction: 0.5).repeatCount(3), value: true)
            
            Text("Challenge Complete!")
                .font(.title.bold())
                .foregroundColor(.green)
            
            Text("Come back tomorrow for a new challenge!")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.green.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.green, lineWidth: 2)
                )
        )
    }
}

#Preview {
    DailyChallengeView()
}
