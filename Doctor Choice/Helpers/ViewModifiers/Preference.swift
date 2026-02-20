import SwiftUI

struct Preference: ViewModifier {
    @Binding var excessTabWidth: CGFloat
    @Binding var minX: CGFloat

    var selectedTab: Selection
    var tabs: [Selection]
    var containerWidth: CGFloat
    var size: CGSize

    func body(content: Content) -> some View {
        content
        .preference(key: SizeKey.self, value: size)
        .onPreferenceChange(SizeKey.self) { size in
            if let index = tabs.firstIndex(of: selectedTab) {
            minX = containerWidth * CGFloat(index)
            excessTabWidth = .zero
            }
        }
    }
}

fileprivate struct SizeKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct OffsetKey: PreferenceKey{
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
