//
//  ViewController.swift
//  News
//
//  Created by Maxim Zheleznyy on 3/10/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import UIKit
import RxSwift
import SafariServices

class ViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel = NewsViewModel()
    
    private var articles: [Article] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: TableViewCellsIdentifiers.newsTableViewCellIdentifier.rawValue)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 134
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
        tableView.delegate = self
        tableView.dataSource = self
        
        viewModel.headlines().subscribe(onSuccess: { [weak self] response in
            self?.articles = response.articles
            self?.tableView.reloadData()
        }, onError: { (error) in
            print("Receive error: \(error)")
        }).disposed(by: disposeBag)
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: TableViewCellsIdentifiers.newsTableViewCellIdentifier.rawValue, for: indexPath) as! NewsTableViewCell

        let article = articles[indexPath.row]
        tableViewCell.titleLabel.text = article.title
        tableViewCell.contentLabel.text = article.content

        if let urlToImage = article.urlToImage {
            tableViewCell.isHidden = false
            tableViewCell.thumbnailView.load(url: urlToImage)
        } else {
            tableViewCell.isHidden = true
        }

        return tableViewCell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = articles[indexPath.row]
        present(SFSafariViewController(url: article.url), animated: true, completion: nil)
    }
}
