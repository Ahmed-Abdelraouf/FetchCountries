//
//  SearchCountriesServiceContract.swift
//  GlobeCurrency
//
//  Created by Ahmed Abdelraouf on 09/04/2026.
//

import Combine

protocol SearchCountriesServiceProtocol {
    func searchCountries(for name: String) async throws -> [Country]
}
