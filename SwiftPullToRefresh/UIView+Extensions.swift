import UIKit

private var offsetTokenKey: UInt8 = 0
private var stateTokenKey: UInt8 = 0
private var sizeTokenKey: UInt8 = 0

extension UIView {
    var offsetToken: NSKeyValueObservation? {
        get {
            return objc_getAssociatedObject(self, &offsetTokenKey) as? NSKeyValueObservation
        }
        set {
            objc_setAssociatedObject(self, &offsetTokenKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    var stateToken: NSKeyValueObservation? {
        get {
            return objc_getAssociatedObject(self, &stateTokenKey) as? NSKeyValueObservation
        }
        set {
            objc_setAssociatedObject(self, &stateTokenKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    var sizeToken: NSKeyValueObservation? {
        get {
            return objc_getAssociatedObject(self, &sizeTokenKey) as? NSKeyValueObservation
        }
        set {
            objc_setAssociatedObject(self, &sizeTokenKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
