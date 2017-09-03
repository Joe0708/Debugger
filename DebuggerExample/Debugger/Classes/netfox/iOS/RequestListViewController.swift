import Foundation
import UIKit

class RequestListViewController: NetfoxViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchControllerDelegate {
    
    // MARK: UI
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.frame = self.view.frame
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.translatesAutoresizingMaskIntoConstraints = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 55
        tableView.separatorInset = .zero
        self.view.addSubview(tableView)
        
        tableView.register(RequestListCell.self, forCellReuseIdentifier: RequestListCell.description())
        return tableView
    }()

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.autoresizingMask = [.flexibleWidth]
        searchController.searchBar.sizeToFit()
        searchController.searchBar.backgroundColor = UIColor.clear
        searchController.searchBar.searchBarStyle = .minimal
        searchController.view.backgroundColor = UIColor.clear
        return searchController
    }()
    
    private lazy var searchView: UIView = {
        let searchView = UIView()
        searchView.frame.size.height = self.view.frame.width
        searchView.autoresizingMask = [.flexibleWidth]
        searchView.autoresizesSubviews = true
        searchView.backgroundColor = .clear
        searchView.frame = self.searchController.searchBar.frame
        searchView.addSubview(self.searchController.searchBar)
        return searchView
    }()
    
    var tableData = [NFXHTTPModel]()
    var filteredTableData = [NFXHTTPModel]()
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = UIRectEdge()
        extendedLayoutIncludesOpaqueBars = false
        automaticallyAdjustsScrollViewInsets = false
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(close)),
            UIBarButtonItem(image: UIImage.NFXSettings(), style: .plain, target: self, action: #selector(settingsButtonPressed))
        ]
        
        tableView.tableHeaderView = searchView
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(RequestListViewController.reloadTableViewData),
            name: NSNotification.Name(rawValue: "NFXReloadData"),
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(RequestListViewController.deactivateSearchController),
            name: NSNotification.Name(rawValue: "NFXDeactivateSearch"),
            object: nil)        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadTableViewData()
    }
    
    func settingsButtonPressed() {
        navigationController?.pushViewController(SettingsViewController(), animated: true)
    }
    
    func close() {
        Netfox.shared.hide()
    }
    
    // MARK: UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        self.updateSearchResultsForSearchControllerWithString(searchController.searchBar.text!)
        reloadTableViewData()
    }
    
    func deactivateSearchController() {
        self.searchController.isActive = false
    }
    
    func updateSearchResultsForSearchControllerWithString(_ searchString: String) {
        let predicateURL = NSPredicate(format: "requestURLString contains[cd] '\(searchString)'")
        let predicateMethod = NSPredicate(format: "requestMethod contains[cd] '\(searchString)'")
        let predicateType = NSPredicate(format: "responseType contains[cd] '\(searchString)'")
        let predicates = [predicateURL, predicateMethod, predicateType]
        let searchPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
        
        let array = (NFXHTTPModelManager.sharedInstance.getModels as NSArray).filtered(using: searchPredicate)
        self.filteredTableData = array as! [NFXHTTPModel]
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = searchController.isActive ? filteredTableData.count : NFXHTTPModelManager.sharedInstance.getModels.count
        title = "Network (\(count) Requests)"
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: RequestListCell.description(), for: indexPath) as! RequestListCell
        
        let obj = searchController.isActive ?
            filteredTableData[indexPath.row] :
            NFXHTTPModelManager.sharedInstance.getModels[indexPath.row]
        
        cell.configForObject(obj)
        
        cell.backgroundColor = indexPath.row % 2 == 0 ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : #colorLiteral(red: 0.9486700892, green: 0.9493889213, blue: 0.9487814307, alpha: 1)
        
        return cell
    }
    
    func reloadTableViewData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.setNeedsDisplay()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsController = RequestDetailViewController()
        let model = searchController.isActive ? filteredTableData[indexPath.row] : NFXHTTPModelManager.sharedInstance.getModels[indexPath.row]
        detailsController.selectedModel = model
        navigationController?.pushViewController(detailsController, animated: true)
    }
}
