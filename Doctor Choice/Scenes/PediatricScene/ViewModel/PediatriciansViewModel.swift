import Observation
import Foundation

@MainActor
@Observable final class PediatriciansViewModel {
    var visible: [User] = []
    var isLoading = false
    var isRefreshing = false
    var canLoadMore = true

    /*@ObservationIgnored*/ /*private*/ var model: [User] = []
    @ObservationIgnored private var currentEnd = 0
    @ObservationIgnored private let pageSize = 8
    @ObservationIgnored private var debounceTask: Task<Void, Never>?

    @ObservationIgnored private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService

        load()
    }

    func load() {
        Task {
            guard !isLoading else { return }
            isLoading = true
            
            defer { isLoading = false }
            
            do {
                let pediatric: Pediatricians = try await networkService.fetchUsers(url: .default)
                model = pediatric.data.users
                print(model)
                resetPaging()
                await appendNextPage()
            } catch {
                print("Ошибка обновления:", error)
            }
        }
    }

    private func resetPaging() {
        visible.removeAll()
        currentEnd = 0
        canLoadMore = !model.isEmpty
    }

    func prefetchIsNeeded(_ user: User) {
        guard let index = visible.firstIndex(of: user) else { return }
        if index >= visible.count - 1 {
            loadMoreDebounced()
        }
    }

    func loadMoreDebounced() {
        guard canLoadMore, !isLoading, !isRefreshing else { return }

        debounceTask?.cancel()
        debounceTask = Task {
            try? await Task.sleep(nanoseconds: 250_000_000)
            await appendNextPage()
        }
    }

    func appendNextPage() async {
        guard canLoadMore, !isLoading else { return }
        isLoading = true

        defer { isLoading = false }

        let remaining = model.count - currentEnd
        let loadCount = min(pageSize, remaining)

        guard loadCount > 0 else {
            canLoadMore = false
            return
        }

        let nextEnd = currentEnd + loadCount
        let chunk = Array(model[currentEnd..<nextEnd])

        visible.append(contentsOf: chunk)

        currentEnd = nextEnd
        canLoadMore = currentEnd < model.count
    }

}
