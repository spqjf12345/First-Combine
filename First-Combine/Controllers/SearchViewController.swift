//
//  SearchViewController.swift
//  First-Combine
//
//  Created by JoSoJeong on 2022/01/09.
//

import Foundation
import UIKit
import Combine

class SearchViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let clientID        = "9cvmCRUerq0EaIDJWwAl"    // ClientID
    let clientSecret    = "W26r__k9A9"              // ClientSecret
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    let searchViewController = UISearchController(searchResultsController: nil)
    
    func setupSearchBar(){
        let publisher = NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification, object: searchViewController.searchBar.searchTextField)
        publisher.map {
            ($0.object as! UISearchTextField).text
        }
        .sink { (str) in
            print(str ?? "")
        }
    }
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}
