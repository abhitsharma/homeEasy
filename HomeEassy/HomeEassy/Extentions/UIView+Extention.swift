//
//  UIView+Extention.swift
//  CLG
//
//  Created by Aravind Kumar on 04/09/21.
//

import Foundation
import UIKit

public extension UIView {
    func applyGradient(with colors: [UIColor],
                       locations: [NSNumber] = [0, 1],
                       startPoint: CGPoint = CGPoint(x: 1.0, y: 0.0),
                       endPoint: CGPoint = CGPoint(x: 0.0, y: 0.0))-> CAGradientLayer? {

        let gradientlayer = CAGradientLayer()
        gradientlayer.frame = bounds
        gradientlayer.colors = colors.map { $0.cgColor }
        gradientlayer.locations = locations
        gradientlayer.startPoint = startPoint
        gradientlayer.endPoint = endPoint
        layer.insertSublayer(gradientlayer, at: 0)
        return gradientlayer
    }
    func setGradientBackground(with colors: [UIColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.bounds
                
        self.layer.insertSublayer(gradientLayer, at:0)
    }
      
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
          let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
          let mask = CAShapeLayer()
          mask.path = path.cgPath
          self.layer.mask = mask
      }
}

protocol UIViewLoading {}
extension UIView : UIViewLoading {}
extension UIViewLoading where Self : UIView {
    
    // note that this method returns an instance of type `Self`, rather than UIView
    static func loadFromNib() -> Self? {
        let nibName = "\(self)".split{$0 == "."}.map(String.init).last!
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? Self
    }

    static func loadFromNibName(_ nibName : String) -> Self? {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? Self
    }
    func setupAutolayout(view: UIView?) {
        guard let v = view else { return }
        v.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(v)
    }
}

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set {
            if  (newValue?.isKind(of: UIColor.self))!{
                self.layer.borderColor = newValue?.cgColor
            }
        }
    }
    
    @IBInspectable var rightBorder: CGFloat {
        get {
            return 0.0
        }
        set {
            let line = UIView(frame: CGRect(x: self.bounds.width, y: 0.0, width: newValue, height: self.bounds.height))
            line.translatesAutoresizingMaskIntoConstraints = false
            line.backgroundColor = self.borderColor
            self.addSubview(line)
            
            let views = ["line": line]
            let metrics = ["lineWidth": newValue]
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "[line(==lineWidth)]|", options: [], metrics: metrics, views: views))
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[line]|", options: [], metrics: nil, views: views))
        }
    }
    @IBInspectable var BorderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    @IBInspectable var topBorder: CGFloat {
        get {
            return 0.0
        }
        set {
            let line = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.bounds.width, height: newValue))
            line.translatesAutoresizingMaskIntoConstraints = false
            if let color = self.borderColor{
            line.backgroundColor = color
            } else {
                line.backgroundColor = UIColor(named: "CellSeprator1")
            }
            self.addSubview(line)
            
            let views = ["line": line]
            let metrics = ["lineWidth": newValue]
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[line]|", options: [], metrics: nil, views: views))
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[line(==lineWidth)]", options: [], metrics: metrics, views: views))
        }
    }
    @IBInspectable var leftBorder: CGFloat {
        get {
            return 0.0
        }
        set {
            let line = UIView(frame: CGRect(x: 0.0, y: 0.0, width: newValue, height: self.bounds.height))
            line.translatesAutoresizingMaskIntoConstraints = false
            line.backgroundColor = self.borderColor
            self.addSubview(line)
            
            let views = ["line": line]
            let metrics = ["lineWidth": newValue]
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[line(==lineWidth)]", options: [], metrics: metrics, views: views))
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[line]|", options: [], metrics: nil, views: views))
        }
    }
    @IBInspectable var bottomBorder: CGFloat {
        get {
            return 0.0
        }
        set {
            let line = UIView(frame: CGRect(x: 0.0, y: self.bounds.height, width: self.bounds.width, height: newValue))
            line.translatesAutoresizingMaskIntoConstraints = false
            if let color = self.borderColor {
            line.backgroundColor = color
            } else {
                line.backgroundColor = UIColor(named: "CellSeprator1")
            }
            self.addSubview(line)
            
            let views = ["line": line]
            let metrics = ["lineWidth": newValue]
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[line]|", options: [], metrics: nil, views: views))
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[line(==lineWidth)]|", options: [], metrics: metrics, views: views))
        }
    }
    @IBInspectable var shadowColor: UIColor {
        get {
            return UIColor(cgColor: self.layer.shadowColor!)
        }
        set {
            layer.shadowColor = newValue.cgColor
        }
    }
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
        
    }
    
    @IBInspectable var masksToBounds: Bool  {
        get {
            return layer.masksToBounds
        }
        set {
            layer.masksToBounds = newValue
        }
        
    }
    
    @IBInspectable var shadowOffset: CGSize  {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
        
    }
    @IBInspectable var shadowRadius: CGFloat  {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
        
    }
    //shadowRadius
}
extension UIStackView {
  
  func removeAllArrangedSubviews() {
    
    let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
      self.removeArrangedSubview(subview)
      return allSubviews + [subview]
    }
    // Deactivate all constraints
    NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
    
    // Remove the views from self
    removedSubviews.forEach({ $0.removeFromSuperview() })
  }
}

extension UIView {
    func takeScreenshot() -> UIImage {
        // Begin context
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        // Draw view in that context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if (image != nil) {
            return image!
        }
        return UIImage()
    }
}

extension UIButton {
    func blinkA() {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.isRemovedOnCompletion = false
        animation.fromValue           = 1
        animation.toValue             = 0.5
        animation.duration            = 2.0
        animation.autoreverses        = true
        animation.repeatCount         = Float.infinity
        animation.beginTime           = CACurrentMediaTime() + 0.5
        self.layer.add(animation, forKey: nil)
    }
    func removeblinkA() {
        self.layer.removeAllAnimations()
    }
}
