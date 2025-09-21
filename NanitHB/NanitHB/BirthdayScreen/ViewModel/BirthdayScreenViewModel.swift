//
//  BirthdayScreenViewModel.swift
//  NanitHB
//
//  Created by Konstantin Bezzemelnyi on 21.09.2025.
//


import Foundation
import SwiftUI

final class BirthdayScreenViewModel: BirthdayScreenViewModelProtocol {
    private(set) var ageTitleStartText: String
    private(set) var ageNumber: Int
    private(set) var ageTitleEndText: String
    private(set) var image: FileCached?
    let theme: BirthdayTheme
    
    // MARK: - Properties
    private let repository: ChildInfoRepositoryProtocol
    private static let calendar: Calendar = .current
    private let onBack: () -> Void
    
    struct Input: Hashable {
        let name: String
        let birthdayDate: Date
        let avatar: FileCached?
        let theme: BirthdayTheme
    }
    
    // MARK: - Init
    init(
        input: Input,
        repository: ChildInfoRepositoryProtocol,
        onBack: @escaping () -> Void
    ) {
        self.repository = repository
        self.onBack = onBack
        let diffComponents = Self.calendar.dateComponents([.month, .year], from: input.birthdayDate, to: .now)
        self.theme = input.theme
        self.ageTitleStartText = Self.makeAgeTitleStartText(name: input.name)
        self.ageNumber = Self.makeAgeNumber(forBirthday: input.birthdayDate)
        self.ageTitleEndText = Self.makeAgeTitleEndText(diffComponents: diffComponents)
    }
    
    func onBackTapped() {
        onBack()
    }
    
    func setImage(file: FileCached?) {
        if let file {
            repository.save(fileCached: file)
        }
        image = file
    }
}

private extension BirthdayScreenViewModel {
    static func makeAgeTitleStartText(name: String) -> String {
        "TODAY \(name.uppercased()) IS"
    }
    
    static func makeAgeTitleEndText(diffComponents: DateComponents) -> String {
        if let years = diffComponents.year, years > 0 {
            return years == 1 ? "YEAR" : "YEARS"
        } else if let months = diffComponents.month {
            return months == 1 ? "MONTH" : "MONTHS"
        } else {
            Logger.error("Not expected to show the view to celebrate 0 months")
            return "MONTHS"
        }
    }
    
    static func makeAgeNumber(forBirthday birthday: Date, calendar: Calendar = .current) -> Int {
        let components = calendar.dateComponents([.month, .year], from: birthday, to: .now)
        if let years = components.year, years > 0 {
            return years
        } else if let months = components.month {
            return months
        } else {
            Logger.error("Not expected to show the view to celebrate 0 months")
            return 0
        }
    }
}
