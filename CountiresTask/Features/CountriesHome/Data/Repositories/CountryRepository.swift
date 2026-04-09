//
//  CountryRepository.swift
//  CountiresTask
//
//  Created by Ahmed Abdelraouf on 09/04/2026.
//

import Combine

final class CountryRepository: CountryRepositoryProtocol{
    private let countryService: CountryServiceProtocol
    
    init(countryService: CountryServiceProtocol = CountryService()) {
        self.countryService = countryService
    }
    
    func save(country: Country) async throws {
        return try await countryService.save(country: country)
    }
    
    func fetchCountries() async throws -> [Country] {
        return try await countryService.fetchCountries()
    }
    
    func delete(country: Country) async throws {
        return try await countryService.delete(country: country)
    }
}
