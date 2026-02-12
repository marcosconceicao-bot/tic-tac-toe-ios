# 🎮 Tic Tac Toe iOS

A classic Tic Tac Toe game for iOS built with SwiftUI, featuring AI opponent and ad monetization.

![iOS](https://img.shields.io/badge/iOS-15.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-5.5+-orange.svg)
![SwiftUI](https://img.shields.io/badge/SwiftUI-3.0+-green.svg)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)

## 🌟 Features

- **🆚 Game Modes**: Player vs Player & Player vs AI
- **🤖 Smart AI**: Multiple difficulty levels using Minimax algorithm
- **📊 Score Tracking**: Keep track of wins, losses, and draws
- **🎨 Modern UI**: Clean SwiftUI interface with smooth animations
- **🔊 Sound Effects**: Audio feedback for enhanced gameplay
- **📱 Responsive Design**: Works on all iPhone and iPad sizes
- **💰 Ad Integration**: Google AdMob for monetization

## 🚀 Getting Started

### Prerequisites
- Xcode 14.0+
- iOS 15.0+
- Swift 5.5+

### Installation
1. Clone the repository:
```bash
git clone https://github.com/marcosconceicao-bot/tic-tac-toe-ios.git
cd tic-tac-toe-ios
```

2. Open `TicTacToe.xcodeproj` in Xcode

3. Build and run the project

## 🏗️ Project Structure

```
TicTacToe/
├── App/
│   ├── TicTacToeApp.swift
│   └── ContentView.swift
├── Models/
│   ├── GameState.swift
│   ├── Player.swift
│   └── GameBoard.swift
├── Views/
│   ├── GameView.swift
│   ├── BoardView.swift
│   ├── ScoreView.swift
│   └── SettingsView.swift
├── ViewModels/
│   └── GameViewModel.swift
├── Game Logic/
│   ├── GameEngine.swift
│   └── AIPlayer.swift
├── Utils/
│   ├── SoundManager.swift
│   └── Extensions.swift
├── Ads/
│   └── AdManager.swift
└── Resources/
    ├── Sounds/
    └── Assets.xcassets
```

## 🎯 Roadmap

- [x] Basic game logic
- [x] SwiftUI interface
- [ ] AI implementation with Minimax
- [ ] Score persistence
- [ ] Sound effects
- [ ] Ad integration (AdMob)
- [ ] App Store submission

## 💰 Monetization Strategy

- **Banner Ads**: Bottom of main game screen
- **Interstitial Ads**: Between games (every 3-4 games)
- **Rewarded Ads**: Hints for next best move
- **No IAP**: Keep it simple, ad-supported only

## 🛠️ Tech Stack

- **Frontend**: SwiftUI
- **Architecture**: MVVM
- **Data Persistence**: UserDefaults
- **Ads**: Google AdMob
- **Audio**: AVFoundation
- **Analytics**: Firebase (optional)

## 📱 Screenshots

_Coming soon..._

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🚀 Download

_Will be available on the App Store soon!_

---

**Made with ❤️ by Marcos Conceição**