//
//  MenuViewController.swift
//  Tweetson
//
//  Created by MTLab on 16/01/16.
//  Copyright © 2016 dare. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    let twitterButton = UIButton(type: UIButtonType.System)
    let closeButton = UIButton(type: UIButtonType.System)

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        var visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
//        visualEffectView.frame = image.bounds
//        
//        imageView.addSubview(visualEffectView)
//
        let image: UIImage = UIImage(named: "galaxy")!

        self.view.backgroundColor = UIColor(patternImage: image)

        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.view.addSubview(blurEffectView)
        
        self.view.translatesAutoresizingMaskIntoConstraints = false

        twitterButton.frame = CGRectMake(10, 100, 200, 44)
        twitterButton.backgroundColor = UIColor.clearColor()
        twitterButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        twitterButton.titleLabel?.font = UIFont(name: "HelveticaNeue-UltraLight", size: 30)
        
        twitterButton.setTitle("Check events", forState: UIControlState.Normal)
        twitterButton.addTarget(self, action: "onCheckEventsButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        twitterButton.alpha = 0
        self.view.addSubview(twitterButton)
        
        closeButton.frame = CGRectMake(10, 200, 200, 44)
        closeButton.backgroundColor = UIColor.clearColor()
        closeButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        closeButton.titleLabel?.font = UIFont(name: "HelveticaNeue-UltraLight", size: 30)
        
        closeButton.setTitle("Close", forState: UIControlState.Normal)
        closeButton.addTarget(self, action: "onCloseButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        closeButton.alpha = 0
        self.view.addSubview(closeButton)
    
    }
    
    private func setAlpha()
    {
        UIView.animateWithDuration(0.3) { () -> Void in
            self.twitterButton.alpha = 0
            self.closeButton.alpha = 0
        }
    }
    
    func animate()
    {
        UIView.animateWithDuration(1.5) { () -> Void in
            self.twitterButton.alpha = 1.0
            self.closeButton.alpha = 1.0
        }
    }
    
    @IBAction private func onCheckEventsButtonPressed()
    {
        let controller = UINavigationController.init(rootViewController: ViewController())
        self.sideMenuViewController?.setMainViewController(controller, animated: true, closeMenu: true)
    }
    
    @IBAction private func onCloseButtonPressed()
    {
        setAlpha()
        self.sideMenuViewController?.closeMenuAnimated(true, completion:nil)
    }
}
