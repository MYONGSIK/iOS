//
//  GoogleMobileAdsController.swift
//  MYONGSIK
//
//  Created by 유상 on 2023/05/10.
//

import Foundation
import GoogleMobileAds


class GoogleMobileAdsController {
    
    private var interstitial: GADInterstitialAd!
    
    func createAndLoadInterstitial(vc: UIViewController) {
        let request = GADRequest()
            GADInterstitialAd.load(withAdUnitID: gakey,
                                        request: request,
                                        completionHandler: { [self] ad, error in
                if let error = error {
                  print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                  return
                }
                interstitial = ad
                showGaAd(vc: vc)
              }
        )
    }
    
    private func showGaAd(vc: UIViewController) {
        if interstitial != nil {
            interstitial!.present(fromRootViewController: vc)
          } else {
            print("Ad wasn't ready")
          }
    }
}
