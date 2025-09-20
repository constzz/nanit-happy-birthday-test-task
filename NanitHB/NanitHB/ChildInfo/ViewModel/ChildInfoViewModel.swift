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
    private let showBirthdayScreenSubject = CurrentValueSubject<Bool, Never>(false)
    private let showImagePickerSubject = CurrentValueSubject<Bool, Never>(false)
    
    var namePublisher: AnyPublisher<String, Never> { nameSubject.eraseToAnyPublisher() }
    var birthdayPublisher: AnyPublisher<Date?, Never> { birthdaySubject.eraseToAnyPublisher() }
    var picturePublisher: AnyPublisher<Image?, Never> { pictureSubject.eraseToAnyPublisher() }
    var showBirthdayScreenPublisher: AnyPublisher<Bool, Never> { showBirthdayScreenSubject.eraseToAnyPublisher() }
    var showImagePickerPublisher: AnyPublisher<Bool, Never> { showImagePickerSubject.eraseToAnyPublisher() }
    var canShowBirthdayScreenPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(nameSubject, birthdaySubject)
            .map { !$0.0.isEmpty && $0.1 != nil }
            .eraseToAnyPublisher()
    }
    
    // Setters
    func setName(_ name: String) { nameSubject.send(name) }
    func setBirthday(_ date: Date?) { birthdaySubject.send(date) }
    func setPicture(_ image: Image?) { pictureSubject.send(image) }
    func setShowBirthdayScreen(_ show: Bool) { showBirthdayScreenSubject.send(show) }
    func setShowImagePicker(_ show: Bool) { showImagePickerSubject.send(show) }
}
