import Foundation

<<<<<<< HEAD
struct AllDataTrendingSeries: Codable {
    let page: Int
    let results: [SeriesDataResult]
    let totalPages, totalResults: Int
    
=======
struct Welcome: Codable {
    let page: Int
    let results: [Result]
    let totalPages, totalResults: Int

>>>>>>> d8b7bb0ca2f61b7d4babd75d0617856bd28b1d3f
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

<<<<<<< HEAD
struct SeriesDataResult: Codable {
=======
// MARK: - Result
struct Result: Codable {
>>>>>>> d8b7bb0ca2f61b7d4babd75d0617856bd28b1d3f
    let adult: Bool
    let backdropPath: String
    let id: Int
    let name, originalLanguage, originalName, overview: String
    let posterPath: String
<<<<<<< HEAD
=======
    let mediaType: MediaType
>>>>>>> d8b7bb0ca2f61b7d4babd75d0617856bd28b1d3f
    let genreIDS: [Int]
    let popularity: Double
    let firstAirDate: String
    let voteAverage: Double
    let voteCount: Int
    let originCountry: [String]
<<<<<<< HEAD
    
=======

>>>>>>> d8b7bb0ca2f61b7d4babd75d0617856bd28b1d3f
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case id, name
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview
        case posterPath = "poster_path"
<<<<<<< HEAD
=======
        case mediaType = "media_type"
>>>>>>> d8b7bb0ca2f61b7d4babd75d0617856bd28b1d3f
        case genreIDS = "genre_ids"
        case popularity
        case firstAirDate = "first_air_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case originCountry = "origin_country"
    }
}
