import SwiftUI

struct SegmentedControl<Indicator: View>: View {
    @Binding var selectedTab: Selection
    var tabs: [Selection]
    
    @ViewBuilder var indicatorView: (CGSize) -> Indicator

    @State private var excessTabWidth: CGFloat = .zero
    @State private var minX: CGFloat = .zero
    private let configure = SelectionConfigure.defaultSelection

    var body: some View {
        GeometryReader { view in
            let size = view.size
            let containerWidth = size.width / CGFloat(tabs.count)

            HStack(spacing: 0) {
                ForEach(tabs, id: \.self) { tab in

                SelectionView(selectedTab: $selectedTab, tab: tab)
                .tabSelection(
                    selectedTab: $selectedTab,
                    excessTabWidth: $excessTabWidth,
                    minX: $minX,
                    tabs: tabs,
                    tab: tab,
                    containerWidth: containerWidth
                )
                .background(alignment: .center) {
                    if tabs.first == tab {
                        IndicatorView(
                            indicatorView: indicatorView,
                            excessTabWidth: excessTabWidth,
                            minX: minX
                        )
                    }
                }
            }
            }
            .preferences(
                selectedTab: selectedTab,
                excessTabWidth: $excessTabWidth,
                minX: $minX,
                tabs: tabs,
                containerWidth: containerWidth,
                size: size
            )
        }
        .frame(height: configure.height)
    }
}
