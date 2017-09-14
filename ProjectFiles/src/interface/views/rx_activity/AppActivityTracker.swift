//
//  AppActivityTracker.swift
//  Matterly Test App
//
//  Created by User on 9/14/17.
//  Copyright © 2017 Olearis. All rights reserved.
//

import Foundation

import RxSwift

class AppActivityTracker {
    
    private var rx_animating: AnyObserver<Bool> {
        return AnyObserver { [unowned self] event in
            MainScheduler.ensureExecutingOnScheduler()
            
            switch (event) {
            case .next(let value):
                if value {
                   self.active = true
                } else {
                    self.active = false
                }
            case .error(let error):
                let error = "Binding error to UI: \(error)"
                print(error)
                self.active = false
            case .completed:
                break
            }
        }
    }
    
    private let disposeBag = DisposeBag()
    private(set) var rx_activityTracker = ActivityIndicator()
    private var view: UIView?
    private(set) var active = false
    
    init() {
        setupRx()
    }
    
    func setupRx() {
        rx_activityTracker
            .asObservable()
            .bind(to: rx_animating)
            .addDisposableTo(disposeBag)
    }
    
}
