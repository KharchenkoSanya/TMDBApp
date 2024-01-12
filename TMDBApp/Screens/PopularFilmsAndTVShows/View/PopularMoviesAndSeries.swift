import UIKit

final class PopularMoviesAndSeries: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var viewModel = ViewModel()
    private var refreshControl = UIRefreshControl()
    private var originalMoviesDataResult: [MoviesDataResult] = []
    private var originalSeriesDataResult: [SeriesDataResult] = []
    
    private var searchBarIsEmpty: Bool {
        guard let text = searchBar.text else { return false }
        return text.isEmpty
    }
    
    private var isFiltering: Bool {
        !searchBarIsEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureSearchBar()
        loadDataForSelectedSegment()
    }
    
    private func configureTableView() {
        self.refreshControl.backgroundColor = .clear
        tableView.register(.init(nibName: FilmsAndTVTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: FilmsAndTVTableViewCell.identifier)
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func configureSearchBar() {
        searchBar.delegate = self
    }
    
    @objc private func refreshData() {
        loadDataForSelectedSegment()
    }
    
    @IBAction private func segmentedControlValueChanged(_ sender: Any) {
        loadDataForSelectedSegment()
    }
    
    private func loadDataForSelectedSegment() {
        if segmentedControl.selectedSegmentIndex == 0 {
            viewModel.loadTrendingMovies { success in
                self.originalMoviesDataResult = self.viewModel.moviesDataResult
                self.tableView.reloadData()
                self.handleRefreshControlEnd(success: success)
            }
        } else {
            viewModel.loadTrendingSeries { success in
                self.originalSeriesDataResult = self.viewModel.seriesDataResult
                self.tableView.reloadData()
                self.handleRefreshControlEnd(success: success)
            }
        }
    }
    
    private func handleRefreshControlEnd(success: Bool) {
        if success {
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        } else {
            print("Error")
        }
    }
}

extension PopularMoviesAndSeries: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            return viewModel.moviesDataResult.count
        } else {
            return viewModel.seriesDataResult.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FilmsAndTVTableViewCell.identifier, for: indexPath) as! FilmsAndTVTableViewCell
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            let moviesDataResult = viewModel.moviesDataResult[indexPath.row]
            cell.setupMovies(movies: moviesDataResult)
        case 1:
            let seriesDataResult = viewModel.seriesDataResult[indexPath.row]
            cell.setupSeries(series: seriesDataResult)
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        let cellHeight = screenHeight * 0.4
        let cellWidth = screenWidth * 0.7
        return max(cellHeight, cellWidth)
    }
}

extension PopularMoviesAndSeries: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        if searchText.isEmpty {
            if segmentedControl.selectedSegmentIndex == 0 {
                viewModel.moviesDataResult = originalMoviesDataResult
            } else {
                viewModel.seriesDataResult = originalSeriesDataResult
            }
        } else {
            if segmentedControl.selectedSegmentIndex == 0 {
                viewModel.moviesDataResult = originalMoviesDataResult.filter { (movieData: MoviesDataResult) -> Bool in
                    return movieData.title.lowercased().contains(searchText.lowercased())
                }
            } else {
                viewModel.seriesDataResult = originalSeriesDataResult.filter { (seriesData: SeriesDataResult) -> Bool in
                    return seriesData.name.lowercased().contains(searchText.lowercased())
                }
            }
        }
        tableView.reloadData()
    }
}
