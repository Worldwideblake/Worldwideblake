import SwiftUI

struct AddJobView: View {
    @EnvironmentObject private var store: JobStore
    @Environment(\.dismiss) private var dismiss

    @State private var company = ""
    @State private var role = ""
    @State private var location = ""
    @State private var category = "Fortune 500"
    @State private var url = ""
    @State private var notes = ""

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Company", text: $company)
                    TextField("Role / title", text: $role)
                    TextField("Location (e.g. Houston, TX)", text: $location)
                    Picker("Category", selection: $category) {
                        ForEach(["Fortune 500", "Consulting", "Startup", "Other"], id: \.self) { Text($0) }
                    }
                }
                Section {
                    TextField("Job / careers URL", text: $url)
                        .keyboardType(.URL)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    TextField("Notes", text: $notes, axis: .vertical)
                }
            }
            .navigationTitle("Add job")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        store.add(Job(
                            id: "u-\(UUID().uuidString.prefix(8))",
                            company: company,
                            category: category,
                            role: role,
                            location: location,
                            url: url,
                            careersUrl: url,
                            notes: notes
                        ))
                        dismiss()
                    }
                    .disabled(company.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}
