//
//  BirthdayInputField.swift
//  NanitHB
//
//  Created by Konstantin Bezzemelnyi on 20.09.2025.
//

import SwiftUI

struct BirthdayInputField: UIViewRepresentable {
    @Binding var date: Date?
    
    func makeUIView(context: Context) -> BirthdayInputView {
        let view = BirthdayInputView()
        view.onClear = {
            self.date = nil
        }
        view.onDateChanged = { newDate in
            self.date = newDate
        }
        return view
    }
    
    func updateUIView(_ uiView: BirthdayInputView, context: Context) {
        if let date = date {
            uiView.datePicker.date = date
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            uiView.dateTextField.text = formatter.string(from: date)
        } else {
            uiView.dateTextField.text = ""
        }
    }
}

#Preview {
    BirthdayInputField(date: .constant(nil))
}

#Preview {
    BirthdayInputField(date: .constant(.now))
}
