import SwiftUI

// ["SFProDisplay-Regular", "SFProDisplay-Medium", "SFProDisplay-Semibold"]

struct FontStyle {
    let font: Font
}

extension FontStyle {
    enum Family: String {
        case SFPro = "SFProDisplay"
    }

    enum Outlines: String {
        case regular = "-Regular"
        case medium = "-Medium"
        case semiBold = "-Semibold"
    }
}

extension FontStyle {
    static func createFont(
        _ family: FontStyle.Family,
        outlines: FontStyle.Outlines,
        size: CGFloat
    ) -> Font {
        return Font.custom(family.rawValue + outlines.rawValue, size: size)
    }
}

extension FontStyle {
    static let h2 = FontStyle(font: createFont(.SFPro, outlines: .semiBold, size: 24))
    static let h3 = FontStyle(font: createFont(.SFPro, outlines: .medium, size: 20))
    static let h4 = FontStyle(font: createFont(.SFPro, outlines: .semiBold, size: 16))
    static let sub1 = FontStyle(font: createFont(.SFPro, outlines: .regular, size: 16))
    static let sub2 = FontStyle(font: createFont(.SFPro, outlines: .regular, size: 14))
    static let sub3 = FontStyle(font: createFont(.SFPro, outlines: .regular, size: 12))
}
