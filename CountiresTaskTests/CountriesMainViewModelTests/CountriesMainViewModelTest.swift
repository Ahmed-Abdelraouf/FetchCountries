//
//  CountriesMainViewModelTest.swift
//  CountiresTaskTests
//
//  Created by Ahmed Abdelraouf on 09/04/2026.
//
import XCTest
import Combine
@testable import CountiresTask

@MainActor
final class CountriesMainViewModelTests: XCTestCase {
    private var cancellables: Set<AnyCancellable> = []

    func test_onAppear_firstTime_requestsPermission() {
        let permissionAuthenticator = MockPermissionsAuthenticator()
        let locationManager = MockUserLocationManager()
        let searchUseCase = MockSearchCountriesUseCase()
        let persistenceUseCase = MockCountryPersistenceUseCase()
        let networkMonitor = MockNetworkMonitorObservableContract(initialValue: true)

        let sut = CountriesMainViewModel(
            permissionAuthenticator: permissionAuthenticator,
            locationManager: locationManager,
            searchCountriesUseCase: searchUseCase,
            countriesPersistenceUseCase: persistenceUseCase,
            networkMonitor: networkMonitor
        )

        sut.onAppear()

        XCTAssertEqual(permissionAuthenticator.requestAuthorizationStatusCallCount, 1)
    }

    func test_refreshCountries_whenCacheIsEmptyAndOffline_showsOfflineSnackBar() async {
        let permissionAuthenticator = MockPermissionsAuthenticator()
        let locationManager = MockUserLocationManager()
        let searchUseCase = MockSearchCountriesUseCase()
        let persistenceUseCase = MockCountryPersistenceUseCase(fetchCountriesResults: [[]])
        let networkMonitor = MockNetworkMonitorObservableContract(initialValue: false)

        let sut = CountriesMainViewModel(
            permissionAuthenticator: permissionAuthenticator,
            locationManager: locationManager,
            searchCountriesUseCase: searchUseCase,
            countriesPersistenceUseCase: persistenceUseCase,
            networkMonitor: networkMonitor
        )

        let exp = expectation(description: "offline snackbar shown")

        sut.$showOfflineSnackBar
            .dropFirst()
            .sink { value in
                if value {
                    exp.fulfill()
                }
            }
            .store(in: &cancellables)

        sut.refreshCountries()

        await fulfillment(of: [exp], timeout: 2)

        XCTAssertTrue(sut.showOfflineSnackBar)
        XCTAssertEqual(searchUseCase.executeCallCount, 0)
        XCTAssertEqual(persistenceUseCase.executeSaveCallCount, 0)
    }



    func test_onAppDidBecomeActive_requestsPermissionAgain() {
        let permissionAuthenticator = MockPermissionsAuthenticator()
        let locationManager = MockUserLocationManager()
        let searchUseCase = MockSearchCountriesUseCase()
        let persistenceUseCase = MockCountryPersistenceUseCase()
        let networkMonitor = MockNetworkMonitorObservableContract(initialValue: true)

        let sut = CountriesMainViewModel(
            permissionAuthenticator: permissionAuthenticator,
            locationManager: locationManager,
            searchCountriesUseCase: searchUseCase,
            countriesPersistenceUseCase: persistenceUseCase,
            networkMonitor: networkMonitor
        )

        sut.onAppDidBecomeActive()

        XCTAssertEqual(permissionAuthenticator.requestAuthorizationStatusCallCount, 1)
    }

    func test_networkChanges_updatesIsOnline() async {
        let permissionAuthenticator = MockPermissionsAuthenticator()
        let locationManager = MockUserLocationManager()
        let searchUseCase = MockSearchCountriesUseCase()
        let persistenceUseCase = MockCountryPersistenceUseCase()
        let networkMonitor = MockNetworkMonitorObservableContract(initialValue: true)

        let sut = CountriesMainViewModel(
            permissionAuthenticator: permissionAuthenticator,
            locationManager: locationManager,
            searchCountriesUseCase: searchUseCase,
            countriesPersistenceUseCase: persistenceUseCase,
            networkMonitor: networkMonitor
        )

        let exp = expectation(description: "isOnline updated")

        sut.$isOnline
            .dropFirst()
            .sink { value in
                if value == false {
                    exp.fulfill()
                }
            }
            .store(in: &cancellables)

        networkMonitor.send(false)

        await fulfillment(of: [exp], timeout: 2)

        XCTAssertFalse(sut.isOnline)
    }

    func makeCountry(id: String, name: String) -> Country {
        Country(
            name: .init(common: name),
            currencies: ["egp":.init(name: "Egyptian Pound", symbol: "$")],
            capital: ["Cairo"],
            flags: .init(
                png: "Test"
            ),
            cca3: id
        )
    }
}
