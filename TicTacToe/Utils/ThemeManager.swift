//
//  ThemeManager.swift
//  TicTacToe
//
//  Auto-generated theme system
//

import SwiftUI
import Foundation

// MARK: - Theme Protocol
protocol GameTheme {
    var name: String { get }
    var primaryColor: Color { get }
    var secondaryColor: Color { get }
    var backgroundColor: Color { get }
    var boardColor: Color { get }
    var playerXColor: Color { get }
    var playerOColor: Color { get }
    var textColor: Color { get }
    var winningColor: Color { get }
}

// MARK: - Built-in Themes
struct ClassicTheme: GameTheme {
    let name = "Classic"
    let primaryColor = Color.blue
    let secondaryColor = Color.gray
    let backgroundColor = Color.white
    let boardColor = Color.secondary.opacity(0.1)
    let playerXColor = Color.red
    let playerOColor = Color.blue
    let textColor = Color.primary
    let winningColor = Color.green
}

struct DarkTheme: GameTheme {
    let name = "Dark"
    let primaryColor = Color.purple
    let secondaryColor = Color.gray
    let backgroundColor = Color.black
    let boardColor = Color.white.opacity(0.1)
    let playerXColor = Color.orange
    let playerOColor = Color.cyan
    let textColor = Color.white
    let winningColor = Color.yellow
}

struct NeonTheme: GameTheme {
    let name = "Neon"
    let primaryColor = Color.pink
    let secondaryColor = Color.purple
    let backgroundColor = Color.black
    let boardColor = Color.purple.opacity(0.2)
    let playerXColor = Color.pink
    let playerOColor = Color.cyan
    let textColor = Color.white
    let winningColor = Color.yellow
}

struct PaperTheme: GameTheme {
    let name = "Paper"
    let primaryColor = Color.brown
    let secondaryColor = Color.secondary
    let backgroundColor = Color(red: 0.96, green: 0.94, blue: 0.90)
    let boardColor = Color.brown.opacity(0.3)
    let playerXColor = Color.blue
    let playerOColor = Color.red
    let textColor = Color.black
    let winningColor = Color.green
}

struct MinimalTheme: GameTheme {
    let name = "Minimal"
    let primaryColor = Color.primary
    let secondaryColor = Color.secondary
    let backgroundColor = Color.clear
    let boardColor = Color.primary.opacity(0.1)
    let playerXColor = Color.primary
    let playerOColor = Color.secondary
    let textColor = Color.primary
    let winningColor = Color.primary
}

// MARK: - Theme Manager
class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    
    @Published var currentTheme: GameTheme = ClassicTheme() {
        didSet {
            saveTheme()
        }
    }
    
    let availableThemes: [GameTheme] = [
        ClassicTheme(),
        DarkTheme(),
        NeonTheme(),
        PaperTheme(),
        MinimalTheme()
    ]
    
    private init() {
        loadTheme()
    }
    
    func setTheme(_ theme: GameTheme) {
        currentTheme = theme
    }
    
    private func saveTheme() {
        UserDefaults.standard.set(currentTheme.name, forKey: "selectedTheme")
    }
    
    private func loadTheme() {
        let savedThemeName = UserDefaults.standard.string(forKey: "selectedTheme") ?? "Classic"
        if let theme = availableThemes.first(where: { $0.name == savedThemeName }) {
            currentTheme = theme
        }
    }
}

// MARK: - Theme Extensions
extension View {
    func themedBackground() -> some View {
        self.background(ThemeManager.shared.currentTheme.backgroundColor.ignoresSafeArea())
    }
    
    func themedForeground() -> some View {
        self.foregroundColor(ThemeManager.shared.currentTheme.textColor)
    }
    
    func themedBoard() -> some View {
        self.background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ThemeManager.shared.currentTheme.boardColor)
        )
    }
}
