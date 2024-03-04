//
//  WebViewController.swift
//  MYONGSIK
//
//  Created by gomin on 2022/11/02.
//

import UIKit
import WebKit

import Combine
import CombineCocoa

class WebViewController: UIViewController, WKUIDelegate {
    var webView: WKWebView!
    
    private let viewModel = WebViewModel()
    private var cancellabels = Set<AnyCancellable>()
    private var input: PassthroughSubject<WebViewModel.Input, Never> = .init()
    
    var heart: RequestHeartModel?
    var isHeart: Bool = false
    var id: String?

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
        let pref = WKWebpagePreferences.init()
        pref.preferredContentMode = .mobile
        webConfiguration.defaultWebpagePreferences = pref
        
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = true
        
        setUpView()

        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        heartButton.isSelected = isHeart
        input.send(.viewDidLoad(heart!))

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = true
    }

    func setUpView() {
        webView.addSubview(heartButton)
        heartButton.snp.makeConstraints { make in
            make.width.height.equalTo(65)
            make.trailing.equalToSuperview().offset(-32)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-32)
        }
    }
    
    func bind() {
        heartButton.tapPublisher.sink { [weak self] _ in
            if self!.isHeart {
                guard let id = self?.id else {return}
                self?.input.send(.cancelHeart(id))
            }else {
                guard let heart = self?.heart else {return}
                print(heart)
                self?.input.send(.postHeart(heart))
            }
        }.store(in: &cancellabels)
        
        
        let output = viewModel.trastfrom(input.eraseToAnyPublisher())
        
        output.receive(on: DispatchQueue.main).sink { [weak self] event in
            switch event {
            case .updateWeb(let url):
                let myURL = URL(string: url)
                let myRequest = URLRequest(url: myURL!)
                self?.webView.load(myRequest)
            case .postHeart(let id):
                self?.id = id
                self?.addHeartAnimation()
                self?.isHeart = true
            case .cancelHeart(let result):
                if result {
                    self?.removeHeartAnimation()
                    self?.isHeart = false
                }
            }
        }.store(in: &cancellabels)
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
