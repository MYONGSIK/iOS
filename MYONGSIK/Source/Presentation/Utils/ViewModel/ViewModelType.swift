//
//  ViewModelType.swift
//  MYONGSIK
//
//  Created by gomin on 2022/10/27.
//
import RxCocoa
import RxSwift

protocol ViewModelType: class {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }

    func transform(input: Input) -> Output
}
