//
//  ChildInfoViewModelProtocol.swift
//  NanitHB
//
//  Created by Konstantin Bezzemelnyi on 20.09.2025.
//

import Foundation
import SwiftUI
import Combine

protocol ChildInfoViewModelProtocol {
    var namePublisher: AnyPublisher<String, Never> { get }
    var birthdayPublisher: AnyPublisher<Date?, Never> { get }
    var picturePublisher: AnyPublisher<Image?, Never> { get }
    var showBirthdayScreenPublisher: AnyPublisher<Bool, Never> { get }
    var showImagePickerPublisher: AnyPublisher<Bool, Never> { get }
    var canShowBirthdayScreenPublisher: AnyPublisher<Bool, Never> { get }

    func setName(_ name: String)
    func setBirthday(_ date: Date?)
    func setPicture(_ image: Image?)
    func setShowBirthdayScreen(_ show: Bool)
    func setShowImagePicker(_ show: Bool)
}
