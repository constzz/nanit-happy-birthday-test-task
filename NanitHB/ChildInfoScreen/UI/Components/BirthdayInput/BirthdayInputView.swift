//
//  BirthdayInputView.swift
//  NanitHB
//
//  Created by Konstantin Bezzemelnyi on 20.09.2025.
//

import UIKit
import Foundation

final class BirthdayInputView: UIView, UITextFieldDelegate {
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
    
    private(set) var dateTextField = UITextField()
    private(set) var datePicker = UIDatePicker()
    var onClear: (() -> Void)?
    var onDateChanged: ((Date?) -> Void)?
    var maxDate: Date? {
        didSet { datePicker.maximumDate = maxDate }
    }
    
    @Published private(set) var date: Date? {
        didSet { onDateChanged?(date) }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        dateTextField.placeholder = NSLocalizedString("Select birthday", comment: "Birthday input placeholder")
        dateTextField.borderStyle = .roundedRect
        dateTextField.delegate = self
        addSubview(dateTextField)
        dateTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            dateTextField.trailingAnchor.constraint(equalTo: trailingAnchor),
            dateTextField.topAnchor.constraint(equalTo: topAnchor),
            dateTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        dateTextField.inputView = datePicker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: NSLocalizedString("Done", comment: "Done button for date picker"), style: .done, target: self, action: #selector(doneTapped))
        let clearButton = UIBarButtonItem(title: NSLocalizedString("Clear", comment: "Clear button for date picker"), style: .plain, target: self, action: #selector(clearTapped))
        toolbar.setItems([clearButton, UIBarButtonItem.flexibleSpace(), doneButton], animated: false)
        dateTextField.inputAccessoryView = toolbar
        
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
    }
    
    @objc private func dateChanged() {
        dateFormatter.dateStyle = .medium
        dateTextField.text = dateFormatter.string(from: datePicker.date)
    }
    
    @objc private func doneTapped() {
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: datePicker.date, to: currentDate)
        
        if let years = components.year, years > 12 {
            let alert = UIAlertController(
                title: NSLocalizedString("Oops! That's a bit too old!", comment: "Alert title for age > 12"),
                message: NSLocalizedString("Our birthday celebration is designed for kids up to 12 years old. Please select a more recent date. 🎈", comment: "Alert message for age > 12"),
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK button"), style: .default))
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let topViewController = windowScene.windows.first?.rootViewController {
                topViewController.present(alert, animated: true)
            }
            
            // Keep the previous date if it exists, otherwise clear
            if let previousDate = date {
                datePicker.date = previousDate
                dateTextField.text = dateFormatter.string(from: previousDate)
            } else {
                clearTapped()
            }
            return
        }
        
        dateTextField.resignFirstResponder()
        dateTextField.text = dateFormatter.string(from: datePicker.date)
        date = datePicker.date
    }
    
    @objc private func clearTapped() {
        dateTextField.text = ""
        onClear?()
        dateTextField.resignFirstResponder()
    }
}
