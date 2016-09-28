//
//  UIViewExtension.swift
//  Magic
//
//  Created by Broccoli on 16/9/12.
//  Copyright © 2016年 broccoliii. All rights reserved.
//

import Foundation

public extension UIView {
    public class func fromNib<T : UIView>(nibName: String? = nil) -> T? {
        let name: String = {
            guard let _ = nibName else {
                return nibName!
            }
            return String(describing: T.self)
        }()
        
        let nibViews = Bundle.main.loadNibNamed(name, owner: nil, options: nil)
        for subview in nibViews! {
            if let _ = subview as? T {
                return subview as? T
            }
        }
        return nil
    }
}

// property
public extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        
        set {
            layer.masksToBounds = true
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            guard let borderColor = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: borderColor)
        }
        
        set {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        
        set {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var origin: CGPoint {
        get {
            return frame.origin
        }
        
        set {
            var frame = self.frame
            frame.origin = origin
            self.frame = frame
        }
    }
    
    @IBInspectable var size: CGSize {
        get {
            return self.frame.size;
        }
        
        set {
            var frame = self.frame
            frame.size = size
            self.frame = frame
        }
    }
    
    var snapshot: UIImage? {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: 0)
        layer.render(in: context!)
        let viewImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return viewImage
    }
    
    var top: CGFloat {
        get {
            return frame.origin.y
        }
        
        set {
            var frame = self.frame
            frame.origin.y = top
            self.frame = frame
        }
    }
    
    var bottom: CGFloat {
        get {
            return frame.origin.y + frame.size.height
        }
        
        set {
            var frame = self.frame
            frame.origin.y = bottom - self.frame.size.height
            self.frame = frame
        }
    }
    
    var right: CGFloat {
        get {
            return frame.origin.x + frame.size.width
        }
        
        set {
            var frame = self.frame
            frame.origin.x = right - self.frame.size.width
            self.frame = frame
        }
    }
    
    var left: CGFloat {
        get {
            return frame.origin.x
        }
        
        set {
            var frame = self.frame
            frame.origin.x = left
            self.frame = frame
        }
    }
    
    var width: CGFloat {
        get {
            return frame.size.width
        }
        
        set {
            var frame = self.frame;
            frame.size.width = width;
            self.frame = frame
        }
    }
    
    var height: CGFloat {
        get {
            return frame.size.height
        }
        
        set {
            var frame = self.frame;
            frame.size.height = height;
            self.frame = frame
        }
    }
}

// function
public extension UIView {
    func contains(subView: UIView) -> Bool {
        for view in subviews {
            if view == subView {
                return true
            }
        }
        return false
    }
    
    func addSubviews(subviews: UIView...) {
        subviews.forEach {
            addSubview($0)
        }
    }
    
    func removeSubViews() {
        subviews.forEach {
            $0.removeFromSuperview()
        }
    }
    
    func removeView(with tag: NSInteger) {
        for subView in subviews {
            if subView.tag == tag {
                subView.removeFromSuperview()
            }
        }
    }
}


public extension UIView {
    public enum UIViewShakeDirection : Int {
        case horizontal = 0
        case vertical = 1
    }
    
    func shake(_ times: Int = 10,
               currentTimes current: Int = 0,
               withDelta delta: CGFloat = 5,
               speed interval: TimeInterval = 0.03,
               shakeDirection: UIViewShakeDirection = .horizontal,
               completion handler: (() -> Void)?) {
        
        UIView.animate(withDuration: interval, animations: {
            _ in
            self.transform = (shakeDirection == UIViewShakeDirection.horizontal) ?
                CGAffineTransform(translationX: delta, y: 0) :
                CGAffineTransform(translationX: 0, y: delta)
            }, completion: {
                (finished: Bool) in
                if current >= times {
                    UIView.animate(withDuration: interval, animations: {
                        _ in
                        self.transform = CGAffineTransform.identity
                        }, completion: {
                            (finished: Bool) in
                            if let handler = handler {
                                handler()
                            }
                    })
                    return
                }
                self.shake(times - 1,
                           currentTimes: current + 1,
                           withDelta: delta,
                           speed: interval,
                           shakeDirection: shakeDirection,
                           completion: handler)
        })
    }
}
