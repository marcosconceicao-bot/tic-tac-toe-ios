//
//  StatisticsView.swift
//  TicTacToe
//
//  Detailed game statistics and analytics
//

import SwiftUI
import Charts

struct StatisticsView: View {
    @EnvironmentObject var viewModel: GameViewModel
    @State private var selectedTimeframe: TimeFrame = .allTime
    
    enum TimeFrame: String, CaseIterable {
        case week = "7 Days"
        case month = "30 Days" 
        case allTime = "All Time"
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Time frame picker
                    Picker("Time Frame", selection: $selectedTimeframe) {
                        ForEach(TimeFrame.allCases, id: \.self) { timeframe in
                            Text(timeframe.rawValue).tag(timeframe)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    // Win Rate Card
                    StatCard(
                        title: "Win Rate",
                        value: winRate,
                        subtitle: "\(totalWins) wins out of \(totalGames) games",
                        color: .green
                    )
                    
                    // Games Overview
                    HStack(spacing: 15) {
                        MiniStatCard(title: "Games", value: "\(totalGames)", color: .blue)
                        MiniStatCard(title: "Wins", value: "\(totalWins)", color: .green)
                        MiniStatCard(title: "Draws", value: "\(totalDraws)", color: .orange)
                    }
                    .padding(.horizontal)
                    
                    // Performance by Difficulty
                    VStack(alignment: .leading, spacing: 12) {
                        Text("AI Performance")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        VStack(spacing: 8) {
                            DifficultyStatRow(difficulty: "Easy", wins: 15, total: 20)
                            DifficultyStatRow(difficulty: "Medium", wins: 8, total: 15)
                            DifficultyStatRow(difficulty: "Hard", wins: 2, total: 12)
                        }
                        .padding(.horizontal)
                    }
                    
                    // Recent Achievements
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recent Achievements")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        // Show last 3 unlocked achievements
                        ForEach(recentAchievements, id: \.id) { achievement in
                            RecentAchievementRow(achievement: achievement)
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                }
            }
            .navigationTitle("Statistics")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    // MARK: - Computed Properties
    private var totalGames: Int {
        viewModel.gameEngine.score.totalGames
    }
    
    private var totalWins: Int {
        viewModel.gameEngine.score.playerXWins + viewModel.gameEngine.score.playerOWins
    }
    
    private var totalDraws: Int {
        viewModel.gameEngine.score.draws
    }
    
    private var winRate: String {
        guard totalGames > 0 else { return "0%" }
        let rate = Double(totalWins) / Double(totalGames) * 100
        return String(format: "%.1f%%", rate)
    }
    
    private var recentAchievements: [Achievement] {
        // Mock data - replace with actual recent achievements
        []
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundColor(color)
            
            Text(subtitle)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.secondary.opacity(0.1))
        )
        .padding(.horizontal)
    }
}

struct MiniStatCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2.bold())
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.secondary.opacity(0.1))
        )
    }
}

struct DifficultyStatRow: View {
    let difficulty: String
    let wins: Int
    let total: Int
    
    private var winRate: Double {
        guard total > 0 else { return 0 }
        return Double(wins) / Double(total)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(difficulty)
                    .font(.subheadline.weight(.medium))
                
                Spacer()
                
                Text("\(wins)/\(total)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            ProgressView(value: winRate)
                .progressViewStyle(LinearProgressViewStyle())
                .scaleEffect(y: 0.8)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.secondary.opacity(0.05))
        )
    }
}

struct RecentAchievementRow: View {
    let achievement: Achievement
    
    var body: some View {
        HStack {
            Image(systemName: achievement.iconName)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(achievement.name)
                    .font(.subheadline.weight(.medium))
                
                Text(achievement.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text("🏆")
                .font(.title2)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.secondary.opacity(0.05))
        )
    }
}

#Preview {
    StatisticsView()
        .environmentObject(GameViewModel())
}
