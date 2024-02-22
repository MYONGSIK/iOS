//
//  ViewModelabel.swift
//  MYONGSIK
//
//  Created by 유상 on 2/19/24.
//

import Foundation
import Combine

protocol ViewModelabel {
    associatedtype Input
    associatedtype Output
    
    func trastfrom(_ input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never>
}
