import Foundation
import SwiftUI

enum Selection: CaseIterable {
    case price
    case experience
    case rating

    var title: String {
        switch self {
        case .price:      "По цене"
        case .experience: "По стажу"
        case .rating:     "По рейтингу"
        }
    }

    var image: String? {
        switch self {
        case .price:      "arrow.down"
        case .experience: nil
        case .rating:     nil
        }
    }
}


struct SelectionConfigure {
    let height: CGFloat
    let activeColor: Color
    let inActiveColor: Color
}

extension SelectionConfigure {
    static let defaultSelection = SelectionConfigure(
        height: 45,
        activeColor: ColorStyles.pink,
        inActiveColor: .clear
    )
}
