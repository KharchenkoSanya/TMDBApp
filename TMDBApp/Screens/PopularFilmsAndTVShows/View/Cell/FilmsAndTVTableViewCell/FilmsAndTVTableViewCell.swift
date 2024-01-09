import UIKit
import SDWebImage

final class FilmsAndTVTableViewCell: UITableViewCell {
    @IBOutlet private weak var movieImageView: UIImageView!
    @IBOutlet private weak var titleMovieLabel: UILabel!
    
    func setup(movieAndTV: DataResult) {
        titleMovieLabel.text = movieAndTV.title
        
        let urlString = "https://image.tmdb.org/t/p/w1280"
        let imageUrl = URL(string: urlString + movieAndTV.posterPath)
        movieImageView.sd_setImage(with: imageUrl, completed: nil)
    }
}
