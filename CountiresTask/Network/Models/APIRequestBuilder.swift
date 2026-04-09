//
//  APIRequestBuilder.swift
//  CountiresTask
//
//  Created by Ahmed Abdelraouf on 08/04/2026.
//

import Foundation

class APIRequestBuilder {
    let endpoint: EndPointsContract
    private var request: URLRequest

    init(endpoint: EndPointsContract) {
        self.endpoint = endpoint
        guard let url = URL(string: endpoint.baseURL) else {
            fatalError("Could not create URL: \(endpoint.baseURL)")
            
        }
        self.request = URLRequest(url: url)
    }
    
    func getURLRequest() -> URLRequest? {
        setParameterIfExist()
        request.httpMethod = endpoint.method.rawValue
        setHeadersIfExist()
        return request
        
    }
    
    private func setHeadersIfExist() {
        if let headers = endpoint.headers {
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
    }
    
    private func setParameterIfExist() {
        if let params = endpoint.params {
            switch params {
            case .pathParams(let parameters):
                applyPathParameters(with: parameters)
            case .query(let parameters):
                applyQueryParameters(with: parameters)
            case .body(let parameters):
                applyBodyParameters(with: parameters)
            }
        }

    }
    
    private func applyPathParameters(with params: Parameters) {
        var fullPath = endpoint.path
        for (_, value) in params {
            fullPath += "\(value)/"
        }
        let fullURLString = endpoint.baseURL + fullPath
        if let url = URL(string: fullURLString) {
            self.request = URLRequest(url: url)
        }
    }
    
    private func applyQueryParameters(with params: Parameters) {
        if let url = request.url {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems =  params.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            request.url = components?.url?.absoluteURL
        }
    }
    
    private func applyBodyParameters(with params: Parameters) {
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("Error encoding body parameters: \(error)")
        }
    }
}
