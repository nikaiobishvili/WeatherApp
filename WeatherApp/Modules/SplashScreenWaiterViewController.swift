//
//  SplashScreenWaiterViewController.swift
//  WeatherApp
//
//  Created by Nika Iobishvili on 9/17/20.
//  Copyright © 2020 Home. All rights reserved.
//

import UIKit

class SplashScreenWaiterViewController: UIViewController {
    
    @IBOutlet private weak var splashLogoImageView: UIImageView!
    
    private let kRotationAnimationKey = "rotationanimationkey"
    
    private let kSplashDuration: Double = 2.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.splashLogoImageView.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.rotate()
        UIView.animate(withDuration: 0.25) {[weak self] in
            self?.splashLogoImageView.alpha = 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + kSplashDuration) {[weak self] in
            self?.launchMain()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UIView.animate(withDuration: 0.25) {[weak self] in
            self?.splashLogoImageView.alpha = 0
        }
        self.stopRotating()
    }
    
    private func launchMain() {
        let todayViewController = Storyboard.main.instantiateViewController(TodayViewController.self, "TodayViewController")
        
        let foreCasetViewController = Storyboard.main.instantiateViewController(ForecastViewController.self, "ForecastViewController")
        
        let tabbarViewController = MainTabbarController()
        
        tabbarViewController.viewControllers = [ todayViewController, foreCasetViewController ]
        
        AppDelegate.shared.window?.rootViewController = tabbarViewController
    }
    
    private func rotate(duration: Double = 1) {
        if splashLogoImageView.layer.animation(forKey: kRotationAnimationKey) == nil {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            
            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Float.pi * 2.0
            rotationAnimation.duration = duration
            rotationAnimation.repeatCount = Float.infinity
            
            splashLogoImageView.layer.add(rotationAnimation, forKey: kRotationAnimationKey)
        }
    }
    
    private func stopRotating() {
        if splashLogoImageView.layer.animation(forKey: kRotationAnimationKey) != nil {
            splashLogoImageView.layer.removeAnimation(forKey: kRotationAnimationKey)
        }
    }
    
}
