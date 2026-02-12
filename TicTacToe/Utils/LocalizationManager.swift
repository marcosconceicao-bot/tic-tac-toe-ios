//
//  LocalizationManager.swift
//  TicTacToe
//
//  Internationalization system
//

import Foundation
import SwiftUI

class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()
    
    @Published var currentLanguage: String = "en" {
        didSet {
            UserDefaults.standard.set(currentLanguage, forKey: "app_language")
        }
    }
    
    let supportedLanguages = [
        "en": "English",
        "pt": "Português",
        "es": "Español", 
        "de": "Deutsch",
        "fr": "Français"
    ]
    
    private init() {
        // Load saved language or detect system language
        if let savedLanguage = UserDefaults.standard.string(forKey: "app_language") {
            currentLanguage = savedLanguage
        } else {
            // Detect system language
            let systemLanguage = Locale.current.language.languageCode?.identifier ?? "en"
            currentLanguage = supportedLanguages.keys.contains(systemLanguage) ? systemLanguage : "en"
        }
    }
    
    func localizedString(_ key: String) -> String {
        let bundle = Bundle.main
        
        // Try to get localized string for current language
        if let path = bundle.path(forResource: currentLanguage, ofType: "lproj"),
           let localizedBundle = Bundle(path: path) {
            let localizedString = localizedBundle.localizedString(forKey: key, value: nil, table: nil)
            if localizedString != key {
                return localizedString
            }
        }
        
        // Fallback to English
        if let path = bundle.path(forResource: "en", ofType: "lproj"),
           let englishBundle = Bundle(path: path) {
            return englishBundle.localizedString(forKey: key, value: nil, table: nil)
        }
        
        // Last resort: return the key itself
        return key
    }
    
    func setLanguage(_ language: String) {
        guard supportedLanguages.keys.contains(language) else { return }
        currentLanguage = language
    }
}

// MARK: - String Extension for Easy Localization
extension String {
    var localized: String {
        return LocalizationManager.shared.localizedString(self)
    }
    
    func localized(with arguments: CVarArg...) -> String {
        return String(format: self.localized, arguments: arguments)
    }
}

// MARK: - SwiftUI Text Extension
extension Text {
    init(localized key: String) {
        self.init(key.localized)
    }
}
