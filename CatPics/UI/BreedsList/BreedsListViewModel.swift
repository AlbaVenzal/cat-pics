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
        @Published var isLoading: Bool = false
        @Published var imagesForBreed: [String: URL] = [:]

        func reloadBreeds() {
            isLoading = true
            API.request(api: .getBreeds) { [weak self] (response: [Breed]?, error: Error?) in
                if let breeds = response {
                    breeds.forEach { breed in
                        self?.getFirstImage(for: breed)
                    }
                    self?.breeds = breeds
                } else if let error = error {
                    // TODO handle error
                    print(error)
                }
                self?.isLoading = false
            }
        }

        private func getFirstImage(for breed: Breed) {
            let apiRequest = GetImageRequest(breedId: breed.id, numberOfImages: 1)
            API.request(api: .getImages(apiRequest)) { [weak self] (response: [CatImage]?, _: Error?) in
                if let images = response, let firstImage = images.first {
                    self?.imagesForBreed[breed.id] = firstImage.url
                }
            }
        }
    }
}
