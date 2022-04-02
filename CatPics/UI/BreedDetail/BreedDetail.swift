//
//  BreedDetail.swift
//  CatPics
//
//  Created by Alba Venzal on 02/04/2022.
//

import SwiftUI

struct BreedDetail: View {
    @ObservedObject private(set) var viewModel: ViewModel

    var body: some View {
        List(viewModel.images) { image in
            AsyncImage(url: image.url) { phase in
                if let image = phase.image {
                    // Displays the loaded image.
                    image.resizable()
                         .aspectRatio(contentMode: .fit)
                } else if phase.error != nil {
                    // Placeholder in case of error
                    Text("This image could not be loaded")
                } else {
                    // Placeholder while loading
                    ProgressView()
                }
            }
        }
        .listStyle(PlainListStyle())
        .onAppear(perform: self.viewModel.reloadImages)
    }
}

struct BreedDetail_Previews: PreviewProvider {
    static var previews: some View {
        BreedDetail(viewModel: BreedDetail.ViewModel(breed: .init(id: "", name: "")))
    }
}