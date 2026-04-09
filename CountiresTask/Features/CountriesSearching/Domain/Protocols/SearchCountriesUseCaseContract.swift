//
//  SearchCountriesUseCaseContract.swift
//  GlobeCurrency
//
//  Created by Ahmed Abdelraouf on 09/04/2026.
//

import Combine

protocol SearchCountriesUseCaseProtocol {
    func execute(countryName: String) async throws -> [Country]
}
