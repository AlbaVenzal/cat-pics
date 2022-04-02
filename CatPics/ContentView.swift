//
//  ContentView.swift
//  CatPics
//
//  Created by Alba Venzal on 31/03/2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        BreedsList(viewModel: BreedsList.ViewModel())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
