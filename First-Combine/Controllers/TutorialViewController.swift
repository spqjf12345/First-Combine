//
//  TutorialViewController.swift
//  First-Combine
//
//  Created by JoSoJeong on 2021/12/16.
//

import Foundation
import UIKit
import Combine

class TutorialViewController: UIViewController {
    //@IBOutlet weak var tableView: UITableView!
    
    let studingList = [String]()
    var subscriptions = [AnyCancellable]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //studingList.publisher.bind(subscribers: tableView.rowsSubscriber(cell))
        
        let publisherJust = Just("uri")
//        let subscriberJust = publisherJust.sink(receiveValue: { value in
//            print(value)
//        })
        
        let subscriber = publisherJust.sink(receiveCompletion: { (result) in switch result {
        case .finished:
            print("finished")
        case .failure(let error):
            print(error.localizedDescription)
            }
        }, receiveValue: { (value) in
            print(value)
            
        })

        
            
        
    }
    
    
}
