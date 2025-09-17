
import Darwin
import Foundation

public enum CLGLog {
    public static func debug(_  items: Any...) {
#if DEBUG
        print(items)
#else
        // debug only code
#endif
    }
}
