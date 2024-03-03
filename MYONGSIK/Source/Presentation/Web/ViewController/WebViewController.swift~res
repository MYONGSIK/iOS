//
//  WebViewController.swift
//  MYONGSIK
//
//  Created by gomin on 2022/11/02.
//

import UIKit
import WebKit

// MARK: 링크 이동 후 보이는 페이지입니다.
class WebViewController: UIViewController, WKUIDelegate {
    var webView: WKWebView!
    
    var restaurant: RestaurantModel?
    var isHeart: Bool = false
    
    let heartButton = UIButton().then{
        $0.setImage(UIImage(named: "empty_heart"), for: .normal)
        $0.setImage(UIImage(named: "fill_heart"), for: .selected)
        
        $0.layer.shadowColor = UIColor.black.cgColor // 색깔
        $0.layer.masksToBounds = false  // 내부에 속한 요소들이 UIView 밖을 벗어날 때, 잘라낼 것인지. 그림자는 밖에 그려지는 것이므로 false 로 설정
        $0.layer.shadowOffset = CGSize(width: 0, height: 0) // 위치조정
        $0.layer.shadowRadius = 4 // 반경
        $0.layer.shadowOpacity = 0.5 // alpha값
    }
    
    // MARK: - Life Cycles

    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = true
        
        setUpView()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let url = self.restaurant?.urlAddress else {return}
        let myURL = URL(string: url)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        
        heartButton.addTarget(self, action: #selector(heartButtonDidTap), for: .touchUpInside)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = true
    }
    // MARK: - Actions
    @objc func heartButtonDidTap() {
        UIDevice.vibrate()
        if heartButton.isSelected {
            removeHeartAnimation()
        } else {
            addHeartAnimation()
        }
    }
    
    // MARK: - Functions
    func setUpView() {
        webView.addSubview(heartButton)
        heartButton.snp.makeConstraints { make in
            make.width.height.equalTo(65)
            make.trailing.equalToSuperview().offset(-32)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-32)
        }
    }

    func addHeartAnimation() {
        ToastBar(self, message: .addHeart)
        UIView.transition(with: self.heartButton,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: { () -> Void in
                          self.heartButton.isSelected = true},
                          completion: nil);
    }
    func removeHeartAnimation() {
        ToastBar(self, message: .deleteHeart)
        UIView.transition(with: self.heartButton,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: { () -> Void in
                          self.heartButton.isSelected = false},
                          completion: nil);
    }
}
