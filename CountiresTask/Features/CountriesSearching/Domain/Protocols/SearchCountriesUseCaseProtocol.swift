//
//  SearchCountriesUseCaseProtocol.swift
//  CountiresTask
//
//  Created by Ahmed Abdelraouf on 09/04/2026.
//

import Foundation

protocol SearchCountriesUseCaseProtocol {
    func execute(countryName: String) async throws -> [Country]
}
