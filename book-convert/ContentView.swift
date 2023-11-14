//
//  ContentView.swift
//  book-convert
//
//  Created by Matheus Gois on 01/02/23.
//

import SwiftUI

struct ContentView: View {

    private let startPage = 98
    private let endPage = 106
    @State private var currentPage: Float = 0
    @State private var progressTitle: String = "Processing..."

    @State var text = ""

    var body: some View {
        NavigationView {
            ScrollView {
                TextEditor(text: $text).padding(28)
            }.onAppear {
                self.load(page: startPage)
            }.onTapGesture {
                UIPasteboard.general.string = self.text
            }
            .toolbar {
                HStack {
                    ProgressView(
                        progressTitle,
                        value: currentPage,
                        total: .init(endPage - startPage)
                    )
                    Button("Copy") {
                        UIPasteboard.general.string = self.text
                    }
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
            currentPage = Float(page - startPage)
            progressTitle = "Processing \(Int(currentPage)) of \(endPage - startPage)"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
