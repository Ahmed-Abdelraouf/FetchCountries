//
//  CountriesMainViewModel.swift
//  CountiresTask
//
//  Created by NTG on 09/04/2026.
//

import Foundation
import Combine
import SwiftUI
class CountriesMainViewModel: ObservableObject {
    @Published var countries: [Country] = []
    @Published var isLoading: Bool = false
    @Published var isOnline: Bool = true
    @Published var showOfflineSnackBar: Bool = false
    @Published  var path = NavigationPath()
    @Published private var locationPermissionStatus: AuthorizationStatus = .notDetermined
    private let permissionAuthenticator: PermissionsAuthenticatorProtocol
    private let searchCountriesUseCase: SearchCountriesUseCaseProtocol
    private let countriesPersistenceUseCase: CountryPersistenceUseCaseProtocol
    private let locationManager: UserLocationManager
    private let networkMonitor: NetworkMonitorContract
    private var cancellables: Set<AnyCancellable> = []
    private var defaultCountryName: String = "Egypt"
    
    
    init(
        permissionAuthenticator: PermissionsAuthenticatorProtocol = PermissionsAutheticator.locationPermission,
        locationManager: UserLocationManager = UserLocationManager(),
        searchCountriesUseCase: SearchCountriesUseCaseProtocol = SearchCountriesUseCase(),
        countriesPersistenceUseCase: CountryPersistenceUseCaseProtocol = CountryPersistenceUseCase(),
        networkMonitor: NetworkMonitorContract = NetworkMonitor.shared
    ) {
        self.permissionAuthenticator = permissionAuthenticator
        self.locationManager = locationManager
        self.searchCountriesUseCase = searchCountriesUseCase
        self.countriesPersistenceUseCase = countriesPersistenceUseCase
        self.networkMonitor = networkMonitor
        checkLocationPermission()
        observeNetworkChanges()
    }
    
     func checkLocationPermission() {
        permissionAuthenticator.requestAuthorizationStatus {[weak self] authorizationStatus in
            self?.getUserLocationBasedOnLocationPermission(isAuthorized: authorizationStatus)
        }
    }
    private func getUserLocationBasedOnLocationPermission(isAuthorized: AuthorizationStatus) {
        guard locationPermissionStatus != isAuthorized else { return }
        locationPermissionStatus = isAuthorized
        if locationPermissionStatus == .authorized && isOnline {
            setUserCountryName()
        } else {
            fetchAllCountries()
        }
    }
    private func setUserCountryName() {
        isLoading = true
        locationManager.requestLocation()
        locationManager.countryName
            .receive(on: RunLoop.main)
            .sink {[weak self] countryName in
                self?.fetchAllCountries()
            }.store(in: &cancellables)
    }
    private func observeNetworkChanges() {
        if let monitor = networkMonitor as? NetworkMonitor {
            monitor.$isConnected
                .receive(on: RunLoop.main)
                .dropFirst()
                .sink { [weak self] isConnected in
                    self?.isOnline = isConnected
                }
                .store(in: &cancellables)
        }
    }
    func removeCountry(_ country: Country) {
        self.isLoading = true
        Task { @MainActor [weak self] in
            guard let self else {
                return
            }
            do {
                let _ = try await  countriesPersistenceUseCase.executeDelete(country:country)
                self.countries.removeAll(where: {$0 == country})
                self.isLoading = false
            } catch {
                self.isLoading = false
            }
        }
    }
    
    func saveCountry(_ country: Country) {
        isLoading = true
        Task { @MainActor [weak self] in
            guard let self else {
                return
            }
            do {
                let _ = try await   countriesPersistenceUseCase.executeSave(country: country)
                self.isLoading = false
            } catch {
                self.isLoading = false
            }
        }
    }
    
    func fetchAllCountries() {
        isLoading = true
        Task { @MainActor [weak self] in
            guard let self else {
                return
            }
            do {
                let countries = try await countriesPersistenceUseCase.executeFetchCountries()
                self.handleCountriesResponse(countries)
                self.isLoading = false
            } catch {
                self.isLoading = false
            }
        }
    }
    private func handleCountriesResponse(_ countries: [Country]) {
        guard !countries.isEmpty, countries.contains(where: {$0.name.common == defaultCountryName}) else {
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
        Task { @MainActor [weak self] in
            guard let self else {
                return
            }
            do {
                let data = try await  searchCountriesUseCase.execute(countryName: defaultCountryName)
                self.isLoading = false
                if let firstCountry = data.first(where: {$0.name.common == self.defaultCountryName}) {
                    self.saveCountry(firstCountry)
                    fetchAllCountries()
                }
            } catch {
                self.isLoading = false
            }
        }
    }
    
    func navigateToCountrySearch() {
        self.path.append(AppRoutes.details)
    }
}
