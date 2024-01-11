import UIKit
import SDWebImage

final class FilmsAndTVTableViewCell: UITableViewCell {
    @IBOutlet private weak var movieImageView: UIImageView!
    @IBOutlet private weak var titleMovieLabel: UILabel!
    
    func setupMovies(movies: MoviesDataResult) {
        titleMovieLabel.text = movies.title
        let urlString = "https://image.tmdb.org/t/p/w1280"
        let imageUrl = URL(string: urlString + (movies.posterPath ))
        movieImageView.sd_setImage(with: imageUrl, completed: nil)
    }
    
    func setupSeries(series: SeriesDataResult) {
        titleMovieLabel.text = series.name
        let urlString = "https://image.tmdb.org/t/p/w1280"
        let imageUrl = URL(string: urlString + (series.posterPath ))
        movieImageView.sd_setImage(with: imageUrl, completed: nil)
    }
}
