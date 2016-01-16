//
//  MainViewController.swift
//  Tweetson
//
//  Created by MTLab on 16/01/16.
//  Copyright © 2016 dare. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "My view"
        self.view.backgroundColor = UIColor.grayColor()
        
        let openItem = UIBarButtonItem(image: UIImage(named :"open"), style: UIBarButtonItemStyle.Plain, target: self, action: "onOpenButtonPressed")
        
        self.navigationItem.leftBarButtonItem = openItem
    }
    
    @IBAction private func onOpenButtonPressed()
    {
        let a = self.sideMenuViewController?.menuViewController as! MenuViewController
        
        a.animate()
        
        self.sideMenuViewController?.openMenuAnimated(true, completion:nil)
    }
}
