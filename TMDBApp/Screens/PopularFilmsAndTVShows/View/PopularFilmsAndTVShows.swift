import UIKit

final class PopularFilmsAndTVShows: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    
    private var viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        viewModel.loadTrendingMovies(completion: {
            self.tableView.reloadData()
        })
    }
    
    private func configureTableView() {
        tableView.register(.init(nibName: FilmsAndTVTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: FilmsAndTVTableViewCell.identifier)
    }
}

extension PopularFilmsAndTVShows: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.dataResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataResult = viewModel.dataResult[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: FilmsAndTVTableViewCell.identifier, for: indexPath) as! FilmsAndTVTableViewCell
        cell.setup(movieAndTV: dataResult)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        
        let cellHeight = screenHeight * 0.4
        let cellWidth = screenWidth * 0.7
        return min(cellHeight, cellWidth)
    }
}
