//
//  CountryPersistenceUseCase.swift
//  CountiresTask
//
//  Created by Ahmed Abdelraouf on 09/04/2026.
//

import Foundation

final class CountryPersistenceUseCase: CountryPersistenceUseCaseProtocol {
    private let countryRepository: CountryRepositoryProtocol
    
    init(countryRepository: CountryRepositoryProtocol = CountryRepository()) {
        self.countryRepository = countryRepository
    }

    func executeSave(country: Country) async throws {
        return try await  countryRepository.save(country: country)
    }
    
    func executeFetchCountries() async throws -> [Country] {
        return try await countryRepository.fetchCountries()
    }
    
    func executeDelete(country: Country) async throws {
        return try await countryRepository.delete(country: country)
    }
    
    
}
