import Foundation

struct WorkExperience: Decodable, Hashable, Equatable, Comparable  {
    static func < (lhs: WorkExperience, rhs: WorkExperience) -> Bool {
        lhs == rhs
    }

    let id: Int
    let organization: String
    let position: String
    let startDate: TimeInterval?
    let endDate: TimeInterval?
    let untilNow: Bool?

    enum WorkExperienceCodingKeys: String, CodingKey {
        case id
        case organization
        case position
        case startDate = "start_date"
        case endDate = "end_date"
        case untilNow = "until_now"
    }
}
