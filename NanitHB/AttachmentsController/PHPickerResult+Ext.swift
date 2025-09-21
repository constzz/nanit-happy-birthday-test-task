//
//  PossibleFileType.swift
//  NanitHB
//
//  Created by Konstantin Bezzemelnyi on 20.09.2025.
//


import Foundation
import PhotosUI

extension PHPickerResult {
    
    enum PossibleFileType {
        case video
        case photo
        
        var utTypes: [UTType] {
            switch self {
            case .video:
                return [.movie, UTType(mimeType: "video/mp4")!]
            case .photo:
                return [.png, .jpeg]
            }
        }
    }
    
    enum LoadFileError: Swift.Error {
        case notFound
    }
    
    func loadAsFile(possibleFileTypes: [PossibleFileType], completion: @escaping (Result<URL, Error>) -> Void) {
        loadAsFile(utTypes: possibleFileTypes.flatMap({ $0.utTypes }), completion: completion)
    }
    
    func loadAsFile(utTypes: [UTType], completion: @escaping (Result<URL, Error>) -> Void) {
        guard let utType = utTypes.first else {
            completion(.failure(LoadFileError.notFound))
            return
        }
        
        itemProvider.loadFileRepresentation(forTypeIdentifier: utType.identifier) { result in
            if let fileURL = try? result.get() {
                completion(.success(fileURL))
            } else {
                loadAsFile(utTypes: Array(utTypes.dropFirst()), completion: completion)
            }
        }
    }
    
    /// Returns saved to cache file. Dispatches asynchoronously on the queue passed as argument
    func getFileCached(
        possibleFileTypes: [PossibleFileType],
        queue: DispatchQueue = .main,
        completion: @escaping ((Result<(FileCached), Error>) -> Void)
    ) {
        loadAsFile(possibleFileTypes: possibleFileTypes, completion: { result in
            switch result {
            case .success(let url):
                do {
                    let fileCached = try FileCached.make(localURL: url)
                    queue.async { completion(.success(fileCached)) }
                } catch {
                    queue.async { completion(.failure(error)) }
                }
            case .failure(let error):
                queue.async { completion(.failure(error)) }
            }
        })
    }
}
