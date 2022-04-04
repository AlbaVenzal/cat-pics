//
//  BreedsList.swift
//  CatPics
//
//  Created by Alba Venzal on 02/04/2022.
//

import SwiftUI

struct BreedsList: View {
    @ObservedObject private(set) var viewModel: ViewModel

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
                            Text(breed.name)
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
}

struct BreedsList_Previews: PreviewProvider {
    static var previews: some View {
        BreedsList(viewModel: BreedsList.ViewModel())
    }
}
