//
//  APIService.swift
//  GenericsApiService
//
//  Created by Nabin Shrestha on 5/3/20.
//  Modified by Bart HEYRMAN on 13/01/2025 to accept bearer auth.
//

import Foundation

class APIService {
    
    static let shared = APIService()
    
    func getRequest<T: Codable>(url: URL, type: T.Type, token: String = "", completionHandler: @escaping (T) -> Void, errorHandler: @escaping (String) -> Void) {
        print("GET: --> \(url.absoluteString)")
        var request = URLRequest(url: url)
        if (token != ""){
            
            request.allHTTPHeaderFields = [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(token)"
            ]
        }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error as Any)
                errorHandler(error?.localizedDescription ?? "Error!")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("status code is not 200 it is \(httpStatus.statusCode)")
                errorHandler("Status code is not 200 it is \(httpStatus.statusCode)")
                print(response as Any)
            }
            
            if let mappedResponse = try? JSONDecoder().decode(T.self, from: data) {
                print("Response: <-- \(url.absoluteString)")
                data.printAsJSON()
                completionHandler(mappedResponse)
            }
        }
        
        task.resume()
    }
    
    func postRequest<T: Codable>(url: URL, params: [String: Any], token: String = "", type: T.Type, completionHandler: @escaping (T) -> Void, errorHandler: @escaping (String) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if (token != ""){
            
            request.allHTTPHeaderFields = [
                "Authorization": "Bearer \(token)"
            ]
        }
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
        
        print("POST: --> \(url.absoluteString)")
        params.printAsJSON()
        
        let task = URLSession.shared.uploadTask(with: request, from: jsonData) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error as Any)
                errorHandler(error?.localizedDescription ?? "Error!")
                return
            }
            
            
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                errorHandler("Status code is not 200 it is \(httpStatus.statusCode)")
            }
            
            
            if let mappedResponse = try? JSONDecoder().decode(T.self, from: data) {
                print("Response: <-- \(url.absoluteString)")
                data.printAsJSON()
                completionHandler(mappedResponse)
            }
        }
        
        task.resume()
    }
    
    
}
