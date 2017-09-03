import Foundation

final class NFXHTTPModelManager {
    
    static let sharedInstance = NFXHTTPModelManager()
    
    fileprivate var models = [NFXHTTPModel]()
    
    func add(_ obj: NFXHTTPModel) {
        models.insert(obj, at: 0)
    }
    
    func clear() {
        models.removeAll()
    }
    
    var getModels: [NFXHTTPModel] {
        var predicates = [NSPredicate]()
        
        let filterValues = Netfox.shared.getCachedFilters()
        let filterNames = HTTPModelShortType.allValues
        
        var index = 0
        for filterValue in filterValues {
            if filterValue {
                let filterName = filterNames[index].rawValue
                let predicate = NSPredicate(format: "shortType == '\(filterName)'")
                predicates.append(predicate)

            }
            index += 1
        }

        let searchPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
        
        let array = (models as NSArray).filtered(using: searchPredicate)
        
        return array as! [NFXHTTPModel]
    }
}
