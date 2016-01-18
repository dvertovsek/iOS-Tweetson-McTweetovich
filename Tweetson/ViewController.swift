//
//  ViewController.swift
//  Tweetson
//
//  Created by MTLab on 16/01/16.
//  Copyright © 2016 dare. All rights reserved.
//

import UIKit
import CoreLocation

import SwiftyJSON
import Alamofire

import ws
import data

class ViewController: UIViewController {
    
    var YahooWhereOnEarthIdOldValue = "none"
    var YahooWhereOnEarthId: String?
    
    var httpReq: HTTPReq?
    
    let locationManager = CLLocationManager()
    
    let tableView = UITableView()
    let infoTableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.Grouped)
    
    var tweetsArray = [Tweet]()
    var geoInfo = [String:String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Trending"

        let openItem = UIBarButtonItem(image: UIImage(named :"open"), style: UIBarButtonItemStyle.Plain, target: self, action: "onOpenButtonPressed")
        self.navigationItem.leftBarButtonItem = openItem
        
        geoInfo = ["name" : "", "type" : "", "country" : "", "cc" : "", "url" : ""]
        
        httpReq = HTTPReq(delegate: self)
        
        if !SimulatorUtility.isRunningSimulator
        {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
            }
        }
        if(SimulatorUtility.isRunningSimulator || CLLocationManager.authorizationStatus() == .Denied)
        {
            self.getWoeidFromLatLong(getDefaultLocation())
        }

        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
            while(true)
            {
                if(self.YahooWhereOnEarthId != nil &&
                    self.YahooWhereOnEarthId! != self.YahooWhereOnEarthIdOldValue)
                {
                    self.getTrends()
                    self.YahooWhereOnEarthIdOldValue = self.YahooWhereOnEarthId!
                }
            }
        })
        
//        let qualityOfServiceClass = QOS_CLASS_UTILITY
//        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
//        
//        dispatch_async(backgroundQueue, {
//            while(ResourcesUtility.bearerToken == "none"){}
//            //this is new thread
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                
//                //this is run on the main thread
//            })
//        })
        
        tableView.backgroundColor = UIColor(red: 200/255, green: 204/255, blue: 190/255, alpha: 0.8)
        tableView.heightAnchor.constraintEqualToConstant(self.view.frame.size.height * 0.8).active = true
        tableView.widthAnchor.constraintEqualToConstant(self.view.frame.size.width).active = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "tweet")
        
        infoTableView.backgroundColor = UIColor(red: 196/255, green: 196/255, blue: 200/255, alpha: 0.8)
        infoTableView.heightAnchor.constraintEqualToConstant(self.view.frame.size.height * 0.2).active = true
        infoTableView.widthAnchor.constraintEqualToConstant(self.view.frame.size.width).active = true
        infoTableView.delegate = self
        infoTableView.dataSource = self
        
        let stackView = UIStackView()
        
        stackView.axis = UILayoutConstraintAxis.Vertical
        stackView.distribution = UIStackViewDistribution.EqualSpacing
        stackView.alignment = UIStackViewAlignment.Center
        
        stackView.addArrangedSubview(tableView)
        stackView.addArrangedSubview(infoTableView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(stackView)
        
        stackView.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
        stackView.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor).active = true
        
//        let stackViewTopConstraint = NSLayoutConstraint(
//            item: stackView,
//            attribute: NSLayoutAttribute.Top,
//            relatedBy: NSLayoutRelation.Equal,
//            toItem: self.topLayoutGuide,
//            attribute: NSLayoutAttribute.Bottom,
//            multiplier: 1.0,
//            constant: 0)
//        self.view.addConstraint(stackViewTopConstraint)
//        
//        let stackViewBottomConstraint = NSLayoutConstraint(
//            item: stackView,
//            attribute: NSLayoutAttribute.Bottom,
//            relatedBy: NSLayoutRelation.Equal,
//            toItem: self.bottomLayoutGuide,
//            attribute: NSLayoutAttribute.Top,
//            multiplier: 1.0,
//            constant: 0)
//        self.view.addConstraint(stackViewBottomConstraint)
//        
//        let stackViewLeadingConstraint = NSLayoutConstraint(
//            item: stackView,
//            attribute: NSLayoutAttribute.Leading,
//            relatedBy: NSLayoutRelation.Equal,
//            toItem: self.view,
//            attribute: NSLayoutAttribute.LeadingMargin,
//            multiplier: 1.0,
//            constant: 0)
//        self.view.addConstraint(stackViewLeadingConstraint)
//        
//        let stackViewTrailingConstraint = NSLayoutConstraint(
//            item: stackView,
//            attribute: NSLayoutAttribute.Trailing,
//            relatedBy: NSLayoutRelation.Equal,
//            toItem: self.view,
//            attribute: NSLayoutAttribute.TrailingMargin,
//            multiplier: 1.0,
//            constant: 0)
//        self.view.addConstraint(stackViewTrailingConstraint)
        
//        let heightConstraintV = NSLayoutConstraint(
//            item: v,
//            attribute: NSLayoutAttribute.Height,
//            relatedBy: NSLayoutRelation.Equal,
//            toItem: nil,
//            attribute: NSLayoutAttribute.NotAnAttribute,
//            multiplier: self.view.frame.size.height,
//            constant: 0.5)
//
//        let heightConstraintW = NSLayoutConstraint(
//            item: w,
//            attribute: NSLayoutAttribute.Height,
//            relatedBy: NSLayoutRelation.Equal,
//            toItem: nil,
//            attribute: NSLayoutAttribute.NotAnAttribute,
//            multiplier: self.view.frame.size.height,
//            constant: 0.5)
    
    }
    
    @IBAction private func onOpenButtonPressed()
    {
        let a = self.sideMenuViewController?.menuViewController as! MenuViewController
        
        a.animate()
        
        self.sideMenuViewController?.openMenuAnimated(true, completion:nil)
    }
    
    private func getWoeidFromLatLong(location: CLLocationCoordinate2D)
    {
        let headers = [
            "Authorization" : "Bearer "+ResourcesUtility.bearerToken
        ]
        let params = [
            "lat" : String(location.latitude),
            "long" : String(location.longitude)
        ]
        
        self.httpReq?.httprequest(Alamofire.Method.GET, url: "https://api.twitter.com/1.1/trends/closest.json", headers: headers, parameters : params)
    }
    
    private func getTrends()
    {
        let headers = [
            "Authorization" : "Bearer "+ResourcesUtility.bearerToken
        ]
        let params = [
            "id" : self.YahooWhereOnEarthId!
        ]
        
        httpReq?.httprequest(.GET, url: "https://api.twitter.com/1.1/trends/place.json", headers: headers, parameters : params)
    }
    
    private func getDefaultLocation()->CLLocationCoordinate2D
    {
//        Default location: Montreal, Canada
        return CLLocationCoordinate2DMake(45.5086699, -73.5539925)
    }
    
}

extension ViewController: WebServiceResultDelegate
{
    func getResult(result: AnyObject) {
        let json = JSON(result)
        if String(json[0]["woeid"]) == "null"
        {
            let twitterTrendsArray = json[0]["trends"]
            
            for (_, value) in twitterTrendsArray {
                
                let t = Tweet(name: String(value["name"]),
                    tweetCount: String(value["tweet_volume"]),
                    url: String(value["url"]))
                tweetsArray.append(t)
            }
            
            tableView.reloadData()
        }
        else
        {
            if(self.YahooWhereOnEarthId != nil)
            {
                self.YahooWhereOnEarthIdOldValue = self.YahooWhereOnEarthId!
            }
            self.YahooWhereOnEarthId = String(json[0]["woeid"])
            
            let arr = json[0]
            let name = String(arr["name"])
            let type = String(arr["placetype"]["name"])
            let url = String(arr["url"])
            let country = String(arr["country"])
            let cc = String(arr["countryCode"])
            let dict = [
                "name" : name,
                "type" : type,
                "url" : url,
                "country" : country,
                "cc" : cc
            ]
            
            self.geoInfo = dict
            infoTableView.reloadData()
        }
    }
}

extension ViewController: CLLocationManagerDelegate
{
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = manager.location!.coordinate
        locationManager.stopUpdatingLocation()
        self.getWoeidFromLatLong(location)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        locationManager.stopUpdatingLocation()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.view.frame.size.height * 0.1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView
        {
            return self.tweetsArray.count
        }
        else{
            switch(section)
            {
                case 0: return 2
                case 1: return 1
                default: return 0
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if tableView == self.tableView
        {
            return 1
        }
        else{
            return 2
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView == self.tableView
        {
    //        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("tweet")! as UITableViewCell
            let cell = UITableViewCell.init(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "tweet")
            
            let t = tweetsArray[indexPath.row]
            
            cell.backgroundColor = UIColor(red: 200/255, green: 204/255, blue: 190/255, alpha: 0.8)
            
            let tweetVolume = (t.tweetCount == "null" ? "0" : t.tweetCount)
            
            cell.textLabel!.text = t.name + " (Tweet volume - " + tweetVolume + ")"
            cell.detailTextLabel?.text = t.url.stringByRemovingPercentEncoding!
            
            cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 20)
            cell.detailTextLabel?.font = UIFont(name: "AvenirNextCondensed-UltraLight" , size: 15)

            return cell
        }
        else
        {
            let cell = UITableViewCell()
            cell.backgroundColor = UIColor(red: 151/255, green: 186/255, blue: 226/255, alpha: 0.7)
            switch(indexPath.section)
            {
                case 0:
                    switch(indexPath.row)
                    {
                        case 0:
                            let type = (geoInfo["type"] == "null" ? "" : " ("+geoInfo["type"]!+")")
                            cell.textLabel!.text = geoInfo["name"]! + type
                            break
                        case 1:
                            cell.textLabel!.text = geoInfo["country"]! + " - code: " + geoInfo["cc"]!
                            break
                        default:
                            break
                    }
                    break
                case 1:
                    cell.textLabel!.text = geoInfo["url"]!
                    break;
                default:
                    break
            }
            return cell
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if tableView == self.tableView
        {
            return ""
        }else{
            switch(section)
            {
                case 0: return "Geolocation info"
                case 1: return "Visit yahoo places"
                default: return nil
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var targetUrl: NSURL?
        if(tableView == self.tableView)
        {
            targetUrl = NSURL(string: tweetsArray[indexPath.row].url)
            
        }
        else{
            if(indexPath.section == 1)
            {
                targetUrl = NSURL(string: geoInfo["url"]!)
            }
        }
        let app = UIApplication.sharedApplication()
        app.openURL(targetUrl!)
    }
}
