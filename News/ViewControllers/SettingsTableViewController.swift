//
//  SettingsTableViewController.swift
//  News
//
//  Created by Maxim Zheleznyy on 3/31/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    //MARK: Contants and variables
    let settingsViewModel = SettingsViewModel()

    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let indexPaths = self.tableView.indexPathsForSelectedRows {
            for index in indexPaths {
                self.tableView.deselectRow(at: index, animated: true)
            }
        }
    }
    
    //MARK: Actions
    @IBAction func doneAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

extension SettingsTableViewController {
    
    // MARK: - TableView configuration
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return super.tableView(tableView, numberOfRowsInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let countriesVC = CountriesViewController()
            countriesVC.countries = settingsViewModel.countries
            self.navigationController?.pushViewController(countriesVC, animated: true)
        case 1:
            print("color")
        case 2:
            print("🤓")
        default:
            tableView.selectRow(at: nil, animated: true, scrollPosition: .none)
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
