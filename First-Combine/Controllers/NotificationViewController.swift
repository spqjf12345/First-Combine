//
//  NotificationViewController.swift
//  First-Combine
//
//  Created by JoSoJeong on 2021/12/18.
//

import Foundation
import UIKit
import Combine
class UserInfo: NSObject {
    dynamic var lastLogin: Date = Date(timeIntervalSince1970: 0)
}


class NotificationViewController : UIViewController {
    
    var cancellable: Cancellable?
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print("transition")
        print(size.width)
    }
    
    @objc var userInfo = UserInfo()
    var observation: NSKeyValueObservation?


    override func viewDidLoad() {
        super.viewDidLoad()
        cancellable = NotificationCenter.default
            .publisher(for: UIDevice.orientationDidChangeNotification)
            .filter() { _ in UIDevice.current.orientation == .portrait }
            .sink() { _ in print ("Orientation changed to portrait.") }
        cancellable = userInfo.publisher(for: \.lastLogin)
            .sink() { date in print ("lastLogin now \(date).") }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        userInfo.lastLogin = Date()
    }
    
}




