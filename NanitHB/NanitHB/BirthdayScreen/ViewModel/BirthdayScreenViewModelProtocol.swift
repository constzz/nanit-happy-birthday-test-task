//
//  BirthdayScreenViewModelProtocol.swift
//  NanitHB
//
//  Created by Konstantin Bezzemelnyi on 21.09.2025.
//

import SwiftUI

protocol BirthdayScreenViewModelProtocol: ObservableObject {
    var childName: String { get }
    var age: String { get }
    var ageUnit: String { get }
    var backgroundColor: Color { get }
    func onBackTapped()
}
