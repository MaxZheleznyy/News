//
//  CountriesViewController.swift
//  News
//
//  Created by Maxim Zheleznyy on 3/26/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import UIKit

protocol CountriesViewControllerDelegate: AnyObject {
    func countryTapped(country: Country)
}

class CountriesViewController: UIViewController {
    
    //MARK: Contants and variables
    var countries: [Country] = []
    
    weak var delegate: CountriesViewControllerDelegate?
    
    let tableView: UITableView = {
        let tb = UITableView()
        tb.translatesAutoresizingMaskIntoConstraints = false
        return tb
    }()
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Countries"
        configureTableView()
    }
    
    //MARK: Initial functions
    private func configureTableView() {
        view.addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "countryCell")
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

//MARK: TableView data source
extension CountriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath)
        cell.textLabel?.text = countries[indexPath.row].name
        cell.detailTextLabel?.text = countries[indexPath.row].flagEmoji
        
        return cell
    }
}

//MARK: TableView delegate
extension CountriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if countries.indices.contains(indexPath.row) {
            let country = countries[indexPath.row]
            
            delegate?.countryTapped(country: country)
            
            if let navController = self.navigationController {
                navController.popViewController(animated: true)
            }
        }
    }
}
