//
//  NetworkService.swift
//  MyWeather
//
//  Created by Дмитрий Садырев on 14.05.2022.
//

import Alamofire

protocol Networking {
    func requestData(url: URL, parameters: [String: String], completion: @escaping (Data?, Error?) -> Void)
}

class NetworkService: Networking {
    
    func requestData(url: URL, parameters: [String: String], completion: @escaping (Data?, Error?) -> Void) {
        AF.request(url, method: .get, parameters: parameters).responseData { response in
            completion(response.data, response.error)
        }
    }
    
}
