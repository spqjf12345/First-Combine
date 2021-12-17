//
//  TimerViewController.swift
//  First-Combine
//
//  Created by JoSoJeong on 2021/12/18.
//

import Foundation
import Combine
import UIKit

class TimerViewController: UIViewController {
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var endButton: UIButton!
    @IBOutlet weak var textLabel: UILabel!
    
    var mTimer : Timer?
    var number: Int = 0
    var cancellable: Cancellable?
    
    @IBAction func onTimerStart(_ sender: Any) {
        cancellable = Timer.publish(every: 1, on: .main, in: .default)
           .autoconnect()
           .receive(on: DispatchQueue.main)
           .sink(receiveValue: { date in
               self.textLabel.text = date.description
           })

    }
        
    func updateDate(){
        DispatchQueue.main.async() {
            self.number += 1
            self.textLabel.text = String(self.number)
        }
    }
    
    @IBAction func onTimerEnd(_ sender: Any) {
        cancellable?.cancel()
        self.textLabel.text = "0"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
