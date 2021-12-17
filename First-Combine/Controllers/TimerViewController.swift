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
    
    @IBAction func onTimerStart(_ sender: Any) {
        
        if let timer = mTimer {
            if !timer.isValid {
                mTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                    self.updateDate()
                }
            }
        }else{
            mTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                self.updateDate()
            }
        }

    }
        
    func updateDate(){
        DispatchQueue.main.async() {
            self.number += 1
            self.textLabel.text = String(self.number)
        }
    }
    
    @IBAction func onTimerEnd(_ sender: Any) {
        
        if let timer = mTimer {
            if(timer.isValid){
                timer.invalidate()
            }
        }
        
        DispatchQueue.main.async() {
            self.number = 0
            self.textLabel.text = String(self.number)
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
