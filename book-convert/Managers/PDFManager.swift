//
//  PDFManager.swift
//  book-convert
//
//  Created by Matheus Gois on 01/02/23.
//

import Foundation

import PDFKit

struct PDFManager {
    static func load(named: String = "sample", page: Int = 1) -> UIImage {
        guard let path = Bundle.main.path(forResource: named, ofType: "pdf") else {
            fatalError("PDF Not found")
        }
        return drawPDFfromURL(url: URL(fileURLWithPath: path), page: page)
    }

    private static func drawPDFfromURL(url: URL, page: Int) -> UIImage {
        guard let document = CGPDFDocument(url as CFURL) else { fatalError("Convert error") }
        guard let page = document.page(at: page) else { fatalError("Page not found") }

        let pageRect = page.getBoxRect(.mediaBox)
        let renderer = UIGraphicsImageRenderer(size: pageRect.size)
        let img = renderer.image { ctx in
            UIColor.white.set()
            ctx.fill(pageRect)

            ctx.cgContext.translateBy(x: .zero, y: pageRect.size.height)
            ctx.cgContext.scaleBy(x: 1.0, y: -1.0)

            ctx.cgContext.drawPDFPage(page)
        }

        return img
    }
}
