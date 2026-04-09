//
//  CountryService.swift
//  CountiresTask
//
//  Created by Ahmed Abdelraouf on 09/04/2026.
//

import Foundation

final class CountryService: CountryServiceProtocol {
    private let cachingManager: FileCacheManagerProtocol
    
    init(cachingManager: FileCacheManagerProtocol = FileCacheManager(fileName: Constants.cachingFileName)) {
        self.cachingManager = cachingManager
    }
    
    func save(country: Country) async throws  {
        return try await cachingManager.save(country)
    }
    
    func fetchCountries() async throws -> [Country] {
        return try await  cachingManager.fetchAll()
    }
    
    func delete(country: Country) async throws {
        return try await  cachingManager.delete(country)
    }
    
    
}
