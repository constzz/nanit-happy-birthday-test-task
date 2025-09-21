import Foundation
import UIKit

protocol ChildInfoRepositoryProtocol {
    func save(name: String)
    func save(birthday: Date)
    func save(fileCached: FileCached)
    
    func getName() -> String?
    func getBirthday() -> Date?
    func getFileCached() -> FileCached?
}

final class ChildInfoRepository: ChildInfoRepositoryProtocol {
    private enum Keys {
        static let name = "child_name"
        static let birthday = "child_birthday"
        static let imageFileName = "child_photo.jpg"
    }
    
    private let userDefaults: UserDefaults
    private let persistentStorage: PersistentStorage
    
    init(
        userDefaults: UserDefaults,
        persistentStorage: PersistentStorage
    ) {
        self.userDefaults = userDefaults
        self.persistentStorage = persistentStorage
    }
    
    func save(name: String) {
        userDefaults.set(name, forKey: Keys.name)
    }
    
    func save(birthday: Date) {
        userDefaults.set(birthday, forKey: Keys.birthday)
    }
    
    func save(fileCached: FileCached) {
        // Instead of saving directly, we'll copy the file to our cache with our filename
        if let data = fileCached.data ?? (try? Data(contentsOf: fileCached.url)) {
            _ = persistentStorage.saveToCache(data: data, fileName: Keys.imageFileName)
        }
    }
    
    func getName() -> String? {
        userDefaults.string(forKey: Keys.name)
    }
    
    func getBirthday() -> Date? {
        userDefaults.object(forKey: Keys.birthday) as? Date
    }
    
    func getFileCached() -> FileCached? {
        guard let url = persistentStorage.getCacheURL(for: Keys.imageFileName) else { return nil }
        return try? FileCached.make(localURL: url)
    }
}
