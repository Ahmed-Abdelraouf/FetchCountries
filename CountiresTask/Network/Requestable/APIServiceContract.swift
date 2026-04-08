//
//  APIServiceContract.swift
//  CountiresTask
//
//  Created by Ahmed Abdelraouf on 08/04/2026.
//

import Combine

protocol APIServiceContract {
    func request<T: Decodable & Sendable>(
        _ urlRequest: APIRequestBuilder,
        responseType: T.Type
    ) async throws -> T
}
