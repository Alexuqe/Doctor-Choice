import Foundation

struct User: Decodable, Hashable, Equatable, Identifiable, Comparable {
    let id: UUID
    let firstName: String
    let patronymic: String
    let lastName: String
    let specialization: [Specialization]
    let ratings: [Rating]
    let ratingsRating: Double?
    let seniority: Int
    let textChatPrice: Int
    let videoChatPrice: Int
    let homePrice: Int?
    let hospitalPrice: Int?
    let avatar: String?
    let nearestReceptionTime: Date?
    let freeReceptionTime: [FreeReceptionTime]?
    let educationTypeLabel: EducationType?
    let higherEducation: [HigherEducation]?
    let workExperience: [WorkExperience]?
    let rank: Int
    let scientificDegreeLabel: String
    let categoryLabel: String
    var isFavorite: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case patronymic
        case lastName = "last_name"
        case specialization
        case ratings
        case ratingsRating = "ratings_rating"
        case seniority
        case textChatPrice = "text_chat_price"
        case videoChatPrice = "video_chat_price"
        case homePrice = "home_price"
        case hospitalPrice = "hospital_price"
        case avatar
        case nearestReceptionTime = "nearest_reception_time"
        case freeReceptionTime = "free_reception_time"
        case educationTypeLabel = "education_type_label"
        case higherEducation = "higher_education"
        case workExperience = "work_expirience"
        case rank
        case scientificDegreeLabel = "scientific_degree_label"
        case categoryLabel = "category_label"
        case isFavorite = "is_favorite"
    }

    static func < (lhs: User, rhs: User) -> Bool {
        lhs == rhs
    }
}
