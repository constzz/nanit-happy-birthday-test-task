//
//  NSItemProvider+Ext.swift
//  NanitHB
//
//  Created by Konstantin Bezzemelnyi on 20.09.2025.
//

import Foundation

private enum Error: Swift.Error {
    case invalidState
}

extension NSItemProvider {
    func loadFileRepresentation(
        forTypeIdentifier typeIdentifier: String,
        completion: @escaping (Result<URL, Swift.Error>) -> Void
    ) {
        self.loadFileRepresentation(forTypeIdentifier: typeIdentifier) { url, error in
            if let error {
                completion(.failure(error))
                return
            }
            if let url {
                completion(.success(url))
            } else {
                completion(.failure(Error.invalidState))
            }
        }
    }
}
