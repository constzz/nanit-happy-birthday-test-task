//
//  PersistentStorage.swift
//  NanitHB
//
//  Created by Konstantin Bezzemelnyi on 20.09.2025.

import Foundation
import UIKit

/// A service that handles persistent storage operations in both documents and cache directories
final class PersistentStorage {
    static let shared: PersistentStorage = .init()
    private init (){}
    enum Error: Swift.Error {
        case invalidResponse
        case invalidPath
        case fileNotFound
        case writeError(Swift.Error)
        case readError(Swift.Error)
        case removeError(Swift.Error)
    }
    
    enum Directory {
        case documents
        case cache
        
        var searchPathDirectory: FileManager.SearchPathDirectory {
            switch self {
            case .documents: return .documentDirectory
            case .cache: return .cachesDirectory
            }
        }
    }
}

// MARK: - Private Helpers
private extension PersistentStorage {
    func getURL(
        for fileName: String,
        in directory: Directory,
        domain: FileManager.SearchPathDomainMask = .userDomainMask
    ) -> URL? {
        let paths = NSSearchPathForDirectoriesInDomains(directory.searchPathDirectory, domain, true)
        guard let path = paths.safelyRetrieve(elementAt: 0) else {
            Logger.error("Path not found for directory: \(directory)")
            return nil
        }
        let url = URL(fileURLWithPath: path).appendingPathComponent(fileName)
        Logger.debug("Generated URL for \(directory): \(url)")
        return url
    }
    
    func createDirectoryIfNeeded(at url: URL) throws {
        let directory = url.deletingLastPathComponent()
        var isDirectory: ObjCBool = false
        
        if FileManager.default.fileExists(atPath: directory.path, isDirectory: &isDirectory) {
            if isDirectory.boolValue { return }
            throw Error.invalidPath
        }
        
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    }
}

// MARK: - Documents Operations
extension PersistentStorage {
    /// Saves data to the documents directory
    /// - Parameters:
    ///   - data: The data to save
    ///   - fileName: Name of the file to save the data to
    ///   - domain: The domain mask for the save operation
    /// - Returns: URL where the file was saved, if successful
    func saveToDocuments(
        data: Data,
        fileName: String,
        domain: FileManager.SearchPathDomainMask = .userDomainMask
    ) -> URL? {
        guard let fileURL = getURL(for: fileName, in: .documents, domain: domain) else { return nil }
        
        do {
            try createDirectoryIfNeeded(at: fileURL)
            try data.write(to: fileURL, options: .atomic)
            return fileURL
        } catch {
            Logger.error("Failed to save to documents: \(error.localizedDescription)")
            
            // Error code 4 indicates the parent directory doesn't exist
            if (error as NSError).code == 4 {
                guard let _ = try? FileManager.default.createDirectory(
                    at: fileURL.deletingLastPathComponent(),
                    withIntermediateDirectories: true
                ) else { return nil }
                
                // Retry the save after creating the directory
                return saveToDocuments(
                    data: data,
                    fileName: fileName,
                    domain: domain
                )
            }
            
            return nil
        }
    }
    
    /// Reads data from the documents directory
    /// - Parameters:
    ///   - fileName: Name of the file to read
    ///   - domain: The domain mask for the read operation
    /// - Returns: The file data if successful, nil otherwise
    func readFromDocuments(
        fileName: String,
        domain: FileManager.SearchPathDomainMask = .userDomainMask
    ) -> Data? {
        guard let fileURL = getURL(for: fileName, in: .documents, domain: domain) else { return nil }
        
        do {
            return try Data(contentsOf: fileURL)
        } catch {
            Logger.error("Failed to read from documents: \(error.localizedDescription)")
            return nil
        }
    }
    
    /// Removes a file from the documents directory
    /// - Parameters:
    ///   - fileName: Name of the file to remove
    ///   - domain: The domain mask for the remove operation
    func removeFromDocuments(
        fileName: String,
        domain: FileManager.SearchPathDomainMask = .userDomainMask
    ) throws {
        guard let fileURL = getURL(for: fileName, in: .documents, domain: domain) else {
            throw Error.invalidPath
        }
        
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            Logger.error("Failed to remove from documents: \(error.localizedDescription)")
            throw Error.removeError(error)
        }
    }
}

// MARK: - Cache Operations
extension PersistentStorage {
    /// Saves data to the cache directory
    /// - Parameters:
    ///   - data: The data to cache
    ///   - fileName: Name of the file to save the data to
    ///   - domain: The domain mask for the save operation
    /// - Returns: URL where the file was cached, if successful
    func saveToCache(
        data: Data,
        fileName: String,
        domain: FileManager.SearchPathDomainMask = .userDomainMask
    ) -> URL? {
        guard let fileURL = getURL(for: fileName, in: .cache, domain: domain) else {
            Logger.error("Failed to get URL for cache file: \(fileName)")
            return nil
        }
        
        do {
            try createDirectoryIfNeeded(at: fileURL)
            try data.write(to: fileURL, options: .atomic)
            Logger.debug("Successfully saved file to cache at: \(fileURL)")
            
            // Verify the file exists after saving
            if FileManager.default.fileExists(atPath: fileURL.path) {
                return fileURL
            } else {
                Logger.error("File was saved but does not exist at: \(fileURL)")
                return nil
            }
        } catch {
            Logger.error("Failed to save to cache: \(error.localizedDescription)")
            
            // Error code 4 indicates the parent directory doesn't exist
            if (error as NSError).code == 4 {
                Logger.debug("Attempting to create parent directory for: \(fileURL)")
                guard let _ = try? FileManager.default.createDirectory(
                    at: fileURL.deletingLastPathComponent(),
                    withIntermediateDirectories: true
                ) else { 
                    Logger.error("Failed to create parent directory")
                    return nil 
                }
                
                // Retry the save after creating the directory
                Logger.debug("Retrying save after creating directory")
                return saveToCache(
                    data: data,
                    fileName: fileName,
                    domain: domain
                )
            }
            
            return nil
        }
    }
    
    /// Reads data from the cache directory
    /// - Parameters:
    ///   - fileName: Name of the file to read
    ///   - domain: The domain mask for the read operation
    /// - Returns: The cached data if successful, nil otherwise
    func readFromCache(
        fileName: String,
        domain: FileManager.SearchPathDomainMask = .userDomainMask
    ) -> Data? {
        guard let fileURL = getURL(for: fileName, in: .cache, domain: domain) else {
            Logger.error("Failed to get URL for cache file: \(fileName)")
            return nil
        }
        
        // First check if the file exists
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            Logger.error("Cache file does not exist at path: \(fileURL)")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            Logger.debug("Successfully read \(data.count) bytes from cache file: \(fileURL)")
            return data
        } catch {
            Logger.error("Failed to read from cache at \(fileURL): \(error.localizedDescription)")
            return nil
        }
    }
    
    /// Removes a file from the cache directory
    /// - Parameters:
    ///   - fileName: Name of the file to remove
    ///   - domain: The domain mask for the remove operation
    func removeFromCache(
        fileName: String,
        domain: FileManager.SearchPathDomainMask = .userDomainMask
    ) throws {
        guard let fileURL = getURL(for: fileName, in: .cache, domain: domain) else {
            throw Error.invalidPath
        }
        
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            Logger.error("Failed to remove from cache: \(error.localizedDescription)")
            throw Error.removeError(error)
        }
    }
    
    /// Checks if a file exists in the cache
    /// - Parameters:
    ///   - fileName: Name of the file to check
    ///   - domain: The domain mask for the check operation
    /// - Returns: URL of the cached file if it exists, nil otherwise
    func getCacheURL(
        for fileName: String,
        domain: FileManager.SearchPathDomainMask = .userDomainMask
    ) -> URL? {
        guard let fileURL = getURL(for: fileName, in: .cache, domain: domain),
              FileManager.default.fileExists(atPath: fileURL.path) else {
            return nil
        }
        return fileURL
    }
}
