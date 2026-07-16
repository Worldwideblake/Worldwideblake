import SwiftUI

struct JobDetailView: View {
    @EnvironmentObject private var store: JobStore
    @Environment(\.dismiss) private var dismiss
    @State var job: Job

    var body: some View {
        Form {
            Section {
                LabeledContent("Company", value: job.company)
                if !job.role.isEmpty { LabeledContent("Role", value: job.role) }
                if !job.location.isEmpty { LabeledContent("Location", value: job.location) }
                LabeledContent("Category", value: job.category)
                LabeledContent("Apply window", value: {
                    if !job.opens.isEmpty && !job.closes.isEmpty { return "\(job.opens) → \(job.closes)" }
                    if !job.closes.isEmpty { return "by \(job.closes)" }
                    if !job.opens.isEmpty { return "opens \(job.opens)" }
                    return "Rolling"
                }())
                if !job.starts.isEmpty { LabeledContent("Starts", value: job.starts) }
            }

            Section("Application") {
                Picker("Status", selection: $job.status) {
                    ForEach(JobStatus.allCases) { s in
                        Label(s.rawValue, systemImage: s.icon).tag(s)
                    }
                }
                DatePicker(
                    "Applied on",
                    selection: Binding(
                        get: { job.dateApplied ?? Date() },
                        set: { job.dateApplied = $0 }
                    ),
                    displayedComponents: .date
                )
                .opacity(job.dateApplied == nil ? 0.4 : 1)
            }

            Section("Notes") {
                TextField("Notes", text: $job.notes, axis: .vertical)
                    .lineLimit(2...8)
            }

            Section("Links") {
                if let url = URL(string: job.url), !job.url.isEmpty {
                    Link(destination: url) {
                        Label("Open posting", systemImage: "arrow.up.right.square")
                    }
                }
                if let url = URL(string: job.careersUrl), !job.careersUrl.isEmpty, job.careersUrl != job.url {
                    Link(destination: url) {
                        Label("Company careers search", systemImage: "building.2")
                    }
                }
            }

            Section {
                Button("Remove from tracker", role: .destructive) {
                    store.remove(job)
                    dismiss()
                }
            }
        }
        .navigationTitle(job.company)
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: job) { _, updated in
            store.update(updated)
        }
    }
}
