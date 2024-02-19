//
//  ViewModelabel.swift
//  MYONGSIK
//
//  Created by 유상 on 2/19/24.
//

import Foundation

protocol ViewModelabel {
    associatedtype Input
    associatedtype State
    associatedtype Output
    
    func trastfrom(_ input: Input) -> Output
}
