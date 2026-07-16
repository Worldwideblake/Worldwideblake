import SwiftUI

enum JobStatus: String, Codable, CaseIterable, Identifiable {
    case notApplied = "Not Applied"
    case saved = "Saved"
    case applied = "Applied"
    case interviewing = "Interviewing"
    case offer = "Offer"
    case rejected = "Rejected"
    case closed = "Closed"

    var id: String { rawValue }

    var tint: Color {
        switch self {
        case .notApplied:   .gray
        case .saved:        .indigo
        case .applied:      .green
        case .interviewing: .orange
        case .offer:        .mint
        case .rejected:     .red
        case .closed:       .secondary
        }
    }

    var icon: String {
        switch self {
        case .notApplied:   "circle.dashed"
        case .saved:        "bookmark.fill"
        case .applied:      "paperplane.fill"
        case .interviewing: "person.2.fill"
        case .offer:        "checkmark.seal.fill"
        case .rejected:     "xmark.circle.fill"
        case .closed:       "archivebox.fill"
        }
    }
}

struct Job: Identifiable, Codable, Equatable {
    var id: String
    var company: String
    var category: String
    var role: String
    var location: String
    var url: String
    var careersUrl: String
    var notes: String
    var opens: String
    var closes: String
    var starts: String
    var status: JobStatus
    var dateApplied: Date?

    var categoryTint: Color {
        switch category {
        case "Consulting":  .purple
        case "Fortune 500": .blue
        case "Startup":     .teal
        default:            .gray
        }
    }

    // Seed entries carry no status/date; decode with sensible defaults.
    enum CodingKeys: String, CodingKey {
        case id, company, category, role, location, url, careersUrl, notes,
             opens, closes, starts, status, dateApplied
    }

    init(id: String, company: String, category: String, role: String, location: String,
         url: String, careersUrl: String, notes: String,
         opens: String = "", closes: String = "", starts: String = "",
         status: JobStatus = .notApplied, dateApplied: Date? = nil) {
        self.id = id
        self.company = company
        self.category = category
        self.role = role
        self.location = location
        self.url = url
        self.careersUrl = careersUrl
        self.notes = notes
        self.opens = opens
        self.closes = closes
        self.starts = starts
        self.status = status
        self.dateApplied = dateApplied
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(String.self, forKey: .id)
        company = try c.decode(String.self, forKey: .company)
        category = try c.decodeIfPresent(String.self, forKey: .category) ?? "Other"
        role = try c.decodeIfPresent(String.self, forKey: .role) ?? ""
        location = try c.decodeIfPresent(String.self, forKey: .location) ?? ""
        url = try c.decodeIfPresent(String.self, forKey: .url) ?? ""
        careersUrl = try c.decodeIfPresent(String.self, forKey: .careersUrl) ?? ""
        notes = try c.decodeIfPresent(String.self, forKey: .notes) ?? ""
        opens = try c.decodeIfPresent(String.self, forKey: .opens) ?? ""
        closes = try c.decodeIfPresent(String.self, forKey: .closes) ?? ""
        starts = try c.decodeIfPresent(String.self, forKey: .starts) ?? ""
        status = try c.decodeIfPresent(JobStatus.self, forKey: .status) ?? .notApplied
        dateApplied = try c.decodeIfPresent(Date.self, forKey: .dateApplied)
    }
}
