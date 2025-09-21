//
//  BirthdayScreenViewModel.swift
//  NanitHB
//
//  Created by Konstantin Bezzemelnyi on 21.09.2025.
//


import Foundation
import SwiftUI


final class BirthdayScreenViewModel: BirthdayScreenViewModelProtocol {
    enum Theme: Int, CaseIterable {
        case blue
        case yellow
        case green
    }
    
    // MARK: - Properties
    @Published internal var childName: String = ""
    private var birthday: Date = .now
    private let theme: Theme
    private let repository: ChildInfoRepositoryProtocol
    private let onBack: () -> Void
    
    // MARK: - Init
    init(repository: ChildInfoRepositoryProtocol,
         onBack: @escaping () -> Void) {
        self.repository = repository
        self.onBack = onBack
        self.theme = Theme.allCases.randomElement() ?? .blue
        
        loadData()
    }
    
    // MARK: - Private
    private func loadData() {
        guard let name = repository.getName(),
              let birthday = repository.getBirthday() else {
            // This should never happen as the screen should only be shown
            // when we have both name and birthday
            return
        }
        
        self.childName = name
        self.birthday = birthday
    }
    
    // MARK: - Public
    var age: String {
        let components = Calendar.current.dateComponents([.month, .year], from: birthday, to: .now)
        if let years = components.year, years > 0 {
            return "\(years)"
        } else if let months = components.month {
            return "\(months)"
        }
        return "0"
    }
    
    var ageUnit: String {
        let components = Calendar.current.dateComponents([.year], from: birthday, to: .now)
        if let years = components.year, years > 0 {
            return years == 1 ? "Year" : "Years"
        } else {
            let months = Calendar.current.dateComponents([.month], from: birthday, to: .now).month ?? 0
            return months == 1 ? "Month" : "Months"
        }
    }
    
    var backgroundColor: Color {
        switch theme {
        case .blue:
            return Color(red: 0.44, green: 0.77, blue: 0.93)
        case .yellow:
            return Color(red: 1.0, green: 0.82, blue: 0.31)
        case .green:
            return Color(red: 0.67, green: 0.87, blue: 0.38)
        }
    }
    
    func onBackTapped() {
        onBack()
    }
}
