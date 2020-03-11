//
//  UIImageViewExtension.swift
//  News
//
//  Created by Maxim Zheleznyy on 3/10/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import UIKit
import Alamofire

extension UIImageView {
    func load(url: URLConvertible) {
        backgroundColor = .lightGray
        image = nil

        ImageLoader.shared.load(url: url) { [weak self] image in
            self?.backgroundColor = nil
            self?.image = image
        }
    }
}
