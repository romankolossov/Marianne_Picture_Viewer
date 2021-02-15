//
//  NetworkManager.swift
//  MariannePictureViewer
//
//  Created by Roman Kolosov on 14.02.2021.
//

import Foundation

class NetworkManager {
    // Singleton pattern
    static let shared = NetworkManager()
    private init() {}
    
    // MARK: - Some properties
    
    // Error handling
    enum NetworkError: Error {
        case incorrectData
    }
    enum DecoderError: Error {
        case failureInJSONdecoding
    }
    
    // URLSession
    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        //configuration.allowsCellularAccess = false
        let session =  URLSession(configuration: configuration)
        
        return session
    }()
    
    // MARK: - Major methods
    
    private func networkRequest(completion: ((Result<[Any], Error>) -> Void)? = nil) {
        // Lorem Picsum URL used
        // https://picsum.photos/v2/list?page=2&limit=100
        
        // URL constructor
        var urlConstructor = URLComponents()
        
        urlConstructor.scheme = "https"
        urlConstructor.host = "picsum.photos"
        urlConstructor.path = "/v2/list"
        
        urlConstructor.queryItems = [
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "limit", value: "30"),
        ]
        guard let url = urlConstructor.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        //request.allowsCellularAccess = false
        
        // Data task
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    let photos = try JSONDecoder().decode(PhotoQuery.self, from: data)
                    completion?(.success(photos))
                } catch {
                    completion?(.failure(DecoderError.failureInJSONdecoding))
                }
            } else if let error = error {
                #if DEBUG
                print("error in session.dataTask from:\n\(#function)")
                #endif
                completion?(.failure(error))
            }
        }
        dataTask.resume()
    }
    
    // MARK: - Network load method
    
    func loadPhotos(completion: ((Result<[PhotoElement], NetworkError>) -> Void)? = nil) {
        networkRequest() {result in
            switch result {
            case let .success(photos):
                completion?(.success(photos as! [PhotoElement]))
            case .failure:
                completion?(.failure(.incorrectData))
            }
        }
    }
}

