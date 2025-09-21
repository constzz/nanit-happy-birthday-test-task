//
//  ChildInfoViewModel.swift
//  NanitHB
//
//  Created by Konstantin Bezzemelnyi on 20.09.2025.
//

import Foundation
import SwiftUI
import Combine

final class ChildInfoViewModel: ChildInfoViewModelProtocol {
    
    struct Output {
        let name: String
        let birthday: Date
        let avatar: FileCached?
    }
    
    private let nameSubject = CurrentValueSubject<String, Never>("")
    private let birthdaySubject = CurrentValueSubject<Date?, Never>(nil)
    private let showBirthdayScreenAction: (Output) -> Void
    private let repository: ChildInfoRepositoryProtocol
    
    init(repository: ChildInfoRepositoryProtocol, showBirthdayScreenAction: @escaping (Output) -> Void) {
        self.repository = repository
        self.showBirthdayScreenAction = showBirthdayScreenAction
        
        if let name = repository.getName() {
            nameSubject.send(name)
        }
        if let birthday = repository.getBirthday() {
            birthdaySubject.send(birthday)
        }
    }
    
    var namePublisher: AnyPublisher<String, Never> { nameSubject.eraseToAnyPublisher() }
    var birthdayPublisher: AnyPublisher<Date?, Never> { birthdaySubject.eraseToAnyPublisher() }
    var picturePublisher: AnyPublisher<Image?, Never> { repository.imagePublisher }
    var canShowBirthdayScreenPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(nameSubject, birthdaySubject)
            .map { !$0.0.isEmpty && $0.1 != nil }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Setters
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
        }
    }
    
    // MARK: - Actions
    func showBirthdayScreen() {
        let name = nameSubject.value
        guard !name.isEmpty,
              let birthday = birthdaySubject.value else {
            return Logger.error("Error state to showBirthdayScreen without name or birthday.")
        }
              
        showBirthdayScreenAction(.init(name: name, birthday: birthday, avatar: repository.getFileCached()))
    }
}
