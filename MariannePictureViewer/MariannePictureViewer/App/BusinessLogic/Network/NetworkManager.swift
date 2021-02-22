//
//  NetworkManager.swift
//  MariannePictureViewer
//
//  Created by Roman Kolosov on 14.02.2021.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    // MARK: - Some properties
    var nextFromPage: Int = 2
    
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
    
    private func networkRequest(for page: Int, completion: ((Result<[Any], Error>) -> Void)? = nil) {
        // Lorem Picsum URL used
        // https://picsum.photos/v2/list?page=2&limit=100
        
        guard page >= 1 else { return }
        
        // URL constructor
        var urlConstructor = URLComponents()
        
        urlConstructor.scheme = "https"
        urlConstructor.host = "picsum.photos"
        urlConstructor.path = "/v2/list"
        
        urlConstructor.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
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
        let page: Int = 1
        
        networkRequest(for: page) {result in
            switch result {
            case let .success(photos):
                completion?(.success(photos as! [PhotoElement]))
            case .failure:
                completion?(.failure(.incorrectData))
            }
        }
    }
    
    func loadPartPhotos(from page: Int, completion: ((Result<[PhotoElement], NetworkError>) -> Void)? = nil) {
        networkRequest(for: page) {result in
            switch result {
            case let .success(photos):
                completion?(.success(photos as! [PhotoElement]))
            case .failure:
                completion?(.failure(.incorrectData))
            }
        }
        print("!!!!!!!!!!!!!loaded from page: ", (NetworkManager.shared.nextFromPage))
        NetworkManager.shared.nextFromPage = page + 1
    }
}
 
