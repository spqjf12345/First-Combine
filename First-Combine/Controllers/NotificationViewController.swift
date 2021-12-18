//
//  NotificationViewController.swift
//  First-Combine
//
//  Created by JoSoJeong on 2021/12/18.
//

import Foundation
import UIKit

class NotificationViewController : UIViewController {
    var notificationToken: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationToken = NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: nil) { _ in
            if UIDevice.current.orientation == .portrait {
                print("orientation changed to portrait")
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print("transition")
        print(size.width)
    }
}
