//
//  WebViewController.swift
//  MYONGSIK
//
//  Created by gomin on 2022/11/02.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate {
    let heartButton = UIButton().then{
        $0.setImage(UIImage(named: "empty_heart"), for: .normal)
        $0.setImage(UIImage(named: "fill_heart"), for: .selected)
        
        $0.layer.shadowColor = UIColor.black.cgColor // 색깔
        $0.layer.masksToBounds = false  // 내부에 속한 요소들이 UIView 밖을 벗어날 때, 잘라낼 것인지. 그림자는 밖에 그려지는 것이므로 false 로 설정
        $0.layer.shadowOffset = CGSize(width: 0, height: 0) // 위치조정
        $0.layer.shadowRadius = 4 // 반경
        $0.layer.shadowOpacity = 0.25 // alpha값
    }
    
    var webView: WKWebView!
    var webURL: String!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        
        guard let url = self.webURL else {return}
        let myURL = URL(string: url)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        
        webView.addSubview(heartButton)
        heartButton.snp.makeConstraints { make in
            make.width.height.equalTo(65)
            make.trailing.equalToSuperview().offset(-50)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}
