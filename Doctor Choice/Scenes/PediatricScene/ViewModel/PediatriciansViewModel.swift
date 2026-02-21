import Observation
import Foundation
import SwiftUI

@MainActor
@Observable final class PediatriciansViewModel {
    var visible: [User] = []
    var isLoading = false
    var isRefreshing = false
    var canLoadMore = true
    var selectedSegment: Selection = .experience {
        didSet {
            filtrated()
        }
    }

    let tabs: [Selection] = Selection.allCases


    var searchText: String = "" {
        didSet { searchDebounced() }
    }

    @ObservationIgnored private var model: [User] = []
    @ObservationIgnored private var filtred: [User] = []
    @ObservationIgnored private var currentEnd = 0
    @ObservationIgnored private let pageSize = 3
    @ObservationIgnored private var debounceTask: Task<Void, Never>?
    @ObservationIgnored private var searchedTask: Task<Void, Never>?

    @ObservationIgnored private let networkService: NetworkServiceProtocol
    @ObservationIgnored private let router: Routeble

    init(networkService: NetworkServiceProtocol, router: Routeble) {
        self.networkService = networkService
        self.router = router

        Task { await load() }
    }

    func openDoctorDetail(for user: User) {
        router.push(to: .main(.pediatricianDetail(user)))
    }

    func binding(for user: User) -> Binding<User> {
        Binding(
            get: {
                self.visible.first(where: { $0.id == user.id }) ?? user
            },
            set: { updated in
                if let index = self.visible.firstIndex(where: { $0.id == user.id }) {
                    self.visible[index] = updated
                }
            }
        )
    }

    func refresh() async {
        guard !isRefreshing else { return }
        isRefreshing = true

        print("🔵 refresh start")

        debounceTask?.cancel()
        searchedTask?.cancel()
        isLoading = false
        canLoadMore = true

        defer {
            isRefreshing = false
            print("🟢 refresh end")
        }

        await load()
    }

    func loadMoreDebounced() {
        guard canLoadMore, !isLoading, !isRefreshing else { return }

        debounceTask?.cancel()
        debounceTask = Task {
            try? await Task.sleep(nanoseconds: 250_000_000)
            await appendNextPage()
        }
    }

    private func load() async {
        print("⬇️ load() called")

        do {
            let pediatric: Pediatricians = try await networkService.fetchUsers(url: .default)
            model = pediatric.data.users
            print("📦 loaded model:", model.count)

            applyFilter()
            print("🔍 filtered:", filtred.count)

            resetPaging()

            await Task.yield()
            
            await appendNextPage()
            print("👀 visible:", visible.count)
        } catch {
            print("❌ Ошибка обновления:", error)
        }
    }

    private func appendNextPage() async {
        guard canLoadMore, (!isLoading || isRefreshing) else { return }

        isLoading = true
        defer { isLoading = false }

        let remaining = filtred.count - currentEnd
        let loadCount = min(pageSize, remaining)

        guard loadCount > 0 else {
            canLoadMore = false
            return
        }

        let nextEnd = currentEnd + loadCount
        let chunk = Array(filtred[currentEnd..<nextEnd])

        visible.append(contentsOf: chunk)
        currentEnd = nextEnd
        canLoadMore = currentEnd < filtred.count
    }

    private func resetPaging() {
        visible.removeAll()
        currentEnd = 0
        canLoadMore = !filtred.isEmpty
    }

    private func applyFilter() {
        let text = searchText
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        if text.isEmpty {
            filtred = model
        } else {
            filtred = model.filter { user in
                user.firstName.lowercased().hasPrefix(text)
            }
        }
    }

    private func searchDebounced() {
        searchedTask?.cancel()
        searchedTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: 300_000_000)

            guard let self else { return }
            applyFilter()
            resetPaging()

            await appendNextPage()
        }
    }

    private func filtrated() {
        switch selectedSegment {
            case .price:
                visible.sort { $0.hospitalPrice ?? 0 > $1.hospitalPrice ?? 0 }
            case .experience:
                visible.sort { ($0.workExperience?.count ?? 0) < ($1.workExperience?.count ?? 0) }
            case .rating:
                visible.sort { $0.rank > $1.rank }
        }

        Task {
            await appendNextPage()
        }
    }

}
