//
//  CountriesView.swift
//  FixedExercises
//
//  Created by Lukas Brezina on 28.09.26.
//
import SwiftUI

struct CountriesView: View {
    
    @State
    private var countries: [Country]?
    
    let loginIdToken: String

    var body: some View {
        
        Group {
            if let countries {
                List(countries, id: \.name) { country in
                    Text(country.name)
                }
            }
        }
        .onAppear {
            fetchCountries()
        }
    }


    private func fetchCountries() {
        APIClient.shared.countries(loginIdToken: loginIdToken) { data, error in
            if let data {
                countries = data.documents
            } else if let error {
                // TODO
            }
        }
    }

}
