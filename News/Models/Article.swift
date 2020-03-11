//
//  Article.swift
//  News
//
//  Created by Maxim Zheleznyy on 3/10/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import Foundation

class Article: Decodable {
    let title: String
    let description: String?
    let url: URL
    let urlToImage: String?
    let content: String?
}
