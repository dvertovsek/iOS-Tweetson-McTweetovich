//
//  TweetsMapViewController.swift
//  Tweetson
//
//  Created by MTLab on 23/01/16.
//  Copyright © 2016 dare. All rights reserved.
//
import UIKit
import MapKit

import Eureka

class TweetsMapViewController: FormViewController{
    
    var randomQueries:String
        {
        get {
            let array = [
                "Star wars", "#starwars", "LOTR", "Ammon Bundy","#nightlife","restaurants","Ultra Music Festival","#Miami","#NYC","#country","#marines","#usn","#ocean","Canada"
                ,"Croatia","Montreal","Zadar"]
            let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
            return array[randomIndex]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Tweets by location"
        
        let openItem = UIBarButtonItem(image: UIImage(named :"open"), style: UIBarButtonItemStyle.Plain, target: self, action: "onOpenButtonPressed")
        self.navigationItem.leftBarButtonItem = openItem

        
        form +++ Section("Custom cells")
            <<< LocationRow(){
                $0.title = "Select your location"
                $0.value = CLLocation(latitude: -34.91, longitude: -56.1646)
        }
            .cellUpdate()
                {_,row in
                    let alert = UIAlertController(title: "Twitter search query", message: "Enter a search query", preferredStyle: .Alert)
                    alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
                        textField.text = self.randomQueries
                    })
                    alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
                    alert.addAction(UIAlertAction(title: "Send", style: .Default, handler:
                        { (action) -> Void in
                            
                            let textField = alert.textFields![0] as UITextField
                            print("Text field: \(textField.text)")
                            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TweetTableViewController") as! TweetTableViewController
                            vc.location = row.value!
                            vc.query = textField.text!
                            self.presentViewController(vc, animated: true, completion: nil)
                    }))
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                }
//            <<< ButtonRow() {
//                $0.title = "See tweets"
//            }
//                .onCellSelection {  cell, row in
//                    if didLoadTweets
//                    {
//                        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TweetTableViewController") as! TweetTableViewController
//                        vc.tweetIDArray =
//                            self.presentViewController(vc, animated: true, completion: nil)
//                    }
//            }
    }
    
    @IBAction private func onOpenButtonPressed()
    {
        let a = self.sideMenuViewController?.menuViewController as! MenuViewController
        
        a.animate()
        
        self.sideMenuViewController?.openMenuAnimated(true, completion:nil)
    }
}

public final class LocationRow : SelectorRow<CLLocation, MapViewController>, RowType {
    public required init(tag: String?) {
        super.init(tag: tag)
        presentationMode = .Show(controllerProvider: ControllerProvider.Callback { return MapViewController(){ _ in } }, completionCallback: { vc in vc.navigationController?.popViewControllerAnimated(true) })
        displayValueFor = {
            guard let location = $0 else { return "" }
            let fmt = NSNumberFormatter()
            fmt.maximumFractionDigits = 4
            fmt.minimumFractionDigits = 4
            let latitude = fmt.stringFromNumber(location.coordinate.latitude)!
            let longitude = fmt.stringFromNumber(location.coordinate.longitude)!
            return  "\(latitude), \(longitude)"
        }
    }
}

public class MapViewController : UIViewController, TypedRowControllerType, MKMapViewDelegate {
    
    public var row: RowOf<CLLocation>!
    public var completionCallback : ((UIViewController) -> ())?
    
    lazy var mapView : MKMapView = { [unowned self] in
        let v = MKMapView(frame: self.view.bounds)
        v.autoresizingMask = UIViewAutoresizing.FlexibleWidth.union(UIViewAutoresizing.FlexibleHeight)
        return v
        }()
    
    lazy var pinView: UIImageView = { [unowned self] in
        let v = UIImageView(frame: CGRectMake(0, 0, 50, 50))
        v.image = UIImage(named: "map_pin", inBundle: NSBundle(forClass: MapViewController.self), compatibleWithTraitCollection: nil)
        v.image = v.image?.imageWithRenderingMode(.AlwaysTemplate)
        v.tintColor = self.view.tintColor
        v.backgroundColor = .clearColor()
        v.clipsToBounds = true
        v.contentMode = .ScaleAspectFit
        v.userInteractionEnabled = false
        return v
        }()
    
    let width: CGFloat = 10.0
    let height: CGFloat = 5.0
    
    lazy var ellipse: UIBezierPath = { [unowned self] in
        let ellipse = UIBezierPath(ovalInRect: CGRectMake(0 , 0, self.width, self.height))
        return ellipse
        }()
    
    
    lazy var ellipsisLayer: CAShapeLayer = { [unowned self] in
        let layer = CAShapeLayer()
        layer.bounds = CGRectMake(0, 0, self.width, self.height)
        layer.path = self.ellipse.CGPath
        layer.fillColor = UIColor.grayColor().CGColor
        layer.fillRule = kCAFillRuleNonZero
        layer.lineCap = kCALineCapButt
        layer.lineDashPattern = nil
        layer.lineDashPhase = 0.0
        layer.lineJoin = kCALineJoinMiter
        layer.lineWidth = 1.0
        layer.miterLimit = 10.0
        layer.strokeColor = UIColor.grayColor().CGColor
        return layer
        }()
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience public init(_ callback: (UIViewController) -> ()){
        self.init(nibName: nil, bundle: nil)
        completionCallback = callback
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView)
        
        mapView.delegate = self
        mapView.addSubview(pinView)
        mapView.layer.insertSublayer(ellipsisLayer, below: pinView.layer)
        
        mapView.mapType = MKMapType.HybridFlyover
        
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "tappedDone:")
        button.title = "Done"
        navigationItem.rightBarButtonItem = button
        
        if let value = row.value {
            let region = MKCoordinateRegionMakeWithDistance(value.coordinate, 400, 400)
            mapView.setRegion(region, animated: true)
        }
        else{
            mapView.showsUserLocation = true
        }
        updateTitle()
        
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let center = mapView.convertCoordinate(mapView.centerCoordinate, toPointToView: pinView)
        pinView.center = CGPointMake(center.x, center.y - (CGRectGetHeight(pinView.bounds)/2))
        ellipsisLayer.position = center
    }
    
    
    func tappedDone(sender: UIBarButtonItem){
        let target = mapView.convertPoint(ellipsisLayer.position, toCoordinateFromView: mapView)
        row.value? = CLLocation(latitude: target.latitude, longitude: target.longitude)
        completionCallback?(self)
    }
    
    func updateTitle(){
        let fmt = NSNumberFormatter()
        fmt.maximumFractionDigits = 4
        fmt.minimumFractionDigits = 4
        let latitude = fmt.stringFromNumber(mapView.centerCoordinate.latitude)!
        let longitude = fmt.stringFromNumber(mapView.centerCoordinate.longitude)!
        title = "\(latitude), \(longitude)"
    }
    
    public func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "annotation")
        pinAnnotationView.draggable = false
        pinAnnotationView.animatesDrop = true
        return pinAnnotationView
    }
    
    public func mapView(mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        ellipsisLayer.transform = CATransform3DMakeScale(0.5, 0.5, 1)
        UIView.animateWithDuration(0.2, animations: { [weak self] in
            self?.pinView.center = CGPointMake(self!.pinView.center.x, self!.pinView.center.y - 10)
            })
    }
    
    public func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        ellipsisLayer.transform = CATransform3DIdentity
        UIView.animateWithDuration(0.2, animations: { [weak self] in
            self?.pinView.center = CGPointMake(self!.pinView.center.x, self!.pinView.center.y + 10)
            })
        updateTitle()
    }
}