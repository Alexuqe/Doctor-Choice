import Foundation

struct Pediatricians: Decodable {
    let count: Int
    let data: DataModel
}

struct APIResponse<D: Decodable>: Decodable {
    let data: D?
}
