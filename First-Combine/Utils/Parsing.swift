//
//  Parsing.swift
//  First-Combine
//
//  Created by JoSoJeong on 2022/01/09.
//

import Foundation
import Combine

func decode<T: Decodable>(_ data: Data) -> AnyPublisher<T, Error> {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .secondsSince1970
    
    return Just(data)
        .decode(type: T.self, decoder: decoder)
//        .mapError{ error in
//            print(error.localizedDescription)
//        }
        .eraseToAnyPublisher()
}
