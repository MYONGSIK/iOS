//
//  TabBarViewController.swift
//  MYONGSIK
//
//  Created by gomin on 2022/10/30.
//

import UIKit

// MARK: 하단바 Custom
class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.backgroundColor = .white
        
        
        let gaAdController = GoogleMobileAdsController()
         
        gaAdController.createAndLoadInterstitial(vc: self)
        
        
       // 인스턴스화
        let resVC = RestaurantMainViewController()
//        let mapVC = MapViewController()
        let mainVC = SelectRestaurantViewController()
        let heartVC = HeartViewController()
        
        resVC.tabBarItem.image = UIImage.init(named: "res")
//        mapVC.tabBarItem.image = UIImage.init(named: "map")
        mainVC.tabBarItem.image = UIImage.init(named: "todayFood")
        heartVC.tabBarItem.image = UIImage.init(named: "heart")
        
        resVC.tabBarItem.title = "명지맛집"
//        mapVC.tabBarItem.title = "맛집지도"
        mainVC.tabBarItem.title = "오늘의 학식"
        heartVC.tabBarItem.title = "찜꽁리스트"
        
        self.tabBar.tintColor = .signatureBlue
        let fontAttributes = [NSAttributedString.Key.font: UIFont.NotoSansKR(size: 10, family: .Regular)]
        UITabBarItem.appearance().setTitleTextAttributes(fontAttributes, for: .normal)
        
       // navigationController의 root view 설정
        let nav1 = UINavigationController(rootViewController: resVC)
//        let nav2 = UINavigationController(rootViewController: mapVC)
        let nav3 = UINavigationController(rootViewController: mainVC)
        let nav4 = UINavigationController(rootViewController: heartVC)
    
        setViewControllers([nav1, nav3, nav4], animated: false)
        
        self.selectedIndex = 2
    }
}
