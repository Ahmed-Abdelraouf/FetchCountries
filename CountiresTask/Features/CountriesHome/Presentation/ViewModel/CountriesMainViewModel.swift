//
//  CountriesMainViewModel.swift
//  CountiresTask
//
//  Created by NTG on 09/04/2026.
//

import Foundation
import Foundation
import Combine

@MainActor
final class CountriesMainViewModel: ObservableObject {
    @Published private(set) var countries: [Country] = []
    @Published private(set) var isLoading = false
    @Published private(set) var isOnline = true
    @Published var showOfflineSnackBar = false

    private let permissionAuthenticator: PermissionsAuthenticatorProtocol
    private let searchCountriesUseCase: SearchCountriesUseCaseProtocol
    private let countriesPersistenceUseCase: CountryPersistenceUseCaseProtocol
    private let locationManager: UserLocationManagerProtocol
    private let networkMonitor: NetworkMonitorObservableContract

    private var cancellables = Set<AnyCancellable>()
    private var locationPermissionStatus: AuthorizationStatus = .notDetermined
    private var defaultCountryName = "Egypt"
    private var hasLoadedInitially = false

    init(
        permissionAuthenticator: PermissionsAuthenticatorProtocol = PermissionsAutheticator.locationPermission,
        locationManager: UserLocationManagerProtocol = UserLocationManager(),
        searchCountriesUseCase: SearchCountriesUseCaseProtocol = SearchCountriesUseCase(),
        countriesPersistenceUseCase: CountryPersistenceUseCaseProtocol = CountryPersistenceUseCase(),
        networkMonitor: NetworkMonitorObservableContract = NetworkMonitor.shared
    ) {
        self.permissionAuthenticator = permissionAuthenticator
        self.locationManager = locationManager
        self.searchCountriesUseCase = searchCountriesUseCase
        self.countriesPersistenceUseCase = countriesPersistenceUseCase
        self.networkMonitor = networkMonitor

        observeNetworkChanges()
    }

    func onAppear() {
        guard !hasLoadedInitially else {
            fetchAllCountries()
            return }
        hasLoadedInitially = true
        checkLocationPermission()
    }

    func onAppDidBecomeActive() {
        checkLocationPermission()
    }

    func removeCountry(_ country: Country) {
        isLoading = true
        Task {
            defer { isLoading = false }

            do {
                try await countriesPersistenceUseCase.executeDelete(country: country)
                countries.removeAll { $0 == country }
            } catch {
            }
        }
    }

    func refreshCountries() {
        fetchAllCountries()
    }

    private func checkLocationPermission() {
        permissionAuthenticator.requestAuthorizationStatus { [weak self] authorizationStatus in
            guard let self else { return }

            Task { @MainActor in
                self.handleLocationPermissionStatus(authorizationStatus)
            }
        }
    }

    private func handleLocationPermissionStatus(_ status: AuthorizationStatus) {
        guard locationPermissionStatus != status || !hasLoadedInitially else {
            fetchAllCountries()
            return
        }

        locationPermissionStatus = status

        if status == .authorized, isOnline {
            setUserCountryName()
        } else {
            defaultCountryName = "Egypt"
            fetchAllCountries()
        }
    }

    private func setUserCountryName() {
        isLoading = true
        locationManager.requestLocation()

        locationManager.countryNamePublisher
            .receive(on: RunLoop.main)
            .prefix(1)
            .sink { [weak self] countryName in
                guard let self else { return }
                self.defaultCountryName = countryName
                self.fetchAllCountries()
            }
            .store(in: &cancellables)
    }

    private func observeNetworkChanges() {
        networkMonitor.connectionPublisher
            .receive(on: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] isConnected in
                guard let self else { return }
                self.isOnline = isConnected
            }
            .store(in: &cancellables)
    }

    private func fetchAllCountries() {
        isLoading = true

        Task {
            defer { isLoading = false }

            do {
                let countries = try await countriesPersistenceUseCase.executeFetchCountries()
                handleCountriesResponse(countries)
            } catch {
            }
        }
    }

    private func handleCountriesResponse(_ countries: [Country]) {
        guard !countries.isEmpty,
              countries.contains(where: { $0.name.common == defaultCountryName }) else {
            fetchDefaultCountry()
            return
        }

        self.countries = countries
    }

    private func fetchDefaultCountry() {
        guard isOnline else {
            showOfflineSnackBar = true
            return
        }

        isLoading = true

        Task {
            defer { isLoading = false }

            do {
                let data = try await searchCountriesUseCase.execute(countryName: defaultCountryName)

                guard let firstCountry = data.first(where: { $0.name.common == defaultCountryName }) else {
                    return
                }

                try await countriesPersistenceUseCase.executeSave(country: firstCountry)
                let countries = try await countriesPersistenceUseCase.executeFetchCountries()
                handleCountriesResponse(countries)
            } catch {
            }
        }
    }
}
