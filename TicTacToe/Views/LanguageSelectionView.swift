//
//  LanguageSelectionView.swift
//  TicTacToe
//
//  Language/Region selection interface
//

import SwiftUI

struct LanguageSelectionView: View {
    @ObservedObject var localizationManager = LocalizationManager.shared
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("choose_language".localized)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                VStack(spacing: 12) {
                    ForEach(Array(localizationManager.supportedLanguages.keys), id: \.self) { languageCode in
                        LanguageButton(
                            languageCode: languageCode,
                            languageName: localizationManager.supportedLanguages[languageCode] ?? "",
                            isSelected: languageCode == localizationManager.currentLanguage
                        ) {
                            localizationManager.setLanguage(languageCode)
                            HapticFeedbackManager.shared.playHaptic(.light)
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                Text("language_restart_note".localized)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("done".localized) {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct LanguageButton: View {
    let languageCode: String
    let languageName: String
    let isSelected: Bool
    let onTap: () -> Void
    
    private var flagEmoji: String {
        switch languageCode {
        case "en": return "🇺🇸"
        case "pt": return "🇧🇷"
        case "es": return "🇪🇸"
        case "de": return "🇩🇪"
        case "fr": return "🇫🇷"
        default: return "🌍"
        }
    }
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Text(flagEmoji)
                    .font(.title2)
                
                Text(languageName)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.secondary.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                isSelected ? Color.blue : Color.secondary.opacity(0.3),
                                lineWidth: isSelected ? 2 : 1
                            )
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    LanguageSelectionView()
}
