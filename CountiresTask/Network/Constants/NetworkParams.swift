//
//  NetworkHTTPMethods.swift
//  CountiresTask
//
//  Created by Ahmed Abdelraouf on 08/04/2026.
//

import Foundation

typealias Parameters = [String: Any]
enum RequestParams {
    case pathParams(_: Parameters)
    case body(_: Parameters)
    case query(_: Parameters)
}
