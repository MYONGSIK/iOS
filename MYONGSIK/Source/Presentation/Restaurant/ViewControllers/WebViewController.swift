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
    // MARK: - Views
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
    var webView: WKWebView!
    
    // Properties
    var storeData: StoreModel?
    var campusInfo: CampusInfo?
    
    var webURL: String!
    var placeName: String!
    var category: String!
    
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
        
        
        guard let url = self.webURL else {return}
        let myURL = URL(string: url)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        
        setUpView()
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
            removeHeartData()
            removeHeartAnimation()
        } else {
            addHeartData()
            requestAddHeart()
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
        getHeartData()
    }
    func addHeartData() {
        guard let url = self.webURL else {return}
        guard let placeName = self.placeName else {return}
        guard let category = self.category else {return}
        
        // MARK: - 서버와 통신해 찜콩 리스트 저장

    }
    func removeHeartData() {
        guard let url = self.webURL else {return}
        guard let placeName = self.placeName else {return}
        guard let category = self.category else {return}
        
        // MARK: - 서버와 통신해 찜콩리스트 삭제
        
    }
    func getHeartData() {
        // MARK: - 서버와 통신해 찜콩 리스트 Get
       
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
    
    func requestAddHeart() {
        // TODO: 찜꽁 리스트 추가 POST
//        let campus = (campusInfo == .seoul) ? "SEOUL" : "YONGIN"
//        let phoneId = DeviceIdManager.shared.getDeviceID()
//
//        let bodyParam = HeartModel(address: storeData?.address,
//                                   campus: campus,
//                                   category: storeData?.category,
//                                   code: storeData?.code,
//                                   contact: storeData?.contact,
//                                   distance: storeData?.distance,
//                                   longitude: storeData?.latitude,
//                                   latitude: storeData?.longitude,
//                                   name: storeData?.name,
//                                   phoneId: phoneId,
//                                   urlAddress: storeData?.urlAddress)
//        
//        APIManager.shared.postData(urlEndpointString: Constants.postHeart,
//                                   dataType: HeartModel.self,
//                                   responseType: HeartModel.self,
//                                   parameter: bodyParam,
//                                   completionHandler: { response in
//            print("찜꽁 POST Param - \(bodyParam)")
//            print(response)
//        })
    }
}
