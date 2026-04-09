//
//  SearchCountriesRepositoryProtocol.swift
//  CountiresTask
//
//  Created by Ahmed Abdelraouf on 09/04/2026.
//

import Foundation

protocol SearchCountriesRepositoryProtocol {
    func searchCountries(for name: String) async throws -> [Country]
}
