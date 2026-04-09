//
//  MockPermissionsAuth.swift
//  CountiresTaskTests
//
//  Created by NTG on 09/04/2026.
//

import Foundation
import Combine
@testable import CountiresTask

final class MockPermissionsAuthenticator: PermissionsAuthenticatorProtocol {
    var requestAuthorizationStatusCallCount = 0
    var authorizationStatus: AuthorizationStatus = .denied

    func requestAuthorizationStatus(completion: @escaping (AuthorizationStatus) -> Void) {
        requestAuthorizationStatusCallCount += 1
        completion(authorizationStatus)
    }
}

final class MockUserLocationManager: UserLocationManagerProtocol {
    let subject = PassthroughSubject<String, Never>()
    var requestLocationCallCount = 0

    var countryNamePublisher: AnyPublisher<String, Never> {
        subject.eraseToAnyPublisher()
    }

    func requestLocation() {
        requestLocationCallCount += 1
    }
}

final class MockSearchCountriesUseCase: SearchCountriesUseCaseProtocol {
    var executeCallCount = 0
    var receivedCountryName: String?
    var result: [Country]
    var error: Error?

    init(result: [Country] = [], error: Error? = nil) {
        self.result = result
        self.error = error
    }

    func execute(countryName: String) async throws -> [Country] {
        executeCallCount += 1
        receivedCountryName = countryName
        if let error {
            throw error
        }
        return result
    }
}

final class MockCountryPersistenceUseCase: CountryPersistenceUseCaseProtocol {
    var executeFetchCountriesCallCount = 0
    var executeSaveCallCount = 0
    var executeDeleteCallCount = 0

    var fetchCountriesResults: [[Country]]
    var fetchIndex = 0

    var savedCountries: [Country] = []
    var deletedCountries: [Country] = []

    var fetchError: Error?
    var saveError: Error?
    var deleteError: Error?

    init(fetchCountriesResults: [[Country]] = [], fetchError: Error? = nil) {
        self.fetchCountriesResults = fetchCountriesResults
        self.fetchError = fetchError
    }

    func executeFetchCountries() async throws -> [Country] {
        executeFetchCountriesCallCount += 1
        if let fetchError {
            throw fetchError
        }

        guard !fetchCountriesResults.isEmpty else {
            return []
        }

        let safeIndex = min(fetchIndex, fetchCountriesResults.count - 1)
        let result = fetchCountriesResults[safeIndex]
        fetchIndex += 1
        return result
    }

    func executeSave(country: Country) async throws {
        executeSaveCallCount += 1
        if let saveError {
            throw saveError
        }
        savedCountries.append(country)
    }

    func executeDelete(country: Country) async throws {
        executeDeleteCallCount += 1
        if let deleteError {
            throw deleteError
        }
        deletedCountries.append(country)
    }
}

final class MockNetworkMonitorObservableContract: NetworkMonitorObservableContract {
    var isConnected: Bool
    private let subject: CurrentValueSubject<Bool, Never>

    init(initialValue: Bool) {
        subject = CurrentValueSubject(initialValue)
        isConnected = initialValue
    }

    var connectionPublisher: AnyPublisher<Bool, Never> {
        subject.eraseToAnyPublisher()
    }

    func send(_ value: Bool) {
        subject.send(value)
    }
}
