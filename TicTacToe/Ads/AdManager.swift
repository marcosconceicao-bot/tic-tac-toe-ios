//
//  AdManager.swift
//  TicTacToe
//
//  Created by Marcos Conceição on 2026-02-12.
//

import Foundation
import SwiftUI
// import GoogleMobileAds // Uncomment when SDK is added

// MARK: - Ad Manager
class AdManager: ObservableObject {
    static let shared = AdManager()
    
    @Published var bannerLoaded = false
    @Published var interstitialLoaded = false
    @Published var rewardedLoaded = false
    
    // Test Ad Unit IDs (for development)
    private let testBannerID = "ca-app-pub-3940256099942544/2934735716"
    private let testInterstitialID = "ca-app-pub-3940256099942544/4411468910"
    private let testRewardedID = "ca-app-pub-3940256099942544/1712485313"
    
    // Production Ad Unit IDs (replace with your real IDs)
    private let prodBannerID = "ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX"
    private let prodInterstitialID = "ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX"
    private let prodRewardedID = "ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX"
    
    // Current ad unit IDs (switches based on debug/release)
    private var bannerAdUnitID: String {
        #if DEBUG
        return testBannerID
        #else
        return prodBannerID
        #endif
    }
    
    private var interstitialAdUnitID: String {
        #if DEBUG
        return testInterstitialID
        #else
        return prodInterstitialID
        #endif
    }
    
    private var rewardedAdUnitID: String {
        #if DEBUG
        return testRewardedID
        #else
        return prodRewardedID
        #endif
    }
    
    // private var interstitialAd: GADInterstitialAd?
    // private var rewardedAd: GADRewardedAd?
    
    private init() {}
    
    // MARK: - Initialization
    func initializeAds() {
        print("🚀 Initializing AdMob...")
        
        // Initialize Google Mobile Ads SDK
        // GADMobileAds.sharedInstance().start { [weak self] status in
        //     print("✅ AdMob initialized with status: \(status)")
        //     self?.loadAllAds()
        // }
        
        // For now, simulate initialization
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.loadAllAds()
        }
    }
    
    private func loadAllAds() {
        loadBannerAd()
        loadInterstitialAd()
        loadRewardedAd()
    }
    
    // MARK: - Banner Ads
    func loadBannerAd() {
        print("📱 Loading banner ad...")
        
        // Real implementation:
        // let bannerView = GADBannerView(adSize: GADAdSizeBanner)
        // bannerView.adUnitID = bannerAdUnitID
        // bannerView.rootViewController = UIApplication.shared.windows.first?.rootViewController
        // bannerView.load(GADRequest())
        
        // Simulate loading for now
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.bannerLoaded = true
            print("✅ Banner ad loaded")
        }
    }
    
    // MARK: - Interstitial Ads
    func loadInterstitialAd() {
        print("📺 Loading interstitial ad...")
        
        // Real implementation:
        // let request = GADRequest()
        // GADInterstitialAd.load(withAdUnitID: interstitialAdUnitID, request: request) { [weak self] ad, error in
        //     if let error = error {
        //         print("❌ Failed to load interstitial ad: \(error)")
        //         return
        //     }
        //     
        //     self?.interstitialAd = ad
        //     self?.interstitialAd?.fullScreenContentDelegate = self
        //     
        //     DispatchQueue.main.async {
        //         self?.interstitialLoaded = true
        //         print("✅ Interstitial ad loaded")
        //     }
        // }
        
        // Simulate loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.interstitialLoaded = true
            print("✅ Interstitial ad loaded")
        }
    }
    
    func showInterstitialAd() {
        guard interstitialLoaded else {
            print("⚠️ Interstitial ad not ready")
            return
        }
        
        print("📺 Showing interstitial ad")
        AnalyticsManager.shared.trackAdShown(type: "interstitial")
        
        // Real implementation:
        // guard let interstitial = interstitialAd,
        //       let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
        //     return
        // }
        // 
        // interstitial.present(fromRootViewController: rootViewController)
        
        // Simulate showing ad
        interstitialLoaded = false
        
        // Reload for next time
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.loadInterstitialAd()
        }
    }
    
    // MARK: - Rewarded Ads
    func loadRewardedAd() {
        print("🎁 Loading rewarded ad...")
        
        // Real implementation:
        // let request = GADRequest()
        // GADRewardedAd.load(withAdUnitID: rewardedAdUnitID, request: request) { [weak self] ad, error in
        //     if let error = error {
        //         print("❌ Failed to load rewarded ad: \(error)")
        //         return
        //     }
        //     
        //     self?.rewardedAd = ad
        //     self?.rewardedAd?.fullScreenContentDelegate = self
        //     
        //     DispatchQueue.main.async {
        //         self?.rewardedLoaded = true
        //         print("✅ Rewarded ad loaded")
        //     }
        // }
        
        // Simulate loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.rewardedLoaded = true
            print("✅ Rewarded ad loaded")
        }
    }
    
    func showRewardedAd(completion: @escaping (Bool) -> Void) {
        guard rewardedLoaded else {
            print("⚠️ Rewarded ad not ready")
            completion(false)
            return
        }
        
        print("🎁 Showing rewarded ad")
        AnalyticsManager.shared.trackAdShown(type: "rewarded")
        
        // Real implementation:
        // guard let rewarded = rewardedAd,
        //       let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
        //     completion(false)
        //     return
        // }
        // 
        // rewarded.present(fromRootViewController: rootViewController) {
        //     let reward = rewarded.adReward
        //     print("🎉 User earned reward: \(reward.amount) \(reward.type)")
        //     completion(true)
        // }
        
        // Simulate showing ad and earning reward
        rewardedLoaded = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            completion(true)
            self.loadRewardedAd()
        }
    }
}

// MARK: - GADFullScreenContentDelegate
// extension AdManager: GADFullScreenContentDelegate {
//     func adDidRecordImpression(_ ad: GADFullScreenPresentingAd) {
//         print("📊 Ad recorded impression")
//     }
//     
//     func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
//         print("❌ Ad failed to present: \(error)")
//     }
//     
//     func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
//         print("📱 Ad will present")
//     }
//     
//     func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
//         print("❌ Ad dismissed")
//         // Reload ads
//         if ad is GADInterstitialAd {
//             loadInterstitialAd()
//         } else if ad is GADRewardedAd {
//             loadRewardedAd()
//         }
//     }
// }

// MARK: - AdMob Banner View (Real Implementation)
struct AdBannerView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        
        // Real implementation with GADBannerView:
        // let bannerView = GADBannerView(adSize: GADAdSizeBanner)
        // bannerView.adUnitID = AdManager.shared.bannerAdUnitID
        // bannerView.rootViewController = UIApplication.shared.windows.first?.rootViewController
        // bannerView.load(GADRequest())
        // 
        // bannerView.translatesAutoresizingMaskIntoConstraints = false
        // view.addSubview(bannerView)
        // 
        // NSLayoutConstraint.activate([
        //     bannerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        //     bannerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        // ])
        
        // Placeholder implementation
        view.backgroundColor = UIColor.systemGray6
        
        let label = UILabel()
        label.text = "AdMob Banner (320x50)"
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
        // Update if needed
    }
}

// MARK: - Development Instructions
/*
 
 🚀 TO ENABLE REAL ADMOB:
 
 1. Add Google Mobile Ads SDK:
    - Xcode: File > Add Package Dependencies  
    - URL: https://github.com/googleads/swift-package-manager-google-mobile-ads
 
 2. Uncomment import GoogleMobileAds at the top
 
 3. Update Info.plist with your AdMob App ID:
    <key>GADApplicationIdentifier</key>
    <string>ca-app-pub-YOUR-APP-ID~XXXXXXXXXX</string>
 
 4. Uncomment all GAD* related code in this file
 
 5. Replace prodBannerID, prodInterstitialID, prodRewardedID with your real ad unit IDs
 
 6. Build and test!
 
 📱 TEST AD UNIT IDS (safe to use):
 - Banner: ca-app-pub-3940256099942544/2934735716
 - Interstitial: ca-app-pub-3940256099942544/4411468910
 - Rewarded: ca-app-pub-3940256099942544/1712485313
 
 */