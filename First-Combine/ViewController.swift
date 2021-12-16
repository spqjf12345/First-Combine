//
//  ViewController.swift
//  First-Combine
//
//  Created by JoSoJeong on 2021/12/14.
//

import Combine
import Foundation
import UIKit

enum WeatherError: Error {
    case thingsJustHappen
}

let weatherPublisher = PassthroughSubject<Int, WeatherError>()

let subscriber = weatherPublisher
    .filter { $0 > 25 }
    .sink(receiveCompletion: { _ in }, receiveValue: { value in
        print("A summer day of \(value) C")
        })

let anotherSubscriber = weatherPublisher.handleEvents(receiveSubscription: { subscription in
        print("new subscription \(subscription)")
    }, receiveOutput: { output in
            print("new value : output \(output)")
    }, receiveCompletion: { error in
        print("subscription completed with potential error \(error)")
    }, receiveCancel: {
        print("subscrition cancelled")
    }, receiveRequest:  { request in
        print("receiveRequest \(request)")
    }).sink(receiveCompletion: { _ in }, receiveValue: { value in
        print("A summer day of \(value) C")
        })


class ViewController: UIViewController {
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherPublisher.send(10)
        weatherPublisher.send(20)
        weatherPublisher.send(30)
        weatherPublisher.send(40)
        weatherPublisher.send(50)
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}
