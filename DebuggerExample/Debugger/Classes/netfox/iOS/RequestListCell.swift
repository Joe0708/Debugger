import Foundation
import UIKit

class RequestListCell: UITableViewCell {
    
    let padding: CGFloat = 5
    var URLLabel: UILabel!
    var titleLabel: UILabel!
    var statusView: UIView!
    var detailLabel: UILabel!
    var circleView: UIView!

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        self.statusView = UIView(frame: CGRect.zero)
        contentView.addSubview(self.statusView)
        
        titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        contentView.addSubview(titleLabel)
        
        URLLabel = UILabel(frame: CGRect.zero)
        URLLabel.textColor = UIColor(white: 0.4, alpha: 1)
        URLLabel.font = UIFont.systemFont(ofSize: 12)
        contentView.addSubview(self.URLLabel)
        
        detailLabel = UILabel(frame: CGRect.zero)
        detailLabel.textColor = UIColor(white: 0.65, alpha: 1)
        detailLabel.font = UIFont.systemFont(ofSize: 10)
        contentView.addSubview(detailLabel)
        
        self.circleView = UIView(frame: CGRect.zero)
        self.circleView.backgroundColor = UIColor.NFXGray44Color()
        self.circleView.layer.cornerRadius = 4
        self.circleView.alpha = 0.2
        contentView.addSubview(self.circleView)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        statusView.frame = CGRect(x: 0, y: 0, width: 50, height: frame.height - 1)
        
        titleLabel.frame = CGRect(x: statusView.frame.maxX + padding, y: 4, width: frame.width - statusView.frame.maxX - 30, height: 13)
        
        URLLabel.frame = CGRect(x: titleLabel.frame.origin.x, y: titleLabel.frame.maxY, width: titleLabel.frame.width, height: 20)
        URLLabel.autoresizingMask = .flexibleWidth
        
        detailLabel.frame = CGRect(x: statusView.frame.maxX + padding, y: URLLabel.frame.maxY, width: titleLabel.frame.width, height: 13)

        circleView.frame = CGRect(x: URLLabel.frame.maxX + 5, y: 0, width: 8, height: 8)
        circleView.center.y = contentView.center.y
    }
    
    func configForObject(_ obj: NFXHTTPModel?) {
        guard let `obj` = obj else { return }
        
        setStatus(obj.responseStatus ?? 999)
        
        let responseDate = obj.responseDate as Date? ?? Date()
        circleView.isHidden = !responseDate.isGreaterThanDate(Netfox.shared.getLastVisitDate())
        
        
        if let requestURL = obj.requestURL,
            var path = requestURL.host {
            var pathComponents = requestURL.pathComponents
            if pathComponents.count > 0 {
                pathComponents.removeLast()
            }
            
            for pathCom in pathComponents {
                path = (path as NSString).appendingPathComponent(pathCom)
            }
            URLLabel.text = path
            
            var name = requestURL.lastPathComponent
            if name.isEmpty {
                name = "/"
            }
            if let query = requestURL.query {
                name = name + "?\(query)"
            }
            titleLabel.text = name
        }

        var detailComponents: [String] = []
        if let requestTime = obj.requestTime {
            detailComponents.append(requestTime)
        }
        detailComponents.append(obj.requestMethod)
        
        if let statusCode = obj.responseStatus {
            detailComponents.append(statusCode.description)
        }
        
        if obj.responseBodyLength > 0 {
            let responseSize = ByteCountFormatter.string(fromByteCount: Int64(obj.responseBodyLength), countStyle: .binary)
            detailComponents.append(responseSize)
        }
        if let requestDuration = obj.timeInterval {
            let requestDurationString = String(format: "%.2fms", requestDuration)
            detailComponents.append(requestDurationString)
        }
        detailLabel.text = detailComponents.joined(separator: " ・ ")
    }
    
    func setStatus(_ status: Int) {
        circleView.backgroundColor = status < 400 ? .green : status == 999 ? .gray : .red
        if status == 999 {
            self.statusView.backgroundColor = UIColor.NFXGray44Color() //gray
        } else if status < 400 {
            self.statusView.backgroundColor = .green //green
        } else {
            self.statusView.backgroundColor = .red //red
        }
    }
}
