import UIKit

class SettingsViewController: NetfoxViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView = UITableView()
    var tableData = [HTTPModelShortType]()
    var filters = [Bool]()
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Settings"
        
        self.tableData = HTTPModelShortType.allValues
        self.filters =  Netfox.shared.getCachedFilters()
        
        self.edgesForExtendedLayout = UIRectEdge()
        self.extendedLayoutIncludesOpaqueBars = false
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.NFXInfo(), style: .plain, target: self, action: #selector(infoButtonPressed))
        
        self.tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 60)
        self.tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.tableView.translatesAutoresizingMaskIntoConstraints = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.alwaysBounceVertical = false
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.tableFooterView?.isHidden = true
        tableView.separatorInset = .zero
        self.view.addSubview(self.tableView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        Netfox.shared.cacheFilters(self.filters)
    }
    
    func infoButtonPressed() {
        navigationController?.pushViewController(DeviceInfoViewController(), animated: true)
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 1 ? tableData.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.tintColor = .orange
        
        switch (indexPath as NSIndexPath).section
        {
        case 0:
            cell.textLabel?.text = "Logging"
            let nfxEnabledSwitch: UISwitch
            nfxEnabledSwitch = UISwitch()
            nfxEnabledSwitch.setOn(Netfox.shared.isEnabled(), animated: false)
            nfxEnabledSwitch.addTarget(self, action: #selector(nfxEnabledSwitchValueChanged(_:)), for: .valueChanged)
            cell.accessoryView = nfxEnabledSwitch
            return cell
            
        case 1:
            let shortType = tableData[(indexPath as NSIndexPath).row]
            cell.textLabel?.text = shortType.rawValue
            configureCell(cell, indexPath: indexPath)
            return cell
            
        case 2:
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.text = "Share Session Logs"
            cell.textLabel?.textColor = .green
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
            return cell
            
        case 3:
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.text = "Clear data"
            cell.textLabel?.textColor = .red
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
            
            return cell
            
        default: return UITableViewCell()
            
        }
        
    }
    
    func reloadTableData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.setNeedsDisplay()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(netHex: 0xf2f2f2)
        
        switch section {
        case 1:
            
            var filtersInfoLabel: UILabel
            filtersInfoLabel = UILabel(frame: headerView.bounds)
            filtersInfoLabel.backgroundColor = UIColor.clear
            filtersInfoLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            filtersInfoLabel.font = UIFont.systemFont(ofSize: 13)
            filtersInfoLabel.textColor = UIColor.NFXGray44Color()
            filtersInfoLabel.textAlignment = .center
            filtersInfoLabel.text = "\nSelect the types of responses that you want to see"
            filtersInfoLabel.numberOfLines = 2
            headerView.addSubview(filtersInfoLabel)
        default: break
        }
        
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath as NSIndexPath).section
        {
        case 1:
            let cell = tableView.cellForRow(at: indexPath)
            self.filters[(indexPath as NSIndexPath).row] = !self.filters[(indexPath as NSIndexPath).row]
            configureCell(cell, indexPath: indexPath)
        case 2:
            shareSessionLogsPressed()
        case 3:
            clearDataButtonPressedOnTableIndex(indexPath)
        default: break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 40 : 20
    }
    
    func configureCell(_ cell: UITableViewCell?, indexPath: IndexPath) {
        if let `cell` = cell {
            cell.accessoryType = self.filters[indexPath.row] ? .checkmark : .none
        }
    }
    
    func nfxEnabledSwitchValueChanged(_ sender: UISwitch) {
        sender.isOn ? Netfox.shared.enable() : Netfox.shared.disable()
    }
    
    func clearDataButtonPressedOnTableIndex(_ index: IndexPath) {
        let actionSheetController: UIAlertController = UIAlertController(title: "Clear data?", message: "", preferredStyle: .alert)
        actionSheetController.popoverPresentationController?.sourceView = tableView
        actionSheetController.popoverPresentationController?.sourceRect = tableView.rectForRow(at: index)
        
        actionSheetController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheetController.addAction(UIAlertAction(title: "Yes", style: .destructive) { _ in
            Netfox.shared.clearOldData()
        })
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func shareSessionLogsPressed() {
        
        let controller = UIActivityViewController(
            activityItems: [NSURL(fileURLWithPath: sessionLogPath)],
            applicationActivities: nil)
        
        controller.excludedActivityTypes = [
            .postToTwitter, .postToFacebook, .postToTencentWeibo, .postToWeibo,
            .postToFlickr, .postToVimeo, .message, .mail, .addToReadingList,
            .print, .copyToPasteboard, .assignToContact, .saveToCameraRoll,
        ]
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            controller.popoverPresentationController?.sourceView = view
            controller.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.size.width * 0.5, y: UIScreen.main.bounds.size.height * 0.5, width: 10, height: 10)
        }
        self.present(controller, animated: true, completion: nil)
    }
}
