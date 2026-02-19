import Foundation

struct HigherEducation: Decodable, Hashable, Equatable   {
    let id: Int
    let university: String
    let specialization: String?
    let qualification: String
    let startDate: Date?
    let endDate: Date?

    enum HigherCodingKeys: String, CodingKey {
        case id
        case university
        case specialization
        case qualification
        case startDate = "start_date"
        case endDate = "end_date"
    }
}
