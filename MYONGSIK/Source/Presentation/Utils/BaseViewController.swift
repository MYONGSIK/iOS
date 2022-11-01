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
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                
        //setUpView
        self.view.addSubview(navigationView)
        
        //setUpConstraint
        navigationView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            if UIDevice.current.hasNotch {make.height.equalTo(121)}
            else {make.height.equalTo(91)}
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
}
