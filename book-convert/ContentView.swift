//
//  ContentView.swift
//  book-convert
//
//  Created by Matheus Gois on 01/02/23.
//

import SwiftUI

struct ContentView: View {

    private let startPage = 40
    private let endPage = 59

    @State var text = ""

    var body: some View {
        NavigationView {
            ScrollView {
                Text(text).padding(28)
            }.onAppear {
                self.load(page: startPage)
            }.onTapGesture {
                UIPasteboard.general.string = self.text
            }
            .toolbar {
                Button("Copy") {
                    UIPasteboard.general.string = self.text
                }
            }
        }
    }

    func load(page: Int) {
        let image = PDFManager.load(named: "clean-code", page: page)
        VisionManager.readImage(image: image) { text in
            guard let text else { return }
            DispatchQueue.main.async {
                self.text += text
            }

            if page < endPage { load(page: page + 1) }
            print("✅✅✅ PAGE DONE: \(page) ✅✅✅")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
