//
//  WaterConsumptionView.swift
//  StayHydrated
//

import UIKit

class WaterConsumptionView: UIView {
    
    /// Value indicating percent complete from 0 to 1. Setting this updates the fill
    /// of the view
    var percentComplete: CGFloat = 0.0 {
        didSet {
            if percentComplete > 1.0 {
                percentComplete = 1.0
            } else if percentComplete < 0.0 {
                percentComplete = 0.0
            }
            updateFillView()
            setNeedsLayout()
        }
    }
    
    private var fillView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    init(frame: CGRect, percent: CGFloat) {
        super.init(frame: frame)
        commonInit()
        self.percentComplete = percent
    }
    
    func commonInit() {
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 2
        backgroundColor = UIColor.clear
        
        fillView = UIView(frame: CGRect(x: 0, y: frame.height - percentComplete, width: frame.width, height: percentComplete))
        fillView.backgroundColor = UIColor.blue
        addSubview(fillView)
    }
    
    private func updateFillView() {
        fillView.frame = CGRect(x: 0, y: frame.height - frame.height * percentComplete, width: frame.width, height: frame.height * percentComplete)
    }
    
    
}
