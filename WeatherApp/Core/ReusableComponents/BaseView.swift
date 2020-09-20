//
//  BaseView.swift
//  WeatherApp
//
//  Created by Nika Iobishvili on 9/17/20.
//  Copyright © 2020 Home. All rights reserved.
//

import UIKit

import UIKit

class BaseView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    var nibIdentifier: String {
        return String(describing: type(of: self))
    }
    
    init() {
        super.init(frame: CGRect.zero)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        self.addContentView()
        self.configure()
    }
    
    func addContentView() {
        Bundle.main.loadNibNamed(nibIdentifier, owner: self, options: nil)
        guard let content = contentView else { return }
        content.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(content)
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[c]|",
                                                           options: [],
                                                           metrics: nil,
                                                           views: ["c": content]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[c]|",
                                                           options: [],
                                                           metrics: nil,
                                                           views: ["c": content]))
    }
    
    func configure() {
        
    }
}
