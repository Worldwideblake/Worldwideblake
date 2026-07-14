import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var store: JobStore
    @State private var search = ""
    @State private var cityFilter = "All cities"
    @State private var categoryFilter = "All categories"
    @State private var statusFilter: JobStatus?
    @State private var showAdd = false

    private let cities = ["All cities", "Houston", "Austin", "Dallas", "Remote"]
    private let categories = ["All categories", "Consulting", "Fortune 500", "Startup", "Other"]

    private var filtered: [Job] {
        store.jobs.filter { job in
            if let s = statusFilter, job.status != s { return false }
            if cityFilter != "All cities",
               !job.location.localizedCaseInsensitiveContains(cityFilter) { return false }
            if categoryFilter != "All categories", job.category != categoryFilter { return false }
            if !search.isEmpty {
                let hay = "\(job.company) \(job.role) \(job.notes) \(job.location)"
                if !hay.localizedCaseInsensitiveContains(search) { return false }
            }
            return true
        }
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    statsRow
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                }
                Section {
                    ForEach(filtered) { job in
                        NavigationLink(value: job.id) {
                            JobRow(job: job)
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            if job.status != .applied {
                                Button {
                                    var j = job
                                    j.status = .applied
                                    store.update(j)
                                } label: {
                                    Label("Applied", systemImage: "paperplane.fill")
                                }
                                .tint(.green)
                            }
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                store.remove(job)
                            } label: {
                                Label("Remove", systemImage: "trash")
                            }
                        }
                    }
                } footer: {
                    Text("Postings move fast — tap through and confirm a role is still open on the company site before applying.")
                }
            }
            .navigationTitle("Job Tracker")
            .navigationDestination(for: String.self) { id in
                if let job = store.jobs.first(where: { $0.id == id }) {
                    JobDetailView(job: job)
                }
            }
            .searchable(text: $search, prompt: "Company, role, notes…")
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    filterMenu
                    ShareLink(item: store.csv, preview: SharePreview("job-tracker.csv")) {
                        Image(systemName: "square.and.arrow.up")
                    }
                    Button {
                        showAdd = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAdd) {
                AddJobView()
            }
            .overlay {
                if filtered.isEmpty {
                    ContentUnavailableView.search
                }
            }
        }
    }

    private var statsRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                StatTile(label: "Total", count: store.jobs.count, tint: .indigo,
                         selected: statusFilter == nil) { statusFilter = nil }
                ForEach([JobStatus.notApplied, .applied, .interviewing, .offer]) { s in
                    StatTile(label: s.rawValue, count: store.count(s), tint: s.tint,
                             selected: statusFilter == s) {
                        statusFilter = statusFilter == s ? nil : s
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 6)
        }
    }

    private var filterMenu: some View {
        Menu {
            Picker("City", selection: $cityFilter) {
                ForEach(cities, id: \.self) { Text($0) }
            }
            Picker("Category", selection: $categoryFilter) {
                ForEach(categories, id: \.self) { Text($0) }
            }
            Picker("Status", selection: $statusFilter) {
                Text("All statuses").tag(JobStatus?.none)
                ForEach(JobStatus.allCases) { s in
                    Text(s.rawValue).tag(JobStatus?.some(s))
                }
            }
        } label: {
            Image(systemName: cityFilter != "All cities" || categoryFilter != "All categories" || statusFilter != nil
                  ? "line.3.horizontal.decrease.circle.fill"
                  : "line.3.horizontal.decrease.circle")
        }
    }
}

struct StatTile: View {
    let label: String
    let count: Int
    let tint: Color
    let selected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 2) {
                Text("\(count)")
                    .font(.title2.weight(.bold))
                    .monospacedDigit()
                HStack(spacing: 5) {
                    Circle().fill(tint).frame(width: 7, height: 7)
                    Text(label)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .strokeBorder(selected ? tint : Color.primary.opacity(0.08),
                                  lineWidth: selected ? 1.5 : 1)
            )
        }
        .buttonStyle(.plain)
    }
}

struct JobRow: View {
    let job: Job

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            HStack {
                Text(job.company)
                    .font(.headline)
                Spacer()
                Label(job.status.rawValue, systemImage: job.status.icon)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(job.status.tint)
                    .labelStyle(.titleAndIcon)
            }
            if !job.role.isEmpty {
                Text(job.role)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            HStack(spacing: 6) {
                Text(job.location)
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .lineLimit(1)
                Text(job.category)
                    .font(.caption2.weight(.semibold))
                    .padding(.horizontal, 7)
                    .padding(.vertical, 2)
                    .background(job.categoryTint.opacity(0.15), in: Capsule())
                    .foregroundStyle(job.categoryTint)
            }
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    ContentView().environmentObject(JobStore())
}
