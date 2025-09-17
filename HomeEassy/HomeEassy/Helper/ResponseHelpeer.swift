


import Foundation
import ObjectMapper
public let kKeyData = "KVSData"

class ResponseHelpeer : NSObject {
  //  static var sharedInstance = ResponseHelpeer()
  //  private init() {
  //  }
  var error: NSError?
  
  
  func isNotNull(_ object:AnyObject?) -> Bool {
    guard let object = object else {
      return false
    }
    return (isNotNSNull(object) && isNotStringNull(object))
  }
  
  func isNotNSNull(_ object:AnyObject) -> Bool {
    return object.classForCoder != NSNull.classForCoder()
  }
  
  func isNotStringNull(_ object:AnyObject) -> Bool {
    if let object = object as? String , object.uppercased() == "NULL" {
      return false
    }
    return true
  }
  
  func mappingKeyForProperty(_ propertyName: String?) -> String? {
    return propertyName?.removingPercentEncoding
  }
  
  func mappedValueForKey(_ key: String) -> AnyObject? {
    return self.value(forKey: key) as AnyObject?
  }
  
  open func dateFormatterTypeYYMMDDHHMMSS() -> DateFormatter? {
    let dateFormatter = DateFormatters.sharedManager.formatterForStrings(dateFormat: "yyyy-MM-dd HH:mm:ss")
    return dateFormatter
  }
  
  open func stringValue(map: Map, key : String)-> String? {
    var returnValue : String?
    returnValue <- map[key]
    if let currentValue = map.currentValue {
      returnValue = String(describing: currentValue)
    }
    return returnValue
  }
  
  open func getlink(_ map : Map) -> String? {
    var linksDict : [[AnyHashable:Any]]?
    var link : String?
    linksDict <- map["links"]
    if let selfLinkDict = linksDict?.filter({ (dict) -> Bool in
      return ((dict["rel"] as? String) == "self")
    }).first {
      link = selfLinkDict["href"] as? String
    }
    return link
  }}
