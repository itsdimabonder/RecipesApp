//
//  NetworkService.swift
//  RecipesApp
//
//  Created by Dmitri Bondartchev on 21/11/2024.
//

import Foundation

class NetworkingService {
    
    private let baseURL: URL
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    //MARK: - Create Request
    private func createRequest(endpoint: Endpoint, method: HTTPMethods, body: [String: Any]? = nil, headers: [String: String]? = nil) -> URLRequest? {
        
        let url = baseURL.appendingPathComponent(endpoint.path)
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = endpoint.queryItems
        
        guard let finalURL = components?.url else {
            return nil
        }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue
        
        if let body = body {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                return nil
            }
        }
        
        var allHeaders = headers ?? [:]
        allHeaders["Content-Type"] = "application/json"
        allHeaders.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }

    //MARK: - Request Data
    func request<T: Codable>(for endpoint: Endpoint, method: HTTPMethods, body: [String: Any]? = nil, headers: [String: String]? = nil) async throws -> T {
        
        guard let request = createRequest(endpoint: endpoint, method: method, body: body, headers: headers) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200..<300:
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                return decodedObject
            } catch {
                
                throw NetworkError.decodingFailed(error)
            }
        case 400:
            throw NetworkError.serverError(code: 400, message: "Bad Request")
        case 401:
            throw NetworkError.serverError(code: 401, message: "Unauthorized")
        case 403:
            throw NetworkError.serverError(code: 403, message: "Forbidden")
        case 404:
            throw NetworkError.serverError(code: 404, message: "Not Found")
        case 500:
            throw NetworkError.serverError(code: 500, message: "Internal Server Error")
        default:
            throw NetworkError.serverError(code: httpResponse.statusCode, message: "Unknown Server Error")
        }
    }
}
