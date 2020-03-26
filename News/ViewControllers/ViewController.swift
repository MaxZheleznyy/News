//
//  ViewController.swift
//  News
//
//  Created by Maxim Zheleznyy on 3/10/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher
import SafariServices

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let refreshControl = UIRefreshControl()
    
    private let disposeBag = DisposeBag()
    private let viewModel = NewsViewModel()
    
    private let refreshControlColorArray: [UIColor] = [
        ColorPallete.amazonOrange,
        ColorPallete.airbnbPink,
        ColorPallete.youtubeRed
    ]
    
    private var articles: [Article] = [] {
        didSet {
            if articles.count <= 0 {
                tableView.isHidden = true
            } else {
                tableView.isHidden = false
                tableView.separatorStyle = .singleLine
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureRefreshControl()
        configureBottomToolBar()
        pullHeadlinesThruViewModel()
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let index = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
    
    private func configureTableView() {
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.cellIdentifier)
        
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
    
    private func randomizeRefreshControlColor() {
        if let nonEmptyColor = refreshControlColorArray.randomElement() {
            refreshControl.tintColor = nonEmptyColor
        } else {
            refreshControl.tintColor = ColorPallete.amazonOrange
        }
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
    
    private func configureBottomToolBar() {
        let settingsImage = UIImage(systemName: "gear")?.withTintColor(.label, renderingMode: .alwaysOriginal)
        let settingsButton = UIBarButtonItem(image: settingsImage, landscapeImagePhone: nil, style: .plain, target: self, action: #selector(settingsTapped))

        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        toolbarItems = [settingsButton, spacer]
        
        navigationController?.setToolbarHidden(false, animated: false)
    }
    
    @objc func settingsTapped() {
        print("settings tapped")
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
        guard let tableViewCell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.cellIdentifier, for: indexPath) as? NewsTableViewCell else {
            return UITableViewCell()
        }

        let article = articles[indexPath.row]
        tableViewCell.titleLabel.text = article.title
        tableViewCell.contentLabel.text = configureContentText(textToConfigure: article.content)

        if let stringedURLToImage = article.urlToImage, let urlToImage = URL(string: stringedURLToImage) {
            tableViewCell.isHidden = false
            
            tableViewCell.thumbnailView.kf.indicatorType = .activity
            tableViewCell.thumbnailView.kf.setImage(with: urlToImage) { result in
                switch result {
                case .success(let value):
                    print("Do any additional required work with \(value)")
                case .failure(let error):
                    let placeholderImage = UIImage(named: "newsCellPlaceholder")
                    tableViewCell.thumbnailView.image = placeholderImage
                    print("Job failed: \(error.localizedDescription)")
                }
            }
        } else {
            let placeholderImage = UIImage(named: "newsCellPlaceholder")
            tableViewCell.thumbnailView.image = placeholderImage
        }

        return tableViewCell
    }

    
    private func configureContentText(textToConfigure: String?) -> String {
        if let nonEmtptyTextToConfigure = textToConfigure, nonEmtptyTextToConfigure != "",
            nonEmtptyTextToConfigure.contains("getSimpleString(data.title)") == false {
            return nonEmtptyTextToConfigure
        } else {
            return "Check out the article by tapping it"
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = articles[indexPath.row]
        present(SFSafariViewController(url: article.url), animated: true, completion: nil)
    }
}
