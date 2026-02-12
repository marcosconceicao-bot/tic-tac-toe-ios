//
//  AdManager.swift
//  TicTacToe
//
//  Created by Marcos Conceição on 2026-02-12.
//

import Foundation
import SwiftUI

// MARK: - Ad Manager
class AdManager: ObservableObject {
    static let shared = AdManager()
    
    @Published var bannerLoaded = false
    @Published var interstitialLoaded = false
    @Published var rewardedLoaded = false
    
    private init() {}
    
    // MARK: - Initialization
    func initializeAds() {
        // Initialize Google AdMob
        // GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        // For development, simulate ad loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.bannerLoaded = true
            self.interstitialLoaded = true
            self.rewardedLoaded = true
        }
        
        loadBannerAd()
        loadInterstitialAd()
        loadRewardedAd()
    }
    
    // MARK: - Banner Ads
    func loadBannerAd() {
        // Load banner ad
        // In production, use GADBannerView
        print("Loading banner ad...")
        
        // Simulate loading delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.bannerLoaded = true
        }
    }
    
    // MARK: - Interstitial Ads
    func loadInterstitialAd() {
        print("Loading interstitial ad...")
        
        // Simulate loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.interstitialLoaded = true
        }
    }
    
    func showInterstitialAd() {
        guard interstitialLoaded else {
            print("Interstitial ad not ready")
            return
        }
        
        print("Showing interstitial ad")
        AnalyticsManager.shared.trackAdShown(type: "interstitial")
        
        // Show ad
        // In production, use GADInterstitialAd
        
        // Reload for next time
        interstitialLoaded = false
        loadInterstitialAd()
    }
    
    // MARK: - Rewarded Ads
    func loadRewardedAd() {
        print("Loading rewarded ad...")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.rewardedLoaded = true
        }
    }
    
    func showRewardedAd(completion: @escaping (Bool) -> Void) {
        guard rewardedLoaded else {
            print("Rewarded ad not ready")
            completion(false)
            return
        }
        
        print("Showing rewarded ad")
        AnalyticsManager.shared.trackAdShown(type: "rewarded")
        
        // Simulate showing ad and earning reward
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            completion(true)
        }
        
        rewardedLoaded = false
        loadRewardedAd()
    }
}

// MARK: - AdMob Banner View (Placeholder)
struct AdBannerView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray5
        
        // Add placeholder text
        let label = UILabel()
        label.text = "Banner Ad Placeholder"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Update ad view if needed
    }
}

// MARK: - AdMob Setup Instructions
/*
 
 To implement real AdMob ads:
 
 1. Add Google Mobile Ads SDK:
    - In Xcode: File > Add Package Dependencies
    - URL: https://github.com/googleads/swift-package-manager-google-mobile-ads
 
 2. Configure Info.plist:
    Add your AdMob App ID:
    <key>GADApplicationIdentifier</key>
    <string>ca-app-pub-XXXXXXXXXXXXXXXXX~XXXXXXXX</string>
 
 3. Update AdManager:
    import GoogleMobileAds
    
    // In initializeAds():
    GADMobileAds.sharedInstance().start(completionHandler: nil)
    
 4. Replace placeholders with real ad units:
    - Banner: GADBannerView
    - Interstitial: GADInterstitialAd
    - Rewarded: GADRewardedAd
 
 5. Ad Unit IDs:
    - Banner: "ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX"
    - Interstitial: "ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX"
    - Rewarded: "ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX"
 
 6. Test with test ad unit IDs during development:
    - Test Banner: "ca-app-pub-3940256099942544/2934735716"
    - Test Interstitial: "ca-app-pub-3940256099942544/4411468910"
    - Test Rewarded: "ca-app-pub-3940256099942544/1712485313"
 
 */