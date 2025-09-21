//
//  ChildInfoRepositoryProtocol.swift
//  NanitHB
//
//  Created by Konstantin Bezzemelnyi on 21.09.2025.
//

import Foundation
import Combine
import SwiftUI

protocol ChildInfoRepositoryProtocol {
    var namePublisher: AnyPublisher<String, Never> { get }
    var birthdayPublisher: AnyPublisher<Date?, Never> { get }
    var imagePublisher: AnyPublisher<Image?, Never> { get }
    
    func save(name: String)
    func save(birthday: Date)
    func save(fileCached: FileCached)
    
    func getName() -> String?
    func getBirthday() -> Date?
    func getFileCached() -> FileCached?
}
