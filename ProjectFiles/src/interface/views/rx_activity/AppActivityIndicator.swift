//
//  AppActivityIndicator.swift
//  Matterly Test App
//
//  Created by User on 9/13/17.
//  Copyright © 2017 Olearis. All rights reserved.
//

import UIKit
import RxSwift

class AppActivityIndicator: UIActivityIndicatorView {
    
    private var rx_animating: AnyObserver<Bool> {
        return AnyObserver { [unowned self] event in
            MainScheduler.ensureExecutingOnScheduler()
            
            switch (event) {
            case .next(let value):
                if value {
                    self.show()
                } else {
                    self.hide()
                }
            case .error(let error):
                let error = "Binding error to UI: \(error)"
                print(error)
                
            case .completed:
                break
            }
        }
    }
    
    private let disposeBag = DisposeBag()
    private(set) var rx_activityTracker = ActivityIndicator()
    private var view: UIView?
    private(set) var active = false
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupRx()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupRx()
    }
    
    func setupRx() {
        rx_activityTracker
            .asObservable()
            .bind(to: rx_animating)
            .addDisposableTo(disposeBag)
    }
    
    func show() {
        if !self.active {
            MainScheduler.ensureExecutingOnScheduler()
            if !UIApplication.shared.isIgnoringInteractionEvents {
                UIApplication.shared.beginIgnoringInteractionEvents()
            }
            self.startAnimating()
            self.active = true
        }
    }
    
    func hide() {
        if self.active {
            MainScheduler.ensureExecutingOnScheduler()
            if UIApplication.shared.isIgnoringInteractionEvents {
                UIApplication.shared.endIgnoringInteractionEvents()
            }
            self.stopAnimating()
            self.active = false
        }
    }
    
}
