//
//  NewsViewModel.swift
//  News
//
//  Created by Maxim Zheleznyy on 3/10/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

private let apiKey: String = "2b460536608c4230bdf17bf4cd11b91e"
private let path: String = "https://newsapi.org/v2/top-headlines?apiKey=\(apiKey)&country=us"

enum ClientError: Error {
    case missingResponseData
}

class NewsViewModel {
    
    func pullFreshHeadlines() -> Single<ArticlesResponse> {
        return Single.create { (emitter) -> Disposable in
            
            let session = Alamofire.Session()
            
            session.request(path).responseJSON { (response) in
                if let error = response.error {
                    emitter(.error(error))
                    return
                }
                guard let data = response.data else {
                    emitter(.error(ClientError.missingResponseData))
                    return
                }
                do {
                    let articles = try JSONDecoder().decode(
                        ArticlesResponse.self,
                        from: data)
                    emitter(.success(articles))
                } catch {
                    emitter(.error(error))
                }
            }
            return Disposables.create {
                session.cancelAllRequests()
            }
        }
    }
}
