import Foundation
import Alamofire
import UIKit

 final class ViewModel {
    var dataResult: [DataResult] = []

    func loadTrendingMovies(completion: @escaping(() -> ())) {
        let url = "https://api.themoviedb.org/3/trending/movie/week?api_key=ea7d1109f1b518a95e8f8111b9579fa0"
        AF.request(url).responseDecodable(of: AllDataTrendingForWeek.self) { response in
            self.dataResult = response.value?.results ?? []
            completion()
        }
    }
}
