//
//  CountrySearchView.swift
//  CountiresTask
//
//  Created by Ahmed Abdelraouf on 09/04/2026.
//

import SwiftUI

struct CountriesSearchView: View {
    @StateObject private var viewModel: CountriesSearchViewModel = .init()

    var body: some View {
        VStack(spacing: 12){
            searchView
            countriesListView
            Spacer()
        }
        .padding()
        .showLoader(isLoading: $viewModel.isLoading)
        .showSnackBar(message: "You can only save up to 5 countries.", isVisible: $viewModel.showReachedLimitView)
        .showSnackBar(
            message: "You are offline, try to reconnect to fetch countries",
            isVisible: Binding(
                get: {
                    !viewModel.isOnline
                },
                set: {
                    viewModel.isOnline = !$0
                }
            ),
            dismissible: false
        )
        .overlay((viewModel.showEmptyResultsState && !viewModel.searchText.isEmpty) ? emptySearchResultsView : nil)
        .overlay(viewModel.searchText.isEmpty ? emptySearchTextView : nil)
        .sheet(item: $viewModel.selectedCountry) { country in
            detailsView(country: country)
            .presentationDetents([.medium, .large])
        }

    }
    
    @ViewBuilder
    private func detailsView(country: Country) -> some View {
        CountryDetailsView(country: country, actionButton: detailsActionButton) {
            viewModel.dismissDetailsSheet()
        }
    }
    
    private var searchView: some View {
        SearchBarView(isSearchButtonDisabled: !viewModel.isOnline, placeholder: "Search by country name") { searchText in
            self.viewModel.searchText = searchText
            viewModel.searchCountries(for: searchText)
        }
        .disabled(!viewModel.isOnline)
    }
    
    private var countriesListView: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.countries) { country in
                    CountryCardView(country: country, actionButton: listItemActionButton(savableCountry: country))
                }
            }
        }
        .hiddenIf(viewModel.showEmptyResultsState)
        .scrollIndicators(.hidden)
        
    }
    
    private var emptySearchTextView: some View {
        EmptyStateView(
            message: "Start typing to search for a country",
            systemImage: "magnifyingglass")
    }
    
    private var emptySearchResultsView: some View {
        EmptyStateView(
            message: "No results found",
            systemImage: "exclamationmark.magnifyingglass")
    }
    
    @ViewBuilder
    private func listItemActionButton(savableCountry: Country) -> some View {
        CustomButton(foregroundColor: .blue, imageName: "plus.circle.fill") {
            viewModel.saveCountry(savableCountry)
        }
    }
    
    private var detailsActionButton: some View {
        CustomButton(backgroundColor: .blue, label: "Add to main countries list", height: 64, cornerRadius: .defaultSpacing(.p12), isFullWidth: true) {
            guard let selectedCountry = viewModel.selectedCountry else { return }
            viewModel.saveCountry(selectedCountry)
            viewModel.dismissDetailsSheet()
        }
    }

}
#Preview {
    CountriesSearchView()
}
