//
//  SearchCountriesUseCase.swift
//  GlobeCurrency
//
//  Created by Ahmed Abdelraouf on 09/04/2026.
//

import Combine

final class SearchCountriesUseCase: SearchCountriesUseCaseProtocol{
    private let repository: SearchCountriesRepositoryProtocol
    
    init(repository: SearchCountriesRepositoryProtocol = SearchCountriesRepository()) {
        self.repository = repository
    }
    
    func execute(countryName: String) async throws -> [Country]{
        return try await repository.searchCountries(for: countryName)
    }
    
    
}
