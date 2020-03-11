//
//  ViewController.swift
//  News
//
//  Created by Maxim Zheleznyy on 3/10/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel = NewsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.headlines().subscribe(onSuccess: { (response) in
            print("Receive news: \(response)")
        }, onError: { (error) in
            print("Receive error: \(error)")
        }).disposed(by: disposeBag)
    }
}

