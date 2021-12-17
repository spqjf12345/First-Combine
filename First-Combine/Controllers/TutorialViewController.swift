//
//  TutorialViewController.swift
//  First-Combine
//
//  Created by JoSoJeong on 2021/12/16.
//

import Foundation
import UIKit
import Combine
import SwiftUI

class UriSubscriber: Subscriber {
    
    typealias Input = String
    
    typealias Failure = Never
    
    func receive(subscription: Subscription) { //1. subscriber에게 publisher를 성공적으로 구독했음을 알리고 item 요청
        print("receive(subscription: Subscription)")
        subscription.request(.unlimited)
    }
    
    func receive(_ input: String) -> Subscribers.Demand { //2. subscriber에게 publisher가 element를 생성했음을 알림
        print("receive(_ input: String) -> Subscribers.Demand")
        return .none
    }
    
    func receive(completion: Subscribers.Completion<Never>) { //3. publisher에게 publisher가 정상적으로 또는 오류로 publish를 완료했음을 알림
        print("receive(completion: Subscribers.Completion<Never>)")
    }
    
}


class TutorialViewController: UIViewController {
    //@IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterField: UITextField!
    let studingList = [String]()
    var subscriptions = [AnyCancellable]()
    
    var listViewModel = ListViewModel()
    @Published var people = [[Person(name: "Julia"), Person(name: "Vicki")]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //puToSu()
        notification()
        personPublisher()
        //currentValueSubject()
        passthroughSubject()

        
    }
    func puToSu(){
        //studingList.publisher.bind(subscribers: tableView.rowsSubscriber(cell))
        
        let publisherJust = Just("uri")
//        let subscriberJust = publisherJust.sink(receiveValue: { value in
//            print(value)
//        })
        
        //sink 방식
        let subscriber = publisherJust.sink(receiveCompletion: { (result) in switch result {
        case .finished:
            print("finished")
        case .failure(let error):
            print(error.localizedDescription)
            }
        }, receiveValue: { (value) in
            print(value)
            
        })
        
        //subscribe 방식
        publisherJust.subscribe(UriSubscriber())
        
    }
    
    func notification(){
        let myNotification =  Notification.Name("MyNotification")
        let publisher = NotificationCenter.default.publisher(for: myNotification, object: nil)
        let center = NotificationCenter.default
            
        let subscription = publisher.sink { _ in
            print("Notification received from a publisher!")
        }
        
        center.post(name: myNotification, object: nil)
        subscription.cancel()
    }
    
    func personPublisher(){
//        CurrentValueSubject
//        PassthroughSubject
        
    }
    
    func currentValueSubject(){
        let currentValueSubject = CurrentValueSubject<String, Never>("Uri")
        let subscriber = currentValueSubject.sink(receiveValue: {
            print($0)
        })
        currentValueSubject.value = "안녕"
        currentValueSubject.send("하이")
    }
    
    func passthroughSubject(){
        let passthroughSubject = PassthroughSubject<String, Never>()
//        let subscriber = passthroughSubject.sink(receiveValue: {
//            print($0)
//        })
        
        let subscriber = passthroughSubject.sink(receiveCompletion: { (result) in
            switch result {
            case .finished:
                print("finished")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }, receiveValue:  { value in
            print(value)
        })
        passthroughSubject.send("hey")
        passthroughSubject.send("uri")
        passthroughSubject.send(completion: .finished)
        passthroughSubject.send("출력 안될 것")
        
    }
    

    
    
}
