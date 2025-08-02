//
//  AddExpenseView.swift
//  iExpense
//
//  Created by Gregory Randolph on 6/30/25.
//

import SwiftUI

struct AddExpenseView: View {
    @State private var name = ""
    @State private var type = ExpenseType.personal
    @State private var amount = 0.0
    
    @State private var editNameViaTitle = false
    
    @Environment(\.dismiss) var dismiss
    
    var expenses: Expenses
    
    var body: some View {
        NavigationStack {
            Form {
                if !editNameViaTitle {
                    TextField("Name", text: $name)
                }
                
                Picker("Type", selection: $type) {
                    ForEach(ExpenseType.allCases) { type in
                        Text(type.rawValue)
                    }
                }
                
                TextField("Amount", value: $amount, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
            }
            // See the extension at the bottom of the file for explanation
            .if(editNameViaTitle) {
                $0.navigationTitle($name)
            }
            .if(!editNameViaTitle) {
                $0.navigationTitle("Add New Expense")
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    if !name.isEmpty && amount > 0 {
                        Button("Save") {
                            let item = ExpenseItem(name: name, type: type, amount: amount)
                            expenses.items.append(item)
                            dismiss()
                        }
                    }
                }
                
                ToolbarItem {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Menu("Settings") {
                        Toggle("Edit Name by Title", isOn: $editNameViaTitle)
                    }
                }
            }
            .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    AddExpenseView(expenses: Expenses())
}

/*
 Why the kluge? \
 Day 46 Challenge 2 asks you to edit this project so users can rename the expense through the title
 Akward turtle.
 So I wanted to make it so users could switch between a dedicated name field and the title by choice.
 
 This is a bit of a cargo cult, from the google AI overlords. I'd love to read more into how "transform"
 returns the View to modify with the um... modifier. 
 */
extension View {
    @ViewBuilder
    func `if`<T: View>(_ condition: Bool, transform: (Self) -> T) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
