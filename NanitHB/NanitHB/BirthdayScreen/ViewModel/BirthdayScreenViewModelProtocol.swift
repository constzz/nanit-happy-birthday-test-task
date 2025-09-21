//
//  BirthdayScreenViewModelProtocol.swift
//  NanitHB
//
//  Created by Konstantin Bezzemelnyi on 21.09.2025.
//

import SwiftUI

protocol BirthdayScreenViewModelProtocol: ObservableObject {
    var ageTitleStartText: String { get }
    var ageNumber: Int { get }
    var ageTitleEndText: String { get }
    var theme: BirthdayTheme { get }
    
    var image: FileCached? { get }
    func setImage(file: FileCached?)
    func onBackTapped()
}
