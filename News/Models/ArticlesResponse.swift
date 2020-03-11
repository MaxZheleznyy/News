//
//  ArticlesResponse.swift
//  News
//
//  Created by Maxim Zheleznyy on 3/10/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import Foundation

class ArticlesResponse: Decodable {
    let totalResults: Int
    let articles: [Article]
}
