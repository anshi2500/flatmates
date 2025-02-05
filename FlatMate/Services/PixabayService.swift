//
//  PixabayService.swift
//  FlatMate
//
//  Created by Ivan on 2025-02-04.
//


import Foundation
import Combine

/// Represents the entire JSON response from Pixabay



class PixabayService: ObservableObject {
    
    private lazy var apiKey: String = {
        guard
            let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path) as? [String: Any],
            let key = dict["PIXABAY_API_KEY"] as? String
        else {
            fatalError("Couldn't find 'PIXABAY_API_KEY' in Secrets.plist.")
        }
        return key
    }()
 
    func fetchImages(query: String) -> AnyPublisher<[PixabayImage], Error> {
        
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        
        let urlString = "https://pixabay.com/api/?key=\(apiKey)&q=\(encodedQuery)&image_type=photo"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { (data, response) -> Data in
               
                return data
            }
            // Decode the JSON into `PixabayResponse`
            .decode(type: PixabayResponse.self, decoder: JSONDecoder())
            .map { $0.hits }
            .receive(on: DispatchQueue.main)
            // Convert to an AnyPublisher
            .eraseToAnyPublisher()
    }
}
