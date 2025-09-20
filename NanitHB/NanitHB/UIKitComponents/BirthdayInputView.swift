//
//  BirthdayInputView.swift
//  NanitHB
//
//  Created by Konstantin Bezzemelnyi on 20.09.2025.
//

import UIKit

final class BirthdayInputView: UIView, UITextFieldDelegate {
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
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        dateTextField.text = formatter.string(from: datePicker.date)
        date = datePicker.date
    }
    
    @objc private func doneTapped() {
        dateTextField.resignFirstResponder()
        dateChanged()
    }
    
    @objc private func clearTapped() {
        dateTextField.text = ""
        onClear?()
        dateTextField.resignFirstResponder()
    }
}
