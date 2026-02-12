//
//  ThemeSelectionView.swift
//  TicTacToe
//
//  Theme selection interface
//

import SwiftUI

struct ThemeSelectionView: View {
    @ObservedObject var themeManager = ThemeManager.shared
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Choose Your Style")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                    ForEach(themeManager.availableThemes, id: \.name) { theme in
                        ThemePreviewCard(
                            theme: theme,
                            isSelected: theme.name == themeManager.currentTheme.name
                        ) {
                            themeManager.setTheme(theme)
                            HapticFeedbackManager.shared.playHaptic(.light)
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .themedBackground()
            .themedForeground()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(themeManager.currentTheme.primaryColor)
                }
            }
        }
    }
}

struct ThemePreviewCard: View {
    let theme: GameTheme
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                // Mini board preview
                LazyVGrid(columns: Array(repeating: GridItem(.fixed(20)), count: 3), spacing: 4) {
                    ForEach(0..<9, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 4)
                            .fill(theme.boardColor)
                            .frame(width: 20, height: 20)
                            .overlay(
                                Group {
                                    if index == 0 {
                                        Text("X")
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(theme.playerXColor)
                                    } else if index == 4 {
                                        Text("O")
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(theme.playerOColor)
                                    }
                                }
                            )
                    }
                }
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(theme.backgroundColor)
                )
                
                Text(theme.name)
                    .font(.headline)
                    .foregroundColor(theme.textColor)
                
                if isSelected {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(theme.primaryColor)
                        Text("Selected")
                            .font(.caption)
                            .foregroundColor(theme.primaryColor)
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(theme.backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                isSelected ? theme.primaryColor : theme.secondaryColor.opacity(0.3),
                                lineWidth: isSelected ? 3 : 1
                            )
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

#Preview {
    ThemeSelectionView()
}
