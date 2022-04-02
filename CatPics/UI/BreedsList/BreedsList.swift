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
        if viewModel.breeds.isEmpty {
            Text("There are no breeds yet")
                .onAppear(perform: self.viewModel.reloadBreeds)
        } else {
            List(viewModel.breeds) { breed in
                Text(breed.name)
            }
        }
    }
}

struct BreedsList_Previews: PreviewProvider {
    static var previews: some View {
        BreedsList(viewModel: BreedsList.ViewModel())
    }
}
