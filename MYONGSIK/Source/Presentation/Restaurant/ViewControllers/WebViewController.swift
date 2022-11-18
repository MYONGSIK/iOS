//
//  WebViewController.swift
//  MYONGSIK
//
//  Created by gomin on 2022/11/02.
//

import UIKit
import WebKit
import RealmSwift

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
    let realm = try! Realm()    // Realm을 활용해 기기에 저장합니다.
    
    // Properties
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
        self.tabBarController?.tabBar.isHidden = true
        
        // realm 객체 정의
        let realm = try! Realm()
        
        guard let url = self.webURL else {return}
        let myURL = URL(string: url)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        
        setUpView()
        heartButton.addTarget(self, action: #selector(heartButtonDidTap), for: .touchUpInside)
    }
    // MARK: - Actions
    @objc func heartButtonDidTap() {
        UIDevice.vibrate()
        if heartButton.isSelected {
            removeHeartData()
            removeHeartAnimation()
        } else {
            addHeartData()
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
        
        let heartData = HeartListData()
        heartData.placeName = placeName
        heartData.category = category
        heartData.placeUrl = url
        
        try! realm.write { //렘(DB)에 저장
              realm.add(heartData)
            }
        // MARK: -
        /*
         기존방식: HeartListData 모델을 정의하고, 이름/카테고리/url을 저장하며 이것으로 아이템들을 구분하였습니다.
         수정해야할 방식: 각 맛집마다 ID가 있습니다. removeHeartData 할 때, ID를 통해 구분하시면 되겠습니다.
         */
    }
    func removeHeartData() {
        guard let url = self.webURL else {return}
        guard let placeName = self.placeName else {return}
        guard let category = self.category else {return}
        
        // 쿼리를 통해 선택적 삭제
        // TODO: 추후 placeName이 아닌 ID로 데이터 삭제 !!!!!!
        let predicate = NSPredicate(format: "placeName = %@", placeName)
        let obj = realm.objects(HeartListData.self).filter(predicate)
        print(obj)
        try! realm.write { //렘(DB)에서 삭제
            realm.delete(obj)
            }
        
    }
    func getHeartData() {
        // 모든 객체 얻기
        let hearts = realm.objects(HeartListData.self)
        for heart in hearts {
            if self.placeName == heart.placeName {self.heartButton.isSelected = true}
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
