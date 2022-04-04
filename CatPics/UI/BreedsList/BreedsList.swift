//
//  BreedsList.swift
//  CatPics
//
//  Created by Alba Venzal on 02/04/2022.
//

import SwiftUI
// We use CachedAsyncImage because the standard AsyncImage does not have support for cache yet
import CachedAsyncImage

struct BreedsList: View {
    @ObservedObject private(set) var viewModel: ViewModel
    private let imageWidth: CGFloat = 48

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    VStack {
                        ProgressView()
                        Text("Looking for cat breeds")
                    }
                } else if viewModel.breeds.isEmpty {
                    Text("There are no breeds yet")
                        .onAppear(perform: self.viewModel.reloadBreeds)
                } else {
                    List(viewModel.breeds) { breed in
                        NavigationLink(destination: self.detailsView(breed: breed)) {
                            HStack {
                                image(for: viewModel.imagesForBreed[breed.id])
                                Text(breed.name)
                                Spacer()
                            }
                        }
                    }
                }
            }
            .navigationTitle("Cat breeds")
        }
    }

    func detailsView(breed: Breed) -> some View {
        BreedDetail(viewModel: BreedDetail.ViewModel(breed: breed))
    }

    func image(for url: URL?) -> some View {
        CachedAsyncImage(url: url, urlCache: URLCache.shared) { phase in
            if let image = phase.image {
                // Displays the loaded image.
                image
                     .resizable()
                     .scaledToFill()
                     .frame(width: imageWidth, height: imageWidth, alignment: Alignment.center)
                     .cornerRadius(imageWidth/2)
                         .overlay(
                             RoundedRectangle(cornerRadius: imageWidth/2)
                                .stroke(.gray, lineWidth: 1)
                         )
                         .padding(.trailing, 4)
            } else if let image = UIImage(named: "cat-icon") {
                // Cat icon as placeholder while loading and in case of error
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: imageWidth, height: imageWidth, alignment: Alignment.center)
                    .cornerRadius(imageWidth/2)
                    .overlay(
                        RoundedRectangle(cornerRadius: imageWidth/2)
                           .stroke(.gray, lineWidth: 1)
                    )
                    .padding(.trailing, 4)
            }
        }
    }
}

struct BreedsList_Previews: PreviewProvider {
    static var previews: some View {
        BreedsList(viewModel: BreedsList.ViewModel())
    }
}
