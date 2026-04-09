//
//  CountryPersistenceUseCaseProtocol.swift
//  CountiresTask
//
//  Created by Ahmed Abdelraouf on 09/04/2026.
//

import Foundation

protocol CountryPersistenceUseCaseProtocol {
    func executeSave(country: Country) async throws
    func executeFetchCountries()  async throws -> [Country]
    func executeDelete(country: Country) async throws
}

