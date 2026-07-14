import Foundation

@MainActor
final class JobStore: ObservableObject {
    @Published private(set) var jobs: [Job] = []
    private var deleted: Set<String> = []

    private struct Snapshot: Codable {
        var jobs: [Job]
        var deleted: Set<String>
    }

    private var saveURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("jobs.json")
    }

    init() {
        load()
    }

    // MARK: - Persistence

    private func load() {
        var loaded: [Job] = []
        if let data = try? Data(contentsOf: saveURL),
           let snap = try? decoder().decode(Snapshot.self, from: data) {
            loaded = snap.jobs
            deleted = snap.deleted
        }
        // Merge in any new seed jobs the user hasn't already got or removed.
        let have = Set(loaded.map(\.id))
        if let url = Bundle.main.url(forResource: "seed", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let seed = try? decoder().decode([Job].self, from: data) {
            loaded += seed.filter { !have.contains($0.id) && !deleted.contains($0.id) }
        }
        jobs = loaded.sorted { $0.company.localizedCaseInsensitiveCompare($1.company) == .orderedAscending }
        save()
    }

    private func save() {
        let snap = Snapshot(jobs: jobs, deleted: deleted)
        if let data = try? encoder().encode(snap) {
            try? data.write(to: saveURL, options: .atomic)
        }
    }

    private func decoder() -> JSONDecoder {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .iso8601
        return d
    }

    private func encoder() -> JSONEncoder {
        let e = JSONEncoder()
        e.dateEncodingStrategy = .iso8601
        return e
    }

    // MARK: - Mutations

    func update(_ job: Job) {
        guard let i = jobs.firstIndex(where: { $0.id == job.id }) else { return }
        var job = job
        if job.status == .applied && job.dateApplied == nil {
            job.dateApplied = Date()
        }
        jobs[i] = job
        save()
    }

    func add(_ job: Job) {
        jobs.insert(job, at: 0)
        save()
    }

    func remove(_ job: Job) {
        deleted.insert(job.id)
        jobs.removeAll { $0.id == job.id }
        save()
    }

    func count(_ status: JobStatus) -> Int {
        jobs.filter { $0.status == status }.count
    }

    // MARK: - Export

    var csv: String {
        let header = "company,role,location,category,status,dateApplied,url,notes"
        let df = ISO8601DateFormatter()
        let rows = jobs.map { j in
            [j.company, j.role, j.location, j.category, j.status.rawValue,
             j.dateApplied.map { df.string(from: $0) } ?? "", j.url, j.notes]
                .map { "\"\($0.replacingOccurrences(of: "\"", with: "\"\""))\"" }
                .joined(separator: ",")
        }
        return ([header] + rows).joined(separator: "\n")
    }
}
