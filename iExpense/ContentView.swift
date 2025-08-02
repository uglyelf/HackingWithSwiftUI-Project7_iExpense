//
//  ContentView.swift
//  iExpense
//
//  Created by Gregory Randolph on 6/27/25.
//

import SwiftUI
import Observation


struct ContentView: View {
    @State private var expenses = Expenses()
    
    @State private var path = [String]()
//    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(expenses.myExpenses) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.type.rawValue)
                            }
                            
                            Spacer()
                            Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                .foregroundColor(item.amount <= 10 ? .green : (item.amount <= 100 ? .yellow : .red))
                        }
                    }
                    .onDelete(perform: removePersonalExpense)
                }
                Section {
                    ForEach(expenses.workExpenses) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.type.rawValue)
                            }
                            
                            Spacer()
                            Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                .foregroundColor(item.amount <= 10 ? .green : (item.amount <= 100 ? .yellow : .red))
                        }
                    }
                    .onDelete(perform: removeBusinessExpense)
                }
                
            }
            .navigationTitle("iExpense")
            .toolbar {
                NavigationLink {
                    AddExpenseView(expenses: expenses)
                } label: {
                    Image(systemName: "plus")
                }
//                Button("Add Expense", systemImage: "plus") {
//                    NavigationLink("Add Expense", ) {
//                        
//                    }
//                }
            }
        }
//        .sheet(isPresented: $showingAddExpense) {
//            AddExpenseView(expenses: expenses)
//        }
    }

    func removePersonalExpense(at offsets: IndexSet) {
        for offset in offsets {
            let id: UUID = expenses.myExpenses[offset].id
            if let index = expenses.items.firstIndex(where: {$0.id == id}) {
                expenses.items.remove(at: index)
            }
        }
    }
    func removeBusinessExpense(at offsets: IndexSet) {
        for offset in offsets {
            let id: UUID = expenses.workExpenses[offset].id
            if let index = expenses.items.firstIndex(where: {$0.id == id}) {
                expenses.items.remove(at: index)
            }
        }
    }
}

enum ExpenseType: String, CaseIterable, Identifiable, Codable {
    var id: Self { self }
    case business, personal
}

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    var date = Date.now
    let name: String
    let type: ExpenseType
    let amount: Double
}

@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    var myExpenses: [ExpenseItem] {
        return items.filter {$0.type == .personal}
    }
    var workExpenses: [ExpenseItem] {
        return items.filter {$0.type == .business}
    }
    
    init() {
        guard let savedItems = UserDefaults.standard.data(forKey: "Items"),
              let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) else {
            items = []
            return
        }
        items = decodedItems
    }
}

#Preview {
    ContentView()
}
