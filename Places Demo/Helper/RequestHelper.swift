//
//  RequestHelper.swift
//  Places Demo
//
//  Created by Allan Pagdanganan on 03/09/2019.
//  Copyright © 2019 Allan Pagdanganan. All rights reserved.
//

import Foundation
import CoreLocation

class RequestHelper {
    
     func downloadAnnotationImage(fromURL URLString: String, completion: @escaping (Data?) -> Void) {
        
        let baseURL = URL(string: URLString)!
        let request = URLRequest(url: baseURL)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let data = data {
                completion(data)
            } else {
                completion(nil)
                print("No data was returned.")
                return
            }
        }
        task.resume()
    }
    
    
    func getTopPlaces(nearMe locationValue: CLLocationCoordinate2D, completion: @escaping ([Place]?) -> Void) {
        
        let baseURL = URL(string: "https://places.cit.api.here.com/places/v1/discover/explore?")!
        let queries: [String: String] = [
            "app_id":"DemoAppId01082013GAL",
            "app_code":"AJKnXv84fjrb0KIHawS0Tg",
            "size":"10",
            "pretty":"true"
        ]
        
        guard let url = baseURL.withQueries(queries) else {
            completion(nil)
            print("Unable to build URL with supplied queries.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("en-us", forHTTPHeaderField: "Accept-Language")
        request.setValue("geo:\(locationValue.latitude),\(locationValue.longitude)", forHTTPHeaderField: "Geolocation")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            let jsonDecoder = JSONDecoder()
            
            if let data = data,
                let jsonDict = try? jsonDecoder.decode(Json.self, from: data) {
                completion(jsonDict.results.items)
            } else {
                completion(nil)
                print("Either no data was returned, or data was not serialized.")
                return
            }
        }
        task.resume()
    }
}

extension URL {
    
    func withQueries(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.compactMap { URLQueryItem(name: $0.0, value: $0.1)}
        return components?.url
    }
}

