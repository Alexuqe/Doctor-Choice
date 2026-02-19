import Foundation

struct WorkExperience: Decodable, Hashable, Equatable  {
    let id: Int
    let organization: String
    let position: String
    let startDate: Date?
    let endDate: Date?
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
