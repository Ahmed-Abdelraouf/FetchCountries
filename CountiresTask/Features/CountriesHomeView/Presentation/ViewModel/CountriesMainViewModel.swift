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
    
    
    
    func removeCountry(_ country: Country) {
//        self.isLoading = true
//        countriesPersistenceUseCase.executeDelete(country:country)
//            .receive(on: RunLoop.main)
//            .sink {[weak self] completion in
//                guard case .failure(_) = completion else { return }
//                self?.isLoading = false
//            } receiveValue: {[weak self] _ in
//                self?.countries.removeAll(where: {$0 == country})
//                self?.isLoading = false
//            }.store(in: &cancellables)
    }
    
    func navigateToCountrySearch() {
        self.path.append(AppRoutes.details)
    }
}
