//
//  SearchCountriesService.swift
//  GlobeCurrency
//
//  Created by Ahmed Abdelraouf on 09/04/2026.
//

import Combine

final class SearchCountriesService: SearchCountriesServiceProtocol{
    
    private let apiService: APIServiceContract
    
    init(apiService: APIServiceContract = APIService()) {
        self.apiService = apiService
    }
    
    func searchCountries(for name: String) async throws -> [Country]{
        let requestModel = APIRequestBuilder(endpoint: SearchCountriesEndPoints.searchCountry(name: name))
        return try await apiService.request(requestModel, responseType: [Country].self)
    }
    
    
}
