enum TabItemModel: CaseIterable, Hashable {
    case home
    case clipboard
    case message
    case person

    var image: String {
        switch self {
            case .home:      "house.fill"
            case .clipboard: "list.clipboard.fill"
            case .message:   "message.fill"
            case .person:    "person.fill"
        }
    }

    var title: String {
        switch self {
            case .home:      "Главная"
            case .clipboard: "Приемы"
            case .message:   "Чат"
            case .person:    "Профиль"
        }
    }
}
