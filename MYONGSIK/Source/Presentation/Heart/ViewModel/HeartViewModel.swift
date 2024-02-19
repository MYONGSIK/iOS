//
//  HeartViewModel.swift
//  MYONGSIK
//
//  Created by 유상 on 2/19/24.
//

import Foundation
import Combine


struct HeartViewControllerInput {
    let viewDidLoad: AnyPublisher<Void, Never>
    let viewWillApear: AnyPublisher<[Heart], Never>
    let showHeartDetail: AnyPublisher<Heart, Never>
    let moveToWebView: AnyPublisher<Void, Never>
    let deleteHeart: AnyPublisher<Int, Never>
}

enum HeartViewControllerState {
    case showHeartList(String)
    case showHeartDetail(String)
    case showWebView(String)
    case deleteHeart(String)
    case none
}

protocol HeartViewModelalbel: ViewModelabel
where Input == HeartViewControllerInput,
      State == HeartViewControllerState,
      Output == AnyPublisher<State, Never> { }


