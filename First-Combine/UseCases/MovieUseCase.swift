//
//  SearchService.swift
//  First-Combine
//
//  Created by JoSoJeong on 2022/01/09.
//

import Foundation
import Combine
import UIKit

protocol MovieUseCaseType {
  func searchMovies() -> AnyPublisher<Result<Movie, Error>, Never>
  func movieDetail() -> AnyPublisher<Result<Movie, Error>, Never>
  func loadImage() -> AnyPublisher<UIImage?, Never>
}

class MovieUseCase: MovieUseCaseType {
 
    
    
}
