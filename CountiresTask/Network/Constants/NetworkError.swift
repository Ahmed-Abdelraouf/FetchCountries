//
//  NetworkError.swift
//  CountiresTask
//
//  Created by Ahmed Abdelraouf on 08/04/2026.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case invalidResponse
    case invalidRequest
    case custom(error: String)
    case httpError(Int)
    case decodingError(Error)
}
