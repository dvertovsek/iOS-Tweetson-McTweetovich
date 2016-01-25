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
    let tweetsButton = UIButton(type: UIButtonType.System)
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
        twitterButton.alpha = 1
        
        //        twitterButton.titleLabel?.setTextWithTypeAnimation("Check events")
        self.view.addSubview(twitterButton)

        tweetsButton.frame = CGRectMake(10, 150, 200, 44)
        tweetsButton.backgroundColor = UIColor.clearColor()
        tweetsButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        tweetsButton.titleLabel?.font = UIFont(name: "HelveticaNeue-UltraLight", size: 30)
        
        tweetsButton.setTitle("See tweets", forState: UIControlState.Normal)
        tweetsButton.addTarget(self, action: "onSeeTweetsButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        tweetsButton.alpha = 1
        
        //        twitterButton.titleLabel?.setTextWithTypeAnimation("Check events")
        self.view.addSubview(tweetsButton)

        
        closeButton.frame = CGRectMake(10, 200, 200, 44)
        closeButton.backgroundColor = UIColor.clearColor()
        closeButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        closeButton.titleLabel?.font = UIFont(name: "HelveticaNeue-UltraLight", size: 30)
        
        closeButton.setTitle("Close", forState: UIControlState.Normal)
        closeButton.addTarget(self, action: "onCloseButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        closeButton.alpha = 1
        
//        closeButton.titleLabel?.setTextWithTypeAnimation("Close")
        self.view.addSubview(closeButton)
    
        setAlpha(0.3,val:0)
    }
    
    private func setAlpha(timeInt:NSTimeInterval,val:CGFloat)
    {
        UIView.animateWithDuration(timeInt) { () -> Void in
            self.twitterButton.alpha = val
            self.tweetsButton.alpha = val
            self.closeButton.alpha = val
        }
    }
    
    func animate()
    {
        twitterButton.titleLabel?.setTextWithTypeAnimation("Check events", characterInterval: 0.04)
        setAlpha(2.0, val: 1.0)
    }
    
    @IBAction private func onCheckEventsButtonPressed()
    {
        let controller = UINavigationController.init(rootViewController: ViewController())
        self.sideMenuViewController?.setMainViewController(controller, animated: true, closeMenu: true)
    }
    
    @IBAction private func onSeeTweetsButtonPressed()
    {
        let controller = UINavigationController.init(rootViewController: TweetsMapViewController())
        self.sideMenuViewController?.setMainViewController(controller, animated: true, closeMenu: true)
    }
    
    
    @IBAction private func onCloseButtonPressed()
    {
        setAlpha(0.3, val:0)
        self.sideMenuViewController?.closeMenuAnimated(true, completion:nil)
    }
}

extension UILabel {
    
    func setTextWithTypeAnimation(typedText: String, characterInterval: NSTimeInterval = 0.25) {
        text = ""
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) {
            for character in typedText.characters {
                dispatch_async(dispatch_get_main_queue()) {
                    self.text = self.text! + String(character)
                }
                NSThread.sleepForTimeInterval(characterInterval)
            }
        }
    }
    
}
