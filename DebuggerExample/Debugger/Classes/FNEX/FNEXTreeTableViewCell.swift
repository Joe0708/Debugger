import UIKit

class FNEXTreeTableViewCell: UITableViewCell {
    
    private lazy var viewNameLabel: UILabel = {
        let viewNameLabel = UILabel(frame: CGRect(x: 15, y: 10, width: kScreenWidth, height: 15))
        viewNameLabel.font = UIFont.fnexFont(size: 15)
        viewNameLabel.textColor = .black
        return viewNameLabel
    }()
    
    private lazy var frameLabel: UILabel = {
        let frameLabel = UILabel(frame: CGRect(x: 20, y: 30, width: kScreenWidth, height: 12))
        frameLabel.font = UIFont.fnexFont(size: 12)
        frameLabel.textColor = .black
        return frameLabel
    }()
    
    var fnViewName = ""
    var fnViewInfo = ""
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(viewNameLabel)
        contentView.addSubview(frameLabel)
        
        let detailBtn = UIButton(frame: CGRect.init(x: kScreenWidth - 44, y: 0, width: 44, height: 44))
        detailBtn.setImage(UIImage(named: "info"), for: .normal)
        detailBtn.addTarget(self, action: #selector(detailBtnClicked), for: .touchUpInside)
        contentView.addSubview(detailBtn)
    }
    
    func loadInfo(byView: UIView, leftMargin: Double) {
        viewNameLabel.text = String(format: "-\(type(of: byView)):%p", byView)
        var tmpFrame = viewNameLabel.frame
        tmpFrame.origin.x = CGFloat(leftMargin)
        tmpFrame.size.width = kScreenWidth - tmpFrame.origin.x - 44
        viewNameLabel.frame = tmpFrame
        
        frameLabel.text = "\(byView.frame)"
        tmpFrame = frameLabel.frame
        tmpFrame.origin.x = CGFloat(leftMargin + 5)
        tmpFrame.size.width = kScreenWidth - tmpFrame.origin.x - 5
        frameLabel.frame = tmpFrame
        
        fnViewName = "\(type(of: byView))"
        fnViewInfo = byView.description
    }
    
    func detailBtnClicked() {
        
        var fnexWindow = UIApplication.shared.keyWindow
        let windowArray = UIApplication.shared.windows
        for window in windowArray {
            if window.isKind(of: FNEXWindow.self) {
                fnexWindow = window
                break
            }
        }
        
        let vc = FNEXUtil.currentTopViewController(rootViewController: (fnexWindow?.rootViewController)!)
        let alert = UIAlertController(title: fnViewName, message: fnViewInfo, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Well", style: UIAlertActionStyle.default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
