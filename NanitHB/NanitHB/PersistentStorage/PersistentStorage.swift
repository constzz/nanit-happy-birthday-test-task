//
//  PersistentStorage.swift
//  NanitHB
//
//  Created by Konstantin Bezzemelnyi on 20.09.2025.

import Foundation
import UIKit

final class PersistentStorage {
    static let shared = PersistentStorage()
    private init() {}
    
    enum Error: Swift.Error {
        case invalidResponse
        case invalidImageRepresentation
    }
    
    /// Saves to persistent storage as documents and returns the URL of saved data
    func saveToDocuments(data: Data, fileName: String, searchPathDomainMask: FileManager.SearchPathDomainMask = .userDomainMask) -> URL? {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, searchPathDomainMask, true)
        guard let path = paths.safelyRetrieve(elementAt: 0) else {
            Logger.error("Not found path to save to documents.")
            return nil
        }
        let documentsDirectory = URL(fileURLWithPath: path)
        let fileDataPath = documentsDirectory.appendingPathComponent(fileName)
        do {
            try data.write(to: fileDataPath, options: [])
            return fileDataPath
        } catch {
            Logger.error(error.localizedDescription)
            return nil
        }
    }
}

// MARK: - Cache
extension PersistentStorage {
    func cachePath(forPathComponent pathComponent: String) -> URL? {
        let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        guard let path = paths.safelyRetrieve(elementAt: 0),
              let documentsDirectory = URL(string: path) else {
            Logger.error("Not found path to save to documents.")
            return nil
        }
        return documentsDirectory.appendingPathComponent(pathComponent)
    }
    
    func cache(fileNameWithExtension: String) -> URL? {
        guard let cachePath = cachePath(forPathComponent: fileNameWithExtension) else {
            return nil
        }
        if FileManager.default.fileExists(atPath: cachePath.path) {
            return cachePath
        }
        return nil
    }
    
    func removeFromCache(fileNameWithExtension: String) throws {
        guard let cachePath = cachePath(forPathComponent: fileNameWithExtension) else {
            throw Error.invalidResponse
        }
        
        do {
            try FileManager.default.removeItem(at: cachePath)
        } catch {
            Logger.error("File removal failed: \(error.localizedDescription). Path: \(cachePath)")
        }
    }
    
    /// Saves to persistent storage as cached and returns the URL of saved data
    func saveToCache(
        data: Data,
        fileNameWithExtension: String,
        folderName: String? = nil,
        searchPathDomainMask: FileManager.SearchPathDomainMask = .userDomainMask
    ) -> URL? {
        guard let fileDataPath = cachePath(forPathComponent: fileNameWithExtension) else {
            return nil
        }
        do {
            try data.write(to: fileDataPath, options: [])
            return fileDataPath
        } catch {
            Logger.error(error.localizedDescription)
            
            // The file doesn’t exist
            if (error as NSError).code == 4 {
                guard let _ = try? FileManager.default.createDirectory(at: fileDataPath.deletingLastPathComponent(), withIntermediateDirectories: true)
                else { return .none }
                return saveToCache(
                    data: data,
                    fileNameWithExtension: fileNameWithExtension,
                    folderName: folderName,
                    searchPathDomainMask: searchPathDomainMask
                )
            }
            
            return nil
        }
    }
}
