//
//  ChildInfoViewModel.swift
//  NanitHB
//
//  Created by Konstantin Bezzemelnyi on 20.09.2025.
//

import SwiftUI
import Combine

final class ChildInfoViewModel: ChildInfoViewModelProtocol {
    private let nameSubject = CurrentValueSubject<String, Never>("")
    private let birthdaySubject = CurrentValueSubject<Date?, Never>(nil)
    private let pictureSubject = CurrentValueSubject<Image?, Never>(nil)
    
    private let repository: ChildInfoRepositoryProtocol
    
    init(repository: ChildInfoRepositoryProtocol) {
        self.repository = repository
        
        if let name = repository.getName() {
            nameSubject.send(name)
        }
        if let birthday = repository.getBirthday() {
            birthdaySubject.send(birthday)
        }
        if let fileCached = repository.getFileCached(),
           let data = fileCached.data,
           let uiImage = UIImage(data: data) {
            pictureSubject.send(Image(uiImage: uiImage))
        }
    }
    
    var namePublisher: AnyPublisher<String, Never> { nameSubject.eraseToAnyPublisher() }
    var birthdayPublisher: AnyPublisher<Date?, Never> { birthdaySubject.eraseToAnyPublisher() }
    var picturePublisher: AnyPublisher<Image?, Never> { pictureSubject.eraseToAnyPublisher() }
    var canShowBirthdayScreenPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(nameSubject, birthdaySubject)
            .map { !$0.0.isEmpty && $0.1 != nil }
            .eraseToAnyPublisher()
    }
    
    // Setters
    func setName(_ name: String) {
        nameSubject.send(name)
        repository.save(name: name)
    }
    
    func setBirthday(_ date: Date?) {
        birthdaySubject.send(date)
        if let date = date {
            repository.save(birthday: date)
        }
    }
    
    func setPicture(_ fileCached: FileCached?) {
        if let fileCached = fileCached {
            repository.save(fileCached: fileCached)
            if let data = fileCached.data,
               let uiImage = UIImage(data: data) {
                pictureSubject.send(Image(uiImage: uiImage))
            } else {
                pictureSubject.send(nil)
            }
        } else {
            pictureSubject.send(nil)
        }
    }
}
