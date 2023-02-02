//
//  VisionManager.swift
//  book-convert
//
//  Created by Matheus Gois on 01/02/23.
//

import UIKit
import Vision

struct VisionManager {
    static func readImage(image: UIImage, completion: @escaping (String?) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(nil)
            return
        }
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
        let recognizeTextRequest = recognizeTextRequest(completion: completion)
        recognizeTextRequest.recognitionLevel = .accurate

        DispatchQueue.global(qos: .utility).async {
            do {
                try requestHandler.perform([recognizeTextRequest])
            } catch {
                print(error)
            }
        }
    }

    static func recognizeTextRequest(completion: @escaping (String?) -> Void) -> VNRecognizeTextRequest {
        VNRecognizeTextRequest { (request, _) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                completion(nil)
                return
            }

            let recognizedStrings: [String] = observations.compactMap { (observation)  in
                guard let topCandidate = observation.topCandidates(1).first else { return nil }
                let isTitle = observation.boundingBox.height > 0.06
                let isBrokeLine = observation.boundingBox.width < 0.9

                var result = topCandidate.string.trimmingCharacters(in: .whitespaces)
                if isTitle { result = "\n\n\n" + result + "\n\n\n" }
                if isBrokeLine { result += topCandidate.string.last == "." ? "\n\n" : "" }

                return result
            }

            DispatchQueue.main.async {
                completion(
                    recognizedStrings.reduce("", { partialResult, next in
                        let separator = partialResult.last == "\n" ? "" : " "

                        return partialResult + separator + next
                    })
                )
            }
        }
    }
}

extension Character {
    func isUpper() -> Bool {
        self == self.uppercased().first
    }
}
