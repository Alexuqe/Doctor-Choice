import SwiftUI

extension View {

    func tabSelection(
        selectedTab: Binding<Selection>,
        excessTabWidth: Binding<CGFloat>,
        minX: Binding<CGFloat>,
        tabs: [Selection],
        tab: Selection,
        containerWidth: CGFloat
    ) -> some View {
        modifier(
            SelectionAnimation(
                selectedTab: selectedTab,
                excessTabWidth: excessTabWidth,
                minX: minX,
                tabs: tabs,
                tab: tab,
                containerWidth: containerWidth
            )
        )
    }

    func preferences(
        selectedTab: Selection,
        excessTabWidth: Binding<CGFloat>,
        minX: Binding<CGFloat>,
        tabs: [Selection],
        containerWidth: CGFloat,
        size: CGSize
    ) -> some View {
        modifier(
            Preference(
                excessTabWidth: excessTabWidth,
                minX: minX,
                selectedTab: selectedTab,
                tabs: tabs,
                containerWidth: containerWidth,
                size: size
            )
        )
    }

    @ViewBuilder
    func offset(
        coordinateSpace: CoordinateSpace,
        completion: @escaping (CGFloat) -> Void
    ) -> some View{
        self
        .overlay {
            GeometryReader{proxy in
                let minY = proxy.frame(in: coordinateSpace).minY

                Color.clear
                .preference(key: OffsetKey.self, value: minY)
                .onPreferenceChange(OffsetKey.self) { value in
                    completion(value)
                }
            }
        }
    }
}
