import Foundation

struct AllDataTrendingForWeek: Codable {
    let page: Int
    let results: [DataResult]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
