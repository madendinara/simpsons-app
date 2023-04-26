//
//  Network.swift
//  simpsons-app
//
//  Created by Динара Зиманова on 4/26/23.
//

import UIKit

enum Errors: Error{
    case networkError
    case jsonError
    case noResult
    case emptySearchBar
    
    var message: String {
        switch self {
        case .jsonError:
            return "Decoding error"
        case .networkError:
            return "Network error"
        case .noResult:
            return "No result"
        case .emptySearchBar:
            return "Empty Bar"
        }
    }
    
    var title: String {
        switch self {
        case .jsonError:
            return "JsonError"
        case .networkError:
            return "NetworkError"
        case .noResult:
            return "No Result"
        case .emptySearchBar:
            return "SearchBar Empty"
        }
    }
}

class Network {
    
    func fetchDataWith(onCompletion : @escaping (Result<Character,Error>) -> Void) {
        
        let url = SharedInfo.shared.url
        
        guard let stringUrl = URL(string: url) else {
            onCompletion(.failure(Errors.jsonError))
            return
        }
        
        URLSession.shared.dataTask(with: stringUrl, completionHandler: { data, urlResponse, error in
            if let _ = error {
                onCompletion(.failure(Errors.networkError))
                return
            }
            
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(Character.self, from: data)
                        onCompletion(.success(response))
                    } catch _ {
                        onCompletion(.failure(Errors.jsonError))
                    }
                }
        }).resume()
    }
}

