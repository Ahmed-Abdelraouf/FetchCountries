//
//  SearchBarView.swift
//  CountiresTask
//
//  Created by Ahmed Abdelraouf on 09/04/2026.
//


import SwiftUI

struct SearchBarView: View {
    @State var searchText: String = ""
    @State var isSearchButtonDisabled: Bool
    @FocusState private var isTextFieldFocused: Bool
    var placeholder: String
    var onTapSearch: (String) -> Void
    
    
    var body: some View {
        HStack {
            searchTextField
            searchButton
        }
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: .defaultSpacing(.p12)))
    }
    
    private var searchTextField: some View {
        TextField(placeholder, text: $searchText)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal, .defaultSpacing(.p8))
            .focused($isTextFieldFocused)
            .keyboardType(.asciiCapable)
    }
    
    private var searchButton: some View {
        Button(action: {
            onTapSearch(searchText)
            isTextFieldFocused = false
        }) {
            Image(systemName: "magnifyingglass")
                .padding()
                .background(isSearchButtonDisabled ? .gray : .blue)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: .defaultSpacing(.p8)))
                .opacity(isSearchButtonDisabled ? 0.9 : 1.0)
        }
        .disabled(isSearchButtonDisabled)
    }

    func performSearch() {
        print("Searching for: \(searchText)")
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(searchText: "", isSearchButtonDisabled: false, placeholder: "") { _ in }
    }
}

#Preview {
    SearchBarView(searchText: "", isSearchButtonDisabled: false, placeholder: "") { _ in }
}
