//
//  ViewController.swift
//  First-Combine
//
//  Created by JoSoJeong on 2021/12/14.
//

import Combine
import Foundation
import UIKit
import SwiftUI

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var listModel = ListViewModel()
    var cancelBags = Set<AnyCancellable>()
    
    lazy var tutorialViewController: TutorialViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "TutorialViewController") as! TutorialViewController
        return viewController
    }()
    
    lazy var timerViewController: TimerViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "TimerViewController") as! TimerViewController
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.listModel.requestList()
    }



}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listModel.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.listModel.list[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 0){
            self.navigationController?.pushViewController(tutorialViewController, animated: true)
        }else if(indexPath.row == 1){
            self.navigationController?.pushViewController(timerViewController, animated: true)
        }
    }
    
    
}
