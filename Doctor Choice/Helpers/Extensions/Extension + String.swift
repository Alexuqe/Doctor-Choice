import Foundation

extension String {
    func workExperience(from start: TimeInterval?, to end: TimeInterval?) -> Self {
        var startDate = Date(timeIntervalSince1970: .zero)
        var endDate = Date(timeIntervalSince1970: .zero)

        if let start = start, let end = end {
            startDate = Date(timeIntervalSince1970: start)
            endDate = Date(timeIntervalSince1970: end)
        } else {
            startDate = Date.now
            endDate = Date.now
        }

        let components = Calendar.current
            .dateComponents(
                [.year, .month, .day],
                from: startDate, to: endDate
            )

        let years = components.year ?? 0

        if years > 4 {
            return "\(years) лет"
        } else if years <= 4 && years > 1 {
            return "\(years) года"
        } else if years == 1 {
            return "\(years) год"
        }

        return self
    }
}

extension DateComponents {
    func formatExperience() -> String {
        let years = self.year ?? 0
        let months = self.month ?? 0

        switch (years, months) {
        case (0, 0):
            return "менее месяца"
        case (0, let m):
            return "\(m) мес."
        case (let y, 0):
            return "\(y) лет"
        default:
            return "\(years) лет \(months) мес."
        }
    }
}

extension Collection where Self == [WorkExperience]{
    func totalWorkExperience() -> String {
        let now = Date()

        let totalSeconds = self.reduce(0.0) { partial, item in
            guard let startInterval = item.startDate else { return partial }
            let endInterval = item.endDate ?? now.timeIntervalSince1970

            let start = Date(timeIntervalSince1970: startInterval)
            let end = Date(timeIntervalSince1970: endInterval)

            return partial + end.timeIntervalSince(start)
        }

        guard totalSeconds > 0 else { return "нет опыта" }

        let startDate = Date(timeIntervalSince1970: 0)
        let endDate = Date(timeIntervalSince1970: totalSeconds)

        let components = Calendar.current.dateComponents([.year, .month, .day],
                                                         from: startDate,
                                                         to: endDate)

        return components.formatExperience()
    }
}
