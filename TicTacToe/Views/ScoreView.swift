//
//  ScoreView.swift
//  TicTacToe
//
//  Created by Marcos Conceição on 2026-02-12.
//

import SwiftUI

struct ScoreView: View {
    @EnvironmentObject var viewModel: GameViewModel
    
    var body: some View {
        HStack(spacing: 20) {
            ScoreCard(
                title: "Player X",
                score: viewModel.gameEngine.score.playerXWins,
                color: .red,
                symbol: "X"
            )
            
            ScoreCard(
                title: "Draws",
                score: viewModel.gameEngine.score.draws,
                color: .gray,
                symbol: "="
            )
            
            ScoreCard(
                title: "Player O",
                score: viewModel.gameEngine.score.playerOWins,
                color: .blue,
                symbol: "O"
            )
        }
        .padding(.horizontal)
    }
}

struct ScoreCard: View {
    let title: String
    let score: Int
    let color: Color
    let symbol: String
    
    @State private var pulseScale: CGFloat = 1.0
    
    var body: some View {
        VStack(spacing: 8) {
            Text(symbol)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(color)
                .scaleEffect(pulseScale)
            
            Text("\(score)")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
        .onChange(of: score) { oldValue, newValue in
            if newValue > oldValue {
                animatePulse()
            }
        }
    }
    
    private func animatePulse() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            pulseScale = 1.3
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                pulseScale = 1.0
            }
        }
    }
}

#Preview {
    VStack {
        ScoreView()
            .environmentObject({
                let vm = GameViewModel()
                vm.gameEngine.score.playerXWins = 3
                vm.gameEngine.score.playerOWins = 2
                vm.gameEngine.score.draws = 1
                return vm
            }())
        
        Spacer()
    }
    .padding()
}