//
//  BaseViewController.swift
//  MYONGSIK
//
//  Created by gomin on 2022/10/19.
//
import UIKit

class BaseViewController: UIViewController {
    // MARK: - Properties
    // MARK: Views
    let navigationView = UIView().then{
        $0.backgroundColor = .signatureBlue
        $0.clipsToBounds = true
    }
    let titleLabel = UILabel().then{
        $0.font = UIFont.NotoSansKR(size: 24, family: .Bold)
        $0.textColor = .white
    }
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
                
        //setUpView
        self.view.addSubview(navigationView)
        navigationView.addSubview(titleLabel)
        
        //setUpConstraint
        navigationView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            if UIDevice.current.hasNotch {make.height.equalTo(121)}
            else {make.height.equalTo(91)}
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.bottom.equalToSuperview().offset(-22)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
}
