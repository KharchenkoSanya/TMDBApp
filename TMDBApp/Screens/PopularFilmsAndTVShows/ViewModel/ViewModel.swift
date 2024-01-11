import Alamofire

final class ViewModel {
    var moviesDataResult: [MoviesDataResult] = []
    var seriesDataResult: [SeriesDataResult] = []
    
    func loadTrendingMovies(completion: @escaping (Bool) -> Void) {
        let url = "https://api.themoviedb.org/3/trending/movie/week?api_key=ea7d1109f1b518a95e8f8111b9579fa0"
        fetchData(url: url, responseType: AllDataTrendingMovies.self) { result in
            if let moviesData = result {
                self.moviesDataResult = moviesData.results
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func loadTrendingSeries(completion: @escaping (Bool) -> Void) {
        let url = "https://api.themoviedb.org/3/trending/tv/week?api_key=ea7d1109f1b518a95e8f8111b9579fa0"
        fetchData(url: url, responseType: AllDataTrendingSeries.self) { result in
            if let seriesData = result {
                self.seriesDataResult = seriesData.results
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    private func fetchData<T: Decodable>(url: String, responseType: T.Type, completion: @escaping (T?) -> Void) {
        AF.request(url).responseDecodable(of: T.self) { response in
            if let value = response.value {
                completion(value)
            } else {
                completion(nil)
            }
        }
    }
}
