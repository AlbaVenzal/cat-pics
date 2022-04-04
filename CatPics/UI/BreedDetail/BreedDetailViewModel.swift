//
//  BreedDetailViewModel.swift
//  CatPics
//
//  Created by Alba Venzal on 02/04/2022.
//

import Foundation

extension BreedDetail {
    class ViewModel: ObservableObject {
        let breed: Breed
        @Published var images: [CatImage] = []
        @Published var isLoading: Bool = false

        init(breed: Breed) {
            self.breed = breed
        }

        func reloadImages() {
            isLoading = true
            API.request(api: .getImages(GetImageRequest(breedId: breed.id, numberOfImages: 100))) { [weak self] (response: [CatImage]?, error: Error?) in
                if let images = response {
                    self?.images = images
                } else if let error = error {
                    // TODO handle error
                    print(error)
                }
                self?.isLoading = false
            }
        }
    }
}
