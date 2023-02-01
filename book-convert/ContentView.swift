//
//  ContentView.swift
//  book-convert
//
//  Created by Matheus Gois on 01/02/23.
//

import SwiftUI

struct ContentView: View {
    @State var text = ""
    var body: some View {
        ScrollView {
            Text(text).padding(28)
        }.onAppear {
            self.load(page: 1)
        }
    }

    func load(page: Int) {
        let image = PDFManager.load(named: "clean-code", page: page)
        VisionManager.readImage(image: image) { text in
            DispatchQueue.main.async { self.text += text ?? "" }
            if page < 6 {
                load(page: page + 1)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
