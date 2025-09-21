//
//  ChildInfoRepository.swift
//  NanitHB
//
//  Created by Konstantin Bezzemelnyi on 21.09.2025.
//

import Foundation
import Combine
import SwiftUI

final class ChildInfoRepository: ChildInfoRepositoryProtocol {
    private enum Keys {
        static let name = "child_name"
        static let birthday = "child_birthday"
        static let imageFileName = "child_photo.jpg"
    }
    
    private let userDefaults: UserDefaults
    private let persistentStorage: PersistentStorage
    
    private let nameSubject = CurrentValueSubject<String, Never>("")
    private let birthdaySubject = CurrentValueSubject<Date?, Never>(nil)
    private let processedImageSubject = CurrentValueSubject<Image?, Never>(nil)
    
    var namePublisher: AnyPublisher<String, Never> { nameSubject.receive(on: DispatchQueue.main).eraseToAnyPublisher() }
    var birthdayPublisher: AnyPublisher<Date?, Never> { birthdaySubject.receive(on: DispatchQueue.main).eraseToAnyPublisher() }
    var imagePublisher: AnyPublisher<Image?, Never> { processedImageSubject.receive(on: DispatchQueue.main).eraseToAnyPublisher() }
    
    init(
        userDefaults: UserDefaults,
        persistentStorage: PersistentStorage
    ) {
        self.userDefaults = userDefaults
        self.persistentStorage = persistentStorage
        
        if let name = userDefaults.string(forKey: Keys.name) {
            nameSubject.send(name)
        }
        if let birthday = userDefaults.object(forKey: Keys.birthday) as? Date {
            birthdaySubject.send(birthday)
        }
        if let url = persistentStorage.getCacheURL(for: Keys.imageFileName),
           let fileCached = try? FileCached.make(localURL: url) {
            Task(priority: .userInitiated) {
                let image = await ImageProcessor.convertToImage(fileCached)
                processedImageSubject.send(image)
            }
        }
    }
    
    func save(name: String) {
        userDefaults.set(name, forKey: Keys.name)
        nameSubject.send(name)
    }
    
    func save(birthday: Date) {
        userDefaults.set(birthday, forKey: Keys.birthday)
        birthdaySubject.send(birthday)
    }
    
    func save(fileCached: FileCached) {
        if let data = fileCached.data {
            _ = persistentStorage.saveToCache(data: data, fileName: Keys.imageFileName)
            Task(priority: .userInitiated) {
                let image = await ImageProcessor.convertToImage(fileCached)
                processedImageSubject.send(image)
            }
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
