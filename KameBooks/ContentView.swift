 //
//  ContentView.swift
//  KameBooks
//
//  Created by Jorge Suárez on 11/2/23.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var vm = HomeVM()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
