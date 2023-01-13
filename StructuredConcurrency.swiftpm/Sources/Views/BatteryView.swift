//
//  BatteryView.swift
//  comic
//
//  Created by Chiao-Te Ni on 2018/3/5.
//  Copyright © 2018年 aaron. All rights reserved.
//

import UIKit

class BatteryView: UIView {
    
    private var electrodeView: UIView?
    private var bodyView: UIView?
    private let headerGradient = CAGradientLayer()
    
    private let xSeperateRatio: CGFloat = 0.93
    private let yHeightRatio: CGFloat = 0.4
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        for subView in subviews {
            subView.removeFromSuperview()
        }
        setupElectrodeView()
        setupBodyView()
    }
    
    func updateBatteryLevel(color: UIColor, emptyColor: UIColor = .clear, value: Double) {
        let level = NSNumber(value: value)
        headerGradient.colors       = [color.cgColor, emptyColor.cgColor]
        headerGradient.locations    = [level, level]
    }
    
    private func setupElectrodeView() {
        let size = bounds.size
        let electrodeViewPtx    = size.width * (xSeperateRatio - 0.02)
        let electrodeViewWidth  = (size.width - electrodeViewPtx)
        let electrodeViewHeight = size.height * yHeightRatio
        let electrodeViewPty    = (size.height - electrodeViewHeight) / 2
        
        electrodeView = UIView(frame: CGRect(x: electrodeViewPtx,
                                             y: electrodeViewPty,
                                             width: electrodeViewWidth,
                                             height: electrodeViewHeight))
        
        setBGGrandent(for: electrodeView, value: 0.5, leftColor: .clear, rightColor: .white)
        
        electrodeView?.layer.cornerRadius = electrodeViewHeight / 2
        electrodeView?.layer.masksToBounds = true
        
        self.addSubview(electrodeView!)
    }
    
    private func setupBodyView() {
        let size = bounds.size
        let bodyViewPtx: CGFloat    = 0
        let bodyViewWidth           = size.width * xSeperateRatio
        let bodyViewPty: CGFloat    = 0
        let bodyViewHeight          = size.height
        
        bodyView = UIView(frame: CGRect(x: bodyViewPtx,
                                        y: bodyViewPty,
                                        width: bodyViewWidth,
                                        height: bodyViewHeight))
        guard let bodyView = bodyView else { return }
        bodyView.layer.borderColor      = UIColor.white.cgColor
        bodyView.layer.borderWidth      = bodyViewHeight / 50
        bodyView.layer.cornerRadius           = bodyViewHeight / 10
        bodyView.layer.masksToBounds    = true
        
        headerGradient.frame            = bodyView.bounds
        headerGradient.colors           = [UIColor.clear.cgColor, UIColor.clear.cgColor]
        headerGradient.startPoint       = CGPoint(x: 0, y: 1)
        headerGradient.endPoint         = CGPoint(x: 1, y: 1)
        
        bodyView.layer.insertSublayer(headerGradient, at: 0)
        self.addSubview(bodyView)
    }
    
    private func setBGGrandent(for view: UIView?, value: Double, leftColor: UIColor, rightColor: UIColor) {
        guard let targetView = view else {
            return
        }
        let level = NSNumber(value: value)
        
        let headerGradient = CAGradientLayer()
        headerGradient.frame        = targetView.bounds
        headerGradient.colors       = [leftColor.cgColor, rightColor.cgColor]
        headerGradient.locations    = [level, level]
        headerGradient.startPoint   = CGPoint(x: 0, y: 1)
        headerGradient.endPoint     = CGPoint(x: 1, y: 1)
        targetView.layer.insertSublayer(headerGradient, at: 0)
    }
}
