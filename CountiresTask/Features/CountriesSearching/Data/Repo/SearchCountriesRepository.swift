//
//  SearchCountriesRepository.swift
//  GlobeCurrency
//
//  Created by Ahmed Abdelraouf on 09/04/2026.
//

import Foundation
import Combine

final class SearchCountriesRepository: SearchCountriesRepositoryProtocol {
    
    private let service: SearchCountriesServiceProtocol
    
    init(service: SearchCountriesServiceProtocol = SearchCountriesService()) {
        self.service = service
    }
    
    func searchCountries(for name: String) async throws -> [Country] {
        return try await service.searchCountries(for: name)
    }
}
