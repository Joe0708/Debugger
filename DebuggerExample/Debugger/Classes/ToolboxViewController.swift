import Foundation
import UIKit
import SandboxBrowser

enum ToolboxItem : String {
    case network = "📡 Network"
    case fileBrowser = "📂 Sandbox Browser"
 
    static var all = [.network, fileBrowser]
}

class ToolboxViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(close))
    }
    
    func close() {
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func sandboxBrowserClick() {
        
        let fileListVC = FileListViewController(initialPath: URL(fileURLWithPath: NSHomeDirectory()))
        fileListVC.didSelectFile = { [weak self] file, _ in
            switch file.type {
            case .log:
                let textBrowserVC = TextBrowserViewController()
                textBrowserVC.bodyText = try? String(contentsOfFile: file.path, encoding: .utf8)
                self?.navigationController?.pushViewController(textBrowserVC, animated: true)
            default:
                break
            }
        }
        navigationController?.pushViewController(fileListVC, animated: true)
    }
}

extension ToolboxViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ToolboxItem.all.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         var cell = tableView.dequeueReusableCell(withIdentifier: "ToolboxItemCell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "ToolboxItemCell")
        }
        cell?.textLabel?.text = ToolboxItem.all[indexPath.row].rawValue
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = ToolboxItem.all[indexPath.row]
        switch item {
        case .network:
            navigationController?.pushViewController(Netfox.shared.controller, animated: true)
        case .fileBrowser:
            sandboxBrowserClick()
        default:
            break
        }
        
    }
}
