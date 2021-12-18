//
//  ListViewModel.swift
//  First-Combine
//
//  Created by JoSoJeong on 2021/12/16.
//

import Foundation
import Combine

class ListViewModel {
    @Published var list: [Person] = []
    var cancelBag = Set<AnyCancellable>()
    func requestList() {
        list.append(Person(name: "Tutorial"))
        list.append(Person(name: "Timer"))
        list.append(Person(name: "Notification"))
    }
//    func requestList() {
//        let url = URL(string: "http://localhost:8080/getJSON")!
//        URLSession.shared.dataTaskPublisher(for: url)
//        //.print()
//        .map(\.data)
//        .decode(type: [Person].self, decoder: JSONDecoder())
//        .replaceError(with: [])
//        //.eraseToAnyPublisher()
//        .assign(to: \.list, on: self)
//        .store(in: &self.cancelBag)
//    }
}



