//
//  NetworkService.swift
//  TheBigBangTheory
//
//  Created by Eduardo Santiz on 4/8/19.
//  Copyright © 2019 EduardoSantiz. All rights reserved.
//

import UIKit

class NetworkService {
    let urlSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    func downloadData(from url: String, completion: @escaping (Data?) -> Void) {
        dataTask?.cancel()
        guard let validURL = URL(string: url) else {
            completion(nil)
            return
        }
        
        urlSession.dataTask(with: validURL) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            
            if let jsonData = data {
                completion(jsonData)
            } else {
                completion(nil)
            }
        }.resume()
    }
    
    func downloadImage(from url: URL?, completion: @escaping (UIImage?) -> Void) {
        dataTask?.cancel()
        guard let validURL = url else {
            completion(nil)
            return
        }
        
        urlSession.dataTask(with: validURL) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            if let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }.resume()
    }
}
