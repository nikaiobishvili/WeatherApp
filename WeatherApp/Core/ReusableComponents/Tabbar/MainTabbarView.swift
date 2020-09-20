//
//  MainTabbarView.swift
//  WeatherApp
//
//  Created by Nika Iobishvili on 9/17/20.
//  Copyright © 2020 Home. All rights reserved.
//

import UIKit

enum MainTabBarItem: Int {
    case today
    case forecast
}

protocol MainTabbarViewDelegate: class {
    func didTap(at item: MainTabBarItem)
}

class MainTabbarView: BaseView {
    
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var selectedViewLeftConstraint: NSLayoutConstraint!
    private var kPaddingBetweenItems: CGFloat = 16
    
    var currentTab: MainTabBarItem = .today {
        didSet {
            configureItems(currentTab)
            let widthPerItem: CGFloat = stackView.frame.size.width / CGFloat(stackView.subviews.count)
            selectedViewLeftConstraint.constant = -(
                widthPerItem * CGFloat(currentTab.rawValue) + kPaddingBetweenItems / 2 * CGFloat(currentTab.rawValue)
            )
            UIView.animate(
                withDuration: 0.25,
                delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
                self.layoutIfNeeded()
            })
        }
    }
    
    weak var delegate: MainTabbarViewDelegate?
    
    override func configure() {
        self.contentView.backgroundColor = mainTabbarViewBgColor
        self.stackView.subviews.forEach({
            guard let item = $0 as? MainTabbarButton else { return }
            item.addTarget(self, action: #selector(didTap(button:)), for: .touchUpInside)
        })
        configureItems(.today)
    }
    
    func configureItems(_ tabbarItem: MainTabBarItem) {
        self.stackView.subviews.forEach({
            guard let item = $0 as? MainTabbarButton else { return }
            item.isSelected = item.tag == tabbarItem.rawValue
        })
    }
    
    func move2(tabbarItem: MainTabBarItem) {
        self.currentTab = tabbarItem
        self.delegate?.didTap(at: self.currentTab)
    }
    
    @objc private func didTap(button: MainTabbarButton) {
        move2(tabbarItem: MainTabBarItem(rawValue: button.tag) ?? .today)
    }
    
}

class MainTabbarButton: UIButton {
    override var isSelected: Bool {
        didSet{
            if self.isSelected {
                self.tintColor = Color.primary.uiColor
            } else {
                self.tintColor = UIColor.init(hex: "#6E6E6E")
            }
        }
    }
}
