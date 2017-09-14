//
//  MImageView.swift
//  Matterly Test App
//
//  Created by User on 9/13/17.
//  Copyright © 2017 Olearis. All rights reserved.
//

import UIKit
import SDWebImage
import RxSwift

class MImageView: UIImageView {
    
    static let ErrorDomain = "MImageView.Error"
    static let errorCode: Int = 777
    
    enum Result {
        case success(image: UIImage), failure(error: Error)
    }
    
    typealias FinishBlock = (Result)-> Void
    
    func setImageFromUrl(_ url: URL, finished finishBlock: FinishBlock? = nil) {
        sd_setImage(with: url) { (image, error, cacheType, url) in
            if let rError = error {
                finishBlock?(Result.failure(error: rError))
            } else if let rImage = image {
                finishBlock?(Result.success(image: rImage))
            }
        }
    }
    
    func setImageFromUrlString(_ urlString: String, finished finishBlock: FinishBlock? = nil) {
        guard let url = URL(string: urlString) else {
            let errorUserInfo = [NSLocalizedDescriptionKey: NSLocalizedString("MImageView URL is not valid", comment: "") + "\n\(urlString)"]
            let error = NSError(domain: MImageView.ErrorDomain, code: MImageView.errorCode, userInfo: errorUserInfo)
            finishBlock?(Result.failure(error: error))
            return
        }
        setImageFromUrl(url, finished: finishBlock)
    }
    
    func cancelLoading() {
        sd_cancelCurrentImageLoad()
    }
    
    func rx_setImageFromUrl(_ url: URL)-> Observable<UIImage> {
        return Observable.create({ observer in
            self.setImageFromUrl(url) { result in
                switch result {
                case .success(let image):
                    observer.onNext(image)
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        })
        
    }
    
    func rx_setImageFromUrlString(_ urlString: String)-> Observable<UIImage> {
        return Observable.create({ observer in
            self.setImageFromUrlString(urlString) { result in
                switch result {
                case .success(let image):
                    observer.onNext(image)
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        })
    }
}
