//
//  CountriesMainView.swift
//  CountiresTask
//
//  Created by Ahmed Abdelraouf on 09/04/2026.
//

import SwiftUI

struct CountriesMainView: View {
    @StateObject private var viewModel: CountriesMainViewModel
    @State private var path = NavigationPath()
    @State private var selectedCountry: Country?

    init(
        viewModel: CountriesMainViewModel,
        path: NavigationPath = NavigationPath(),
        selectedCountry: Country? = nil
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.path = path
        self.selectedCountry = selectedCountry
    }

    var body: some View {
        NavigationStack(path: $path) {
            content
                .navigationTitle("Countries")
                .navigationBarTitleDisplayMode(.automatic)
                .showLoader(isLoading: viewModel.isLoading)
                .showSnackBar(
                    message: "You are offline, try to connect to fetch default country",
                    isVisible: $viewModel.showOfflineSnackBar
                )
                .toolbar {
                    toolbarContent
                }
                .navigationDestination(for: AppRoutes.self) { destination in
                    switch destination {
                    case .details:
                        CountriesSearchView()
                    }
                }
                .sheet(item: $selectedCountry) { country in
                    CountryDetailsView(
                        country: country,
                        actionButton: detailsActionButton(for: country)
                    ) {
                        selectedCountry = nil
                    }
                    .presentationDetents([.medium, .large])
                }
                .task {
                    viewModel.onAppear()
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                    viewModel.onAppDidBecomeActive()
                }
        }
    }
}

private extension CountriesMainView {
    var content: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 12) {
                ForEach(viewModel.countries, id: \.id) { country in
                    CountryCardView(
                        country: country,
                        actionButton: listItemActionButton(for: country)
                    )
                    .padding(.horizontal,.defaultSpacing(.p8))
                    .onTapGesture {
                        selectedCountry = country
                    }
                }
            }
        }
    }

    @ToolbarContentBuilder
    var toolbarContent: some ToolbarContent {
        if viewModel.isOnline {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    path.append(AppRoutes.details)
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }

    func listItemActionButton(for country: Country) -> some View {
        CustomButton(foregroundColor: .red, imageName: "trash") {
            viewModel.removeCountry(country)
        }
    }

    func detailsActionButton(for country: Country) -> some View {
        CustomButton(
            backgroundColor: .red,
            label: "Remove from countries list",
            height: 64,
            cornerRadius: 12,
            isFullWidth: true
        ) {
            viewModel.removeCountry(country)
            selectedCountry = nil
        }
    }
}

