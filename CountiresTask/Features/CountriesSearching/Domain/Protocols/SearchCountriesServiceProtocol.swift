//
//  SearchCountriesServiceProtocol.swift
//  CountiresTask
//
//  Created by Ahmed Abdelraouf on 09/04/2026.
//

import Foundation

protocol SearchCountriesServiceProtocol {
    func searchCountries(for name: String) async throws -> [Country]
}
