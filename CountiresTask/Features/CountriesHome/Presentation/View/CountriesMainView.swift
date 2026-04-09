//
//  CountriesMainView.swift
//  CountiresTask
//
//  Created by Ahmed Abdelraouf on 09/04/2026.
//

import SwiftUI

struct CountriesMainView: View {
    @StateObject private var viewModel: CountriesMainViewModel = .init()

    var body: some View {
        NavigationStack(path: $viewModel.path) {
             countriesListView
            .navigationTitle("Countries")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                if viewModel.isOnline {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            viewModel.navigateToCountrySearch()
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
            .navigationDestination(for: AppRoutes.self) { destination in
                switch destination {
                case .details:
                    CountriesSearchView()
                }
            }
          
        }
       
    }

}

#Preview {
    CountriesMainView()
}

extension CountriesMainView {
    private var countriesListView: some View {
        List(viewModel.countries) { country in
            CountryCardView(country: country, actionButton: listItemActionButton(deletableCountry: country))
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
    private func listItemActionButton(deletableCountry: Country) -> some View {
        CustomButton(foregroundColor: .red, imageName: "trash") {
            viewModel.removeCountry(deletableCountry)
        }
    }
}

