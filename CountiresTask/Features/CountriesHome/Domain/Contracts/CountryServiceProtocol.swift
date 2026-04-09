//
//  CountryServiceProtocol.swift
//  CountiresTask
//
//  Created by Ahmed Abdelraouf on 09/04/2026.
//

import Foundation

protocol CountryServiceProtocol {
    func save(country: Country) async throws
    func fetchCountries() async throws -> [Country]
    func delete(country: Country) async throws
}
