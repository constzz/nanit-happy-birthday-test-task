//
//  FileCached.swift
//  NanitHB
//
//  Created by Konstantin Bezzemelnyi on 20.09.2025.
//

import Foundation

public class FileCached: Hashable {
    
    private enum Error: Swift.Error {
        case invalidData
    }
    
    let id: UUID = .init()
    let url: URL
    let data: Data?
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(url)
        hasher.combine(data)
    }
    
    private init(url: URL, data: Data?) {
        self.url = url
        self.data = data
    }
    
    public static func make(
        data: Data,
        fileName: String,
        cacheDestination: URL = FileManager.default.temporaryDirectory
    ) -> FileCached? {
        guard let url = PersistentStorage.shared.saveToCache(data: data, fileName: fileName) else {
            return nil
        }
        
        return FileCached(url: url, data: nil)
    }
    
    public static func make(
        localURL: URL,
        createsUnqiueSubfolder: Bool = true,
        fileNameWithExtension: String? = nil,
        cacheDestination: URL = FileManager.default.temporaryDirectory
    ) throws -> FileCached {
        var directoryPath = cacheDestination
        
        if createsUnqiueSubfolder {
            directoryPath = directoryPath.appendingPathComponent(UUID().description)
        }
        
        do {
            try FileManager.default.createDirectory(at: directoryPath, withIntermediateDirectories: true)
        } catch {
            Logger.error("Failed to create directory at \(directoryPath). Error: \(error.localizedDescription)")
            throw error
        }
        let destination = directoryPath
            .appendingPathComponent(fileNameWithExtension ?? localURL.lastPathComponent)
        
        return .init(url: try saveFile(localURL: localURL, to: destination),
                     data: FileManager.default.contents(atPath: destination.path()))
    }
    
    private static func saveFile(localURL: URL, to destination: URL) throws -> URL {
        do {
            try FileManager.default.copyItem(at: localURL, to: destination)
            return destination
        } catch {
            let error = error as NSError
            guard ![17, 516].contains(error.code) else {
                // File already in cache, so no need to trhow
                return destination
            }
            if error.code == 260 {
                // Couldn’t be opened because there is no such file. Attempt to find file
                var url: URL?
                var error: NSError?
                let group = DispatchGroup()
                group.enter()
                
                NSFileCoordinator().coordinate(
                    readingItemAt: localURL,
                    writingItemAt: destination,
                    error: &error
                ) { newLocalURL, newDestinationURL in
                    
                    do {
                        try FileManager.default.copyItem(at: localURL, to: newDestinationURL)
                        url = newDestinationURL
                    } catch let copyingError as NSError {
                        Logger.error("Copying error: \(copyingError).")
                    }
                    group.leave()
                }
                group.wait()
                
                if let error {
                    Logger.error(error.localizedDescription)
                    throw error
                } else if let url {
                    try FileManager.default.copyItem(at: url, to: destination)
                    return destination
                } else {
                    Logger.error("Both URL and error are nil while using NSFileCoordinator")
                    throw Error.invalidData
                }
            }
            
            if error.code == 2 || error.code == 4 {
                // No such file or directory
                _ = try? FileManager.default.createDirectory(at: destination.deletingLastPathComponent(), withIntermediateDirectories: true)
                return try saveFile(localURL: localURL, to: destination)
            }
            
            Logger.error(error.localizedDescription)
            throw error
        }
    }
}

extension FileCached {
    /// Returns name by the following strategy:
    /// passed prefix parameter + ":" + url file name with extension
    func getNameWithExtensionPrefixing(_ prefix: String) -> String {
        "\(prefix):\(url.fileName ?? "").\(url.fileExtension ?? "")"
    }
    
    func getNameWithExtensionReplacingName(with name: String) -> String {
        "\(name).\(url.fileExtension ?? "")"
    }
}

extension FileCached: Equatable {
    public static func == (lhs: FileCached, rhs: FileCached) -> Bool {
        lhs.url == rhs.url
    }
}
