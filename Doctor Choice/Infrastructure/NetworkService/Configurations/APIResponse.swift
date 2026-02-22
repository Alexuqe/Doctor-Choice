struct APIResponseDTO<D: Decodable>: Decodable {
    let errorMessage: String?
    let data: D?
}
