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
    
//    private let refreshControlColorArray: [UIColor] =
    
    private var articles: [Article] = []
    private let refreshControlColorArray: [UIColor] = [
        ColorPallete.amazonOrange,
        ColorPallete.airbnbPink,
        ColorPallete.starbuksGreen,
        ColorPallete.twitchPurple,
        ColorPallete.youtubeRed
    ]
    
    private let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        configureTableView()
        configureRefreshControl()
        pullHeadlinesThruViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let index = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
    
    private func configureTableView() {
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: TableViewCellsIdentifiers.newsTableViewCellIdentifier.rawValue)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func configureRefreshControl() {
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        randomizeRefreshControlColor()
        refreshControl.addTarget(self, action: #selector(repullHeadlinesThruViewModel(_:)), for: .valueChanged)
    }
    
    @objc private func repullHeadlinesThruViewModel(_ sender: Any) {
        randomizeRefreshControlColor()
        
        pullHeadlinesThruViewModel()
    }
    
    private func pullHeadlinesThruViewModel() {
        viewModel.pullFreshHeadlines().subscribe(onSuccess: { [weak self] response in
            self?.articles = response.articles
            self?.refreshControl.endRefreshing()
            self?.tableView.reloadData()
            }, onError:  { error in
                self.refreshControl.endRefreshing()
                print("Receive error: \(error)")
        }).disposed(by: disposeBag)
    }
    
    private func randomizeRefreshControlColor() {
        if let nonEmptyColor = refreshControlColorArray.randomElement() {
            refreshControl.tintColor = nonEmptyColor
        } else {
            refreshControl.tintColor = ColorPallete.starbuksGreen
        }
        
        var attributes = [NSAttributedString.Key: AnyObject]()
        attributes[.foregroundColor] = refreshControl.tintColor
        let attributedString = NSAttributedString(string: "Fetching News...", attributes: attributes)

        refreshControl.attributedTitle = attributedString
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
