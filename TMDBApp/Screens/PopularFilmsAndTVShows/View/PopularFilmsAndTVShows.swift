import UIKit

final class PopularFilmsAndTVShows: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    private var viewModel = ViewModel()
    private var refreshControl = UIRefreshControl()
    
    var searchController = UISearchController(searchResultsController: nil)
    var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        searchController.isActive && !searchBarIsEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        loadDataForSelectedSegment()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.searchResultsUpdater = self
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
    }
    
    private func configureTableView() {
        tableView.register(.init(nibName: FilmsAndTVTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: FilmsAndTVTableViewCell.identifier)
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
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
                self.tableView.reloadData()
                self.handleRefreshControlEnd(success: success)
            }
        } else {
            viewModel.loadTrendingSeries { success in
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

extension PopularFilmsAndTVShows: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            viewModel.moviesDataResult.count
        } else {
            viewModel.seriesDataResult.count
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

extension PopularFilmsAndTVShows: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        if searchText.isEmpty {
            tableView.reloadData()
        } else {
            if segmentedControl.selectedSegmentIndex == 0 {
                viewModel.moviesDataResult = viewModel.moviesDataResult.filter { (movieData: MoviesDataResult) -> Bool in
                    return movieData.title.lowercased().contains(searchText.lowercased())
                }
                tableView.reloadData()
            } else {
                viewModel.seriesDataResult = viewModel.seriesDataResult.filter { (seriesData: SeriesDataResult) -> Bool in
                    return seriesData.name.lowercased().contains(searchText.lowercased())
                }
                tableView.reloadData()
            }
        }
    }
}
