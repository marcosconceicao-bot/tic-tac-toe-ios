//
//  TicTacToeApp.swift
//  TicTacToe
//
//  Created by Marcos Conceição on 2026-02-12.
//

import SwiftUI

@main
struct TicTacToeApp: App {
    @StateObject private var gameViewModel = GameViewModel()
    @StateObject private var adManager = AdManager()
    
    init() {
        // Configure ads
        AdManager.shared.initializeAds()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(gameViewModel)
                .environmentObject(adManager)
                .preferredColorScheme(.light)
        }
    }
}