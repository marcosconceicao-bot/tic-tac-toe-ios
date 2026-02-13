//
// AdManager.swift - Updated for Premium Integration
//

import Foundation
import GoogleMobileAds

class AdManager: NSObject, ObservableObject {
    static let shared = AdManager()
    
    @Published var bannerLoaded = false
    @Published var interstitialLoaded = false
    @Published var rewardedLoaded = false
    
    private var bannerAd: GADBannerView?
    private var interstitialAd: GADInterstitialAd?
    private var rewardedAd: GADRewardedAd?
    
    // Ad unit IDs (Test IDs - Replace with real ones)
    private let bannerAdUnitID = "ca-app-pub-3940256099942544/2934735716"
    private let interstitialAdUnitID = "ca-app-pub-3940256099942544/4411468910"
    private let rewardedAdUnitID = "ca-app-pub-3940256099942544/1712485313"
    
    override init() {
        super.init()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        loadAds()
    }
    
    // MARK: - Premium Check
    private var shouldShowAds: Bool {
        return PremiumManager.shared.shouldShowAds
    }
    
    // MARK: - Load Ads
    private func loadAds() {
        guard shouldShowAds else {
            print("👑 Premium user - No ads loaded")
            return
        }
        
        loadBannerAd()
        loadInterstitialAd()
        loadRewardedAd()
    }
    
    func loadBannerAd() {
        guard shouldShowAds else {
            bannerLoaded = false
            return
        }
        
        let request = GADRequest()
        
        bannerAd = GADBannerView(adSize: GADAdSizeBanner)
        bannerAd?.adUnitID = bannerAdUnitID
        bannerAd?.delegate = self
        bannerAd?.load(request)
    }
    
    func loadInterstitialAd() {
        guard shouldShowAds else {
            interstitialLoaded = false
            return
        }
        
        let request = GADRequest()
        
        GADInterstitialAd.load(withAdUnitID: interstitialAdUnitID, request: request) { [weak self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad: \(error.localizedDescription)")
                self?.interstitialLoaded = false
                return
            }
            
            self?.interstitialAd = ad
            self?.interstitialLoaded = true
            self?.interstitialAd?.fullScreenContentDelegate = self
        }
    }
    
    func loadRewardedAd() {
        let request = GADRequest()
        
        GADRewardedAd.load(withAdUnitID: rewardedAdUnitID, request: request) { [weak self] ad, error in
            if let error = error {
                print("Failed to load rewarded ad: \(error.localizedDescription)")
                self?.rewardedLoaded = false
                return
            }
            
            self?.rewardedAd = ad
            self?.rewardedLoaded = true
            self?.rewardedAd?.fullScreenContentDelegate = self
        }
    }
    
    // MARK: - Show Ads
    func showInterstitialAd() {
        guard shouldShowAds, 
              let interstitialAd = interstitialAd,
              let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
            print("👑 Premium user or ad not ready - Skipping interstitial")
            return
        }
        
        interstitialAd.present(fromRootViewController: rootViewController)
    }
    
    func showRewardedAd(completion: @escaping (Bool) -> Void) {
        guard let rewardedAd = rewardedAd,
              let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
            completion(false)
            return
        }
        
        rewardedAd.present(fromRootViewController: rootViewController) {
            // User earned reward
            completion(true)
        }
    }
    
    func getBannerView() -> GADBannerView? {
        guard shouldShowAds else {
            return nil
        }
        return bannerAd
    }
}

// MARK: - GADBannerViewDelegate
extension AdManager: GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerLoaded = true
        print("✅ Banner ad loaded")
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        bannerLoaded = false
        print("❌ Banner ad failed: \(error.localizedDescription)")
    }
}

// MARK: - GADFullScreenContentDelegate
extension AdManager: GADFullScreenContentDelegate {
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        if ad is GADInterstitialAd {
            interstitialLoaded = false
            loadInterstitialAd()
        } else if ad is GADRewardedAd {
            rewardedLoaded = false
            loadRewardedAd()
        }
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("❌ Full screen ad failed to present: \(error.localizedDescription)")
        
        if ad is GADInterstitialAd {
            interstitialLoaded = false
            loadInterstitialAd()
        } else if ad is GADRewardedAd {
            rewardedLoaded = false
            loadRewardedAd()
        }
    }
}
