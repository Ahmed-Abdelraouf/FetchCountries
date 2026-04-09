//
//  SearchCountriesEndPoints.swift
//  CountiresTask
//
//  Created by Ahmed Abdelraouf on 09/04/2026.
//

import Foundation

enum SearchCountriesEndPoints: EndPointsContract {
    case searchCountry(name: String)
    
    var path: String {
        return NetworkConstants.searchByNamePath
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var params: RequestParams? {
        switch self {
        case .searchCountry(let name):
            return .pathParams(["name": name])
        }
    }
    
}
