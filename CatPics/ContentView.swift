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
            .onAppear {
                // Set URLCache to store 10 MB in memory and 1GB on disk
                URLCache.shared = URLCache(memoryCapacity: 10*1024*1024,
                                             diskCapacity: 1*1024*1024*1024)
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
