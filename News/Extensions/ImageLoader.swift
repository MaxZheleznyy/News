//
//  ImageLoader.swift
//  News
//
//  Created by Maxim Zheleznyy on 3/10/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import UIKit
import Alamofire

class ImageLoader {

    private let session = Alamofire.Session()
    
    static let shared = ImageLoader()

    func load(url: URLConvertible, completionHandler: @escaping (UIImage) -> Void) -> Void {
        session.request(url).responseData(
            queue: DispatchQueue.global(),
            completionHandler: { response in
                if let data = response.data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        completionHandler(image)
                    }
                }
        })
    }
}
