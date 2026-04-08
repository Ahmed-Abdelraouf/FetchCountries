//
//  APIService.swift
//  CountiresTask
//
//  Created by Ahmed Abdelraouf on 08/04/2026.
//

import Foundation

typealias APIDecodable = Decodable & Sendable

final class APIService: APIServiceContract {
    func request<T: Decodable & Sendable>(
        _ urlRequest: APIRequestBuilder,
        responseType: T.Type
    ) async throws -> T {
        guard let generatedRequest = urlRequest.getURLRequest() else {
            throw NetworkError.invalidRequest
        }

        let (data, response) = try await URLSession.shared.data(for: generatedRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard NetworkConstants.statusCodeSuccessRange.contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(httpResponse.statusCode)
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}
