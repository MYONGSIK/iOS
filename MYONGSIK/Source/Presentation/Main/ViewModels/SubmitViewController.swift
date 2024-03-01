//
//  SubmitViewController.swift
//  MYONGSIK
//
//  Created by 김초원 on 2023/01/17.
//

import UIKit
import SnapKit
import Then


// MARK: '학식에 대한 의견 남기기' 페이지
enum inputStatus {
    case notSubmit
    case submitted
}
class SubmitViewController: UIViewController {
    
    var submitStatus: inputStatus = .notSubmit
    
    // MARK: - Views
    var submitView: UIView = UIView().then {
        $0.layer.cornerRadius = 6
        $0.layer.backgroundColor = UIColor.white.cgColor
    }
    var titleLabel: UILabel = UILabel().then {
        $0.text = "학식에 대한 의견을 남겨주세요!"
        $0.font = UIFont.NotoSansKR(size: 12, family: .Regular)
        $0.textColor = .gray
        
    }
    var inputTextView: UITextView = UITextView()
    var textCountLabel: UILabel = UILabel().then {
        $0.text = "0/100"
        $0.font = UIFont.NotoSansKR(size: 12, family: .Regular)
        $0.textColor = .gray
    }
    
    var submitButton: UIButton = UIButton().then {
        $0.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        $0.setTitle("완료", for: .normal)
        $0.titleLabel?.font = UIFont.NotoSansKR(size: 13, family: .Bold)
        $0.backgroundColor = .lightGray
        $0.layer.cornerRadius = 15
        $0.isEnabled = false
    }
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textDidChanged(_:)),
            name: UITextView.textDidChangeNotification,
            object: self.inputView
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardDidHideNotification,
            object: nil
        )
        self.view.layer.backgroundColor = UIColor.black.withAlphaComponent(0.5).cgColor
        self.setUpInitialSubView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Actions
    @objc func keyboardWillShow() {
        self.submitView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-140)
        }
    }
    
    @objc func keyboardWillHide() {
        self.submitView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    @objc func submitButtonTapped() {
        self.submitStatus = .submitted
        setUpCompleteView()
    }
    
    @objc func textDidChanged(_ notification: Notification) {
        if let text = self.inputTextView.text {
            if text.count > 100 {
                submitButton.isEnabled = false
                submitButton.backgroundColor = .lightGray
                textCountLabel.text = "글자 수가 100자를 초과함(\(text.count)/50)"
                textCountLabel.textColor = .red
            } else if text.count > 0 {
                submitButton.isEnabled = true
                submitButton.backgroundColor = .signatureBlue
                textCountLabel.text = "\(text.count)/50"
                textCountLabel.textColor = .gray
            }
        }
        
    }
    
    // MARK: - Functions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch self.submitStatus {
        case .notSubmit:
            if inputTextView.text.count == 0 {
                self.dismiss(animated: true)
            } else {
                let alert = UIAlertController(
                    title: "의견 작성을 취소할까요?",
                    message: "작성중인 의견은 저장되지 않습니다",
                    preferredStyle: UIAlertController.Style.alert
                )
                
                let cancelAlert = UIAlertAction(title: "안 쓸래요", style: .default) {_ in
                    self.dismiss(animated: true)
                }
                alert.addAction(cancelAlert)
                let keepAlert = UIAlertAction(title: "계속 쓸래요", style: .cancel)
                alert.addAction(keepAlert)
                
                present(alert, animated: true)
            }
        case .submitted:
            self.dismiss(animated: true)
        }
    }
    
    func setUpInitialSubView() {
        self.view.addSubview(self.submitView)
        self.submitView.snp.makeConstraints {
            $0.width.equalTo(330)
            $0.height.equalTo(250)
            $0.centerX.centerY.equalToSuperview()
        }
        
        self.submitView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
        }
        
        self.submitView.addSubview(self.inputTextView)
        self.inputTextView.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel).offset(50)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.bottom.equalToSuperview().inset(50)
        }
        
        self.submitView.addSubview(self.textCountLabel)
        self.textCountLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(30)
            $0.top.equalTo(self.inputTextView.snp.bottom)
        }
        
        self.submitView.addSubview(self.submitButton)
        self.submitButton.snp.makeConstraints {
            $0.width.equalTo(70)
            $0.height.equalTo(30)
            $0.bottom.equalToSuperview().inset(10)
            $0.trailing.equalTo(self.inputTextView)
        }
    }
    
    func setUpCompleteView() {
        if self.inputTextView.text.count > 0 {
            saveSubmit(input: self.inputTextView.text)
        }
    }
    
    func saveSubmit(input: String?) {
        let restraunt = MainViewModel.shared.getRestaurant()
        if let submitted = self.inputTextView.text {
            
            let phoneId = DeviceIdManager.shared.getDeviceID()
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let registeredAt = formatter.string(from: Date())
//            
//            let param = SubmitModel(areaName: restraunt.getServerName(),
//                                    writerId: phoneId,
//                                    registeredAt: registeredAt,
//                                    content: submitted)
//            APIManager.shared.postData(urlEndpointString: Constants.postFoodReviewWithArea,
//                                       dataType: SubmitModel.self,
//                                       responseType: SubmitResponseModel.self,
//                                       parameter: param,
//                                       completionHandler: { [weak self] result in
//                
//                switch result.success {
//                case true:
//                    self?.showCompleteSubmitView()
//                case false:
//                    self?.showFailToSubmitAlert(errorcode: result.httpCode)
//                }
//            })
            
        } else { print("ERROR :: 제출할 의견이 비어있음"); return }
        
    }
    
    private func showCompleteSubmitView() {
        // submitView 재설정
        self.titleLabel.removeFromSuperview()
        self.inputTextView.removeFromSuperview()
        self.textCountLabel.removeFromSuperview()
        self.submitButton.removeFromSuperview()
        
        let imageView = UIImageView().then {
            $0.contentMode = .scaleAspectFit
            $0.image = UIImage(named: "custom_check")
        }
        submitView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(100)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-30)
        }
        
        let resultLabel = UILabel().then {
            $0.text = "소중한 의견 제출 감사합니다!"
            $0.font = UIFont.NotoSansKR(size: 20, family: .Regular)
            $0.textColor = .black
        }
        self.view.addSubview(resultLabel)
        resultLabel.snp.makeConstraints {
            $0.top.equalTo(imageView).offset(110)
            $0.centerX.equalToSuperview()
        }
        
        let subResultLabel = UILabel().then {
            $0.text = "더욱 발전하는 명식이가 되겠습니다"
            $0.font = UIFont.NotoSansKR(size: 12, family: .Regular)
            $0.textColor = .gray
        }
        self.view.addSubview(subResultLabel)
        subResultLabel.snp.makeConstraints {
            $0.top.equalTo(resultLabel.snp.bottom)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func showFailToSubmitAlert(errorcode: Int?) {
        let alert = UIAlertController(title: nil, message: "네트워크 오류로 인하여 의견 제출에 실패하였습니다. \n오류 코드 : \(errorcode)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}


