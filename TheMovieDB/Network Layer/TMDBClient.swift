//
//  TMDBClient.swift
//  TheMovieDB
//
//  Created by Aanchal Patial on 16/10/22.
//

import Foundation
import UIKit

class TMDBClient {
    
    static let apiKey = "38a73d59546aa378980a88b645f487fc"

    // MARK: - GET Request
    @discardableResult func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type,
                                                                       completionHandler: @escaping (ResponseType?, Error?)->Void) -> URLSessionTask {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
                return
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(responseObject, nil)
                }
            }catch {
                do {
                    let errorResponse = try decoder.decode(TMDBResponse.self, from: data)
                    DispatchQueue.main.async {
                        completionHandler(nil, errorResponse)
                    }
                }catch {
                    DispatchQueue.main.async {
                        completionHandler(nil, error)
                    }
                }
            }
        }
        task.resume()
        return task
    }

    // MARK: - POST Request
    func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, requestObject: RequestType,
                                                                             responseType: ResponseType.Type,
                                                                             completionHandler: @escaping (ResponseType?, Error?)->Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        let requestBody = try! encoder.encode(requestObject)
        request.httpBody = requestBody

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
                return
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(responseObject, nil)
                }
            }catch {
                do {
                    let errorResponse = try decoder.decode(TMDBResponse.self, from: data)
                    DispatchQueue.main.async {
                        completionHandler(nil, errorResponse)
                    }
                }catch {
                    DispatchQueue.main.async {
                        completionHandler(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
}

extension TMDBClient {

    func requestImageFile(url imageUrl: URL, completionHandler: @escaping (UIImage?, Error?)->Void){
        let task = URLSession.shared.dataTask(with: imageUrl) {
            (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
                return
            }
            let movieImage = UIImage(data: data)
            DispatchQueue.main.async {
                completionHandler(movieImage, nil)
            }
        }
        task.resume()
    }
}

