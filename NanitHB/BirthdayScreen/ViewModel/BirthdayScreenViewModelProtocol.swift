//
//  BirthdayScreenViewModelProtocol.swift
//  NanitHB
//
//  Created by Konstantin Bezzemelnyi on 21.09.2025.
//

import SwiftUI
import Combine

protocol BirthdayScreenViewModelProtocol {
    var ageTitleStartText: String { get }
    var ageNumber: Int { get }
    var ageTitleEndText: String { get }
    var theme: BirthdayTheme { get }
    
    var imagePublisher: AnyPublisher<FileCached?, Never> { get }
    func setImage(file: FileCached?)
    func onBackTapped()
}
