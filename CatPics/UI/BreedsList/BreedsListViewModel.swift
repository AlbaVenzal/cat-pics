//
//  BreedsListViewModel.swift
//  CatPics
//
//  Created by Alba Venzal on 02/04/2022.
//

import SwiftUI

// MARK: - ViewModel

extension BreedsList {
    class ViewModel: ObservableObject {
        @Published var breeds: [Breed] = []

        func reloadBreeds() {
            API.request(api: .getBreeds) { [weak self] (response: [Breed]?, error: Error?) in
                if let breeds = response {
                    self?.breeds = breeds
                } else if let error = error {
                    // TODO handle error
                    print(error)
                }
            }
        }
    }
}
