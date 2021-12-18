//
//  NotificationViewController.swift
//  First-Combine
//
//  Created by JoSoJeong on 2021/12/18.
//

import Foundation
import UIKit
import Combine

class NotificationViewController : UIViewController {
    
    var cancellable: Cancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cancellable = NotificationCenter.default
            .publisher(for: UIDevice.orientationDidChangeNotification)
            .filter() { _ in UIDevice.current.orientation == .portrait }
            .sink() { _ in print ("Orientation changed to portrait.") }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print("transition")
        print(size.width)
    }
}
