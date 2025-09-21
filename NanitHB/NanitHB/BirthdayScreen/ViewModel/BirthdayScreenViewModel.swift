//
//  BirthdayScreenViewModel.swift
//  NanitHB
//
//  Created by Konstantin Bezzemelnyi on 21.09.2025.
//


import Foundation
import SwiftUI
import Combine

final class BirthdayScreenViewModel: BirthdayScreenViewModelProtocol {
    var imagePublisher: AnyPublisher<FileCached?, Never> {
        imageSubject.eraseToAnyPublisher()
    }
    
    private let imageSubject = CurrentValueSubject<FileCached?, Never>(nil)
    
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
        self.ageNumber = Self.makeAgeNumber(diffComponents: diffComponents)
        self.ageTitleEndText = Self.makeAgeTitleEndText(diffComponents: diffComponents)
        if let image = repository.getFileCached() {
            imageSubject.send(image)
        }
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
        String(format: NSLocalizedString("birthday_today_is", comment: "Today (birthday) ... is"), name.uppercased())
    }
    
    static func makeAgeTitleEndText(diffComponents: DateComponents) -> String {
        let years = diffComponents.year ?? 0
        let months = diffComponents.month ?? 0
        if years > 0 {
            let key = years == 1 ? "birthday_year_old" : "birthday_years_old"
            return String(format: NSLocalizedString(key, comment: "Year(s) old")).uppercased() + "!"
        } else {
            let key = months == 1 ? "birthday_month_old" : "birthday_months_old"
            return String(format: NSLocalizedString(key, comment: "Month(s) old")).uppercased() + "!"
        }
    }
    
    static func makeAgeNumber(diffComponents: DateComponents) -> Int {
        if let years = diffComponents.year, years > 0 {
            return years
        } else if let months = diffComponents.month {
            return months
        } else {
            Logger.error("Not expected to show the view to celebrate 0 months")
            return 0
        }
    }
}
