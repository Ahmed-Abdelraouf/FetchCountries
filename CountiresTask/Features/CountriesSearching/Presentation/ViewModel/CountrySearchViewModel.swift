//
//  CountrySearchViewModel.swift
//  CountiresTask
//
//  Created by Ahmed Abdelraouf on 09/04/2026.
//

import Foundation
import Combine

final class CountriesSearchViewModel: ObservableObject {
    @Published var countries: [Country] = []
    @Published var searchText: String = ""
    @Published var selectedCountry: Country?
    @Published var isLoading: Bool = false
    @Published var showEmptyResultsState: Bool = false
    @Published var shouldRefreshFromCache: Bool = false
    @Published var showReachedLimitView: Bool = false
    @Published var isOnline: Bool = true
    
    private let searchCountriesUseCase: SearchCountriesUseCaseProtocol
    private let countryPersistenceUseCase: CountryPersistenceUseCaseProtocol
    private let networkMonitor: NetworkMonitorContract
    private var cancellables = Set<AnyCancellable>()

    init(
        searchCountriesUseCase: SearchCountriesUseCaseProtocol = SearchCountriesUseCase(),
        countryPersistenceUseCase: CountryPersistenceUseCaseProtocol = CountryPersistenceUseCase(),
        networkMonitor: NetworkMonitorContract = NetworkMonitor.shared
    ) {
        self.searchCountriesUseCase = searchCountriesUseCase
        self.networkMonitor = networkMonitor
        self.countryPersistenceUseCase = countryPersistenceUseCase
        observeNetworkChanges()
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
    
    func searchCountries(for name: String) {
        guard !name.isEmpty else { return }
        isLoading = true
        showEmptyResultsState = false
        Task { @MainActor [weak self] in
            guard let self else {
                return
            }
            do {
                let data = try await searchCountriesUseCase.execute(countryName: name)
                self.filterCountries(countries: data)
                self.isLoading = false
            } catch {
                self.isLoading = false
                print(error.localizedDescription)
                self.showEmptyResultsState = true
                    return
            }
        }
    }
    private func filterCountries(countries: [Country]) {
        
        Task { @MainActor [weak self] in
            guard let self else {
                return
            }
            do {
                let cachedCountries = try await countryPersistenceUseCase.executeFetchCountries()
                let filteredCountries = countries.filter { !cachedCountries.contains($0) }
                guard !filteredCountries.isEmpty else {
                    showEmptyResultsState = true
                    return
                }
                self.countries = filteredCountries
            } catch {
                self.isLoading = false
                print(error.localizedDescription)
            }
        }
    }
    
    func saveCountry(_ country: Country) {
        isLoading = true
        fetchAllCountries {[weak self] cachedCount in
            
            guard cachedCount < 5 else {
                self?.isLoading = false
                self?.showReachedLimitView = true
                return
            }
            guard let self else { return }
            Task { @MainActor [weak self] in
                guard let self else {
                    return
                }
                do {
                    let _ = try await countryPersistenceUseCase.executeSave(country: country)
                    self.isLoading = false
                    self.countries.removeAll(where: {$0.id == country.id})
                    self.shouldRefreshFromCache = true
                } catch {
                    self.isLoading = false
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func fetchAllCountries(completion: @escaping (Int) -> Void) {
        
        Task { @MainActor [weak self] in
            guard let self else {
                return
            }
            do {
                let data = try await countryPersistenceUseCase.executeFetchCountries()
                completion(data.count)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func dismissDetailsSheet()  {
        selectedCountry = nil
    }
}
