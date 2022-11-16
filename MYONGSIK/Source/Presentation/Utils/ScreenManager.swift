//
//  ScreenManager.swift
//  MYONGSIK
//
//  Created by gomin on 2022/11/01.
//

import Foundation
import UIKit
import SafariServices

class ScreenManager {
    // MARK: 링크 이동
    func linkTo(viewcontroller: UIViewController, _ urlStr: String) {
        guard let url = NSURL(string: urlStr) else {return}
        let linkView: SFSafariViewController = SFSafariViewController(url: url as URL)
        viewcontroller.present(linkView, animated: true, completion: nil)
    }
}
