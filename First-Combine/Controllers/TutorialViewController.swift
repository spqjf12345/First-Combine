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
    @IBOutlet weak var filterField: UITextField!
    let studingList = [String]()
    var subscriptions = [AnyCancellable]()
    
    var listViewModel = ListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //puToSu()
        //notification()
        //personPublisher()
        //currentValueSubject()
        //passthroughSubject()
        //switchtoLatest()
        //networtSwitchToLatest()
        //mergeOperator()
        //multicast()
        //setScheduler()
        //cancellable
        handleEvent()
        
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
        
        
        let publisher = passthroughSubject.eraseToAnyPublisher() // PassthroughSubject였다는 사실을 숨김
        // no send(_:)
        
    }
    
    func switchtoLatest(){
        let publisher1 = PassthroughSubject<Int, Never>()
        let publisher2 = PassthroughSubject<Int, Never>()
        let publisher3 = PassthroughSubject<Int, Never>()
        
        let publishers = PassthroughSubject<PassthroughSubject<Int, Never>, Never>()
        
        publishers.switchToLatest()
            .sink(receiveCompletion: { _ in
                print("Completed")},
            receiveValue: { print($0)})
            .store(in: &subscriptions)
        
        publishers.send(publisher1)
        publisher1.send(1)
        publisher1.send(2)
        
        //publisher2 보내서 publisher1의 subscription 취고
        publishers.send(publisher2)
        publisher1.send(3)
        publisher2.send(4)
        publisher2.send(5)
        
        publishers.send(publisher3)
        publisher2.send(6)
        publisher3.send(7)
        publisher3.send(8)
        publisher3.send(9)
        
        publisher3.send(completion: .finished)
        publishers.send(completion: .finished)
    
    }
    
    func networtSwitchToLatest(){
        let url = URL(string: "https://source.unsplash.com/random")!
        
        func getImage() -> AnyPublisher<UIImage?, Never> {
            print("here here")
            return URLSession.shared.dataTaskPublisher(for: url)
                .map { data, _ in UIImage(data: data)}
                .print("image")
                .replaceError(with: nil)
                .eraseToAnyPublisher()
        }
        
        let taps = PassthroughSubject<Void, Never>()
        taps
            .map { _ in getImage() }
            .switchToLatest()
            .sink(receiveCompletion: { _ in
                print("Completed")},
            receiveValue: { print($0)})
            .store(in: &subscriptions)
        
        taps.send()
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            taps.send()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.1) {
            taps.send()
        }
        
    }
    
    
    func mergeOperator(){
        let publisher1 = PassthroughSubject<Int, Never>()
        let publisher2 = PassthroughSubject<Int, Never>()

        publisher1.merge(with: publisher2).sink(receiveCompletion: { _ in
            print("Completed")
        }, receiveValue: { print($0) })
        
        publisher1.send(1)
        publisher1.send(2)
        
        publisher2.send(3)
        publisher1.send(4)
        publisher2.send(5)
        
        publisher1.send(completion: .finished)
        publisher2.send(completion: .finished)
        
    }
    
    func multicast(){
        // 1. 업스트림 publisher가 방출하는 값과 완료 이벤트를 전달할 subject를 준비합니다.
        let subject = PassthroughSubject<Data, URLError>()
        // 2. 위의 subject를 사용하여 멀티캐스트 publisher를 준비합니다.
        let multicasted = URLSession.shared
          .dataTaskPublisher(for: URL(string: "https://medium.com/@rkdthd0403")!)
          .map(\.data)
          .print("shared")
          .multicast(subject: subject)
        // 3. 공유(멀티캐스트) 된 publisher를 구독합니다.
        let subscription1 = multicasted
          .sink(
            receiveCompletion: { _ in },
            receiveValue: { print("subscription1 received: '\($0)'") }
          )
        let subscription2 = multicasted
          .sink(
            receiveCompletion: { _ in },
            receiveValue: { print("subscription2 received: '\($0)'") }
          )
        // 4. publisher(multicasted)에게 업스트림 publisher에 연결하도록 합니다.
        multicasted.connect()
        // 5. 두 구독 모두 데이터를 수신하는지 테스트하기 위해 빈 데이터 전송합니다.
        subject.send(Data())
    }
    
    func setScheduler(){
        let publisher = ["Uri"].publisher
        publisher.map {
            _ in print(Thread.isMainThread)
        }.receive(on: DispatchQueue.global())
            .map{ print(Thread.isMainThread)}
            .sink { print(Thread.isMainThread)}
        
    }
    
    func cancellable(){
        let subject = PassthroughSubject<Int, Never>()
        let subscriber = subject.sink(receiveValue: { value in print(value) })
        subscriber.cancel()
        subject.send(1)
        
        var bag = Set<AnyCancellable>()
        let subjects = PassthroughSubject<Int, Never>()
        subjects.sink(receiveValue: { value in
            print(value)
        })
            .store(in: &bag)

        
    }
    
    func handleEvent(){
        let subject = PassthroughSubject<String, Error>()
        let subscriber = subject.handleEvents(receiveSubscription: { (subscription) in
            print("Receive Subscription") // 1
        }, receiveOutput: { output in
            print("Receive Output : \(output)") // 3
        }, receiveCompletion: { (completion) in
            print("Receive Completion")
            switch completion {
                case .finished:
                    print("finished")
                case .failure(let error):
                    print(error) }
        }, receiveCancel: {
            print("Receive Cancel") // 5
        }, receiveRequest: { demand in
            print("Receive Request: \(demand)") // 2
        }).sink(receiveCompletion: { (completion) in
            switch completion {
                case .finished:
                    print("finished")
                case .failure(let error):
                print(error)
            } }
        , receiveValue: { (value) in
            print("Receive Value in sink : \(value)") // 4
        })
        
        subject.send("Uri")
        subscriber.cancel()
    }
    

    
    
}
