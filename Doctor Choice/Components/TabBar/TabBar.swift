import SwiftUI

struct TabBar: View {
    @Binding var page: TabItemModel
    let bars: [TabItemModel]

    var body: some View {
        HStack {
            ForEach(bars, id: \.self) { bar in
                TabItem(pages: $page, item: bar)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 18)
        .background(.white)
    }
}

#Preview {
    @Previewable @State var page: TabItemModel = .home

    TabBar(page: $page, bars: TabItemModel.allCases)
}
