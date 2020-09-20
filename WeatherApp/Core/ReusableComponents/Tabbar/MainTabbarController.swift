//
//  MainTabbarController.swift
//  WeatherApp
//
//  Created by Nika Iobishvili on 9/17/20.
//  Copyright © 2020 Home. All rights reserved.
//

import UIKit

class MainTabbarController: UITabBarController {
    
    private let kHeight: CGFloat = 60
    private let kWidth: CGFloat = 64
    private let kPaddingFromBottom: CGFloat = 90
    
    let tabbarView = MainTabbarView()
    let backgroundImage = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.isHidden = true
        self.tabbarView.clipsToBounds = true
        self.configureTabbar()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.tabbarView.layer.cornerRadius = 22
    }
    
    private func configureTabbar() {
        
        self.tabBar.items?.forEach({
            $0.title = nil
        })
        
        self.backgroundImage.frame = CGRect.init(
            x: 0,
            y: UIScreen.main.bounds.height - self.kHeight,
            width: UIScreen.main.bounds.width - self.kWidth,
            height: self.kHeight
        )
        
        self.backgroundImage.center = self.view.center
        
        self.backgroundImage.frame.origin.y = UIScreen.main.bounds.height - self.kPaddingFromBottom
        
        self.view.addSubview(self.backgroundImage)
        
        self.tabbarView.frame = self.backgroundImage.frame
        
        self.view.addSubview(self.tabbarView)
        
        self.view.bringSubviewToFront(self.tabbarView)
        
        self.backgroundImage.bringSubviewToFront(self.tabbarView)
        
        self.tabbarView.delegate = self
    }
}

extension MainTabbarController: MainTabbarViewDelegate {
    func didTap(at item: MainTabBarItem) {
        self.selectedIndex = item.rawValue
    }
}

