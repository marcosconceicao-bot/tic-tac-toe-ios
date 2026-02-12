//
//  BoardView.swift
//  TicTacToe
//
//  Created by Marcos Conceição on 2026-02-12.
//

import SwiftUI

struct BoardView: View {
    @EnvironmentObject var viewModel: GameViewModel
    @State private var winningPositions: [Int] = []
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8) {
            ForEach(0..<9, id: \.self) { position in
                CellView(
                    position: position,
                    player: viewModel.gameEngine.board.getPlayer(at: position),
                    isWinning: winningPositions.contains(position),
                    onTap: {
                        viewModel.makeMove(at: position)
                    }
                )
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.secondary.opacity(0.1))
        )
        .onChange(of: viewModel.gameEngine.gameState) { _, newState in
            updateWinningPositions()
        }
    }
    
    private func updateWinningPositions() {
        if case .playerWon = viewModel.gameEngine.gameState {
            winningPositions = viewModel.gameEngine.board.getWinningPositions() ?? []
        } else {
            winningPositions = []
        }
    }
}

struct CellView: View {
    let position: Int
    let player: Player?
    let isWinning: Bool
    let onTap: () -> Void
    
    @State private var scale: CGFloat = 1.0
    @State private var showSymbol = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                scale = 0.95
            }
            onTap()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    scale = 1.0
                }
            }
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(cellBackgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(cellBorderColor, lineWidth: isWinning ? 3 : 1)
                    )
                
                if let player = player {
                    Text(player.symbol)
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundColor(symbolColor(for: player))
                        .scaleEffect(showSymbol ? 1.0 : 0.1)
                        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: showSymbol)
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .scaleEffect(scale)
        .disabled(player != nil)
        .onChange(of: player) { _, newPlayer in
            if newPlayer != nil {
                showSymbol = true
            } else {
                showSymbol = false
            }
        }
    }
    
    private var cellBackgroundColor: Color {
        if isWinning {
            return Color.green.opacity(0.3)
        } else if player != nil {
            return Color.blue.opacity(0.1)
        } else {
            return Color.white
        }
    }
    
    private var cellBorderColor: Color {
        if isWinning {
            return Color.green
        } else {
            return Color.secondary.opacity(0.3)
        }
    }
    
    private func symbolColor(for player: Player) -> Color {
        switch player {
        case .x:
            return Color.red
        case .o:
            return Color.blue
        }
    }
}

#Preview {
    VStack {
        BoardView()
            .environmentObject(GameViewModel())
            .frame(width: 300)
        
        Spacer()
    }
    .padding()
}