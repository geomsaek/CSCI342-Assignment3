//
//  SatelliteViewController.swift
//  ass3
//
//  Created by Matthew Saliba on 18/05/2016.
//  Copyright © 2016 Matthew Saliba. All rights reserved.
//

import UIKit

struct retrievedImages {
    
    var imageObject : UIImage
    var imageDate : String
}

class SatelliteViewController: UIViewController {

    let urlComponents = NSURLComponents()
    var cache = NSCache()
    
    var timer = NSTimer()
    var slideShowCount = 0
    
    var latitude : Double?
    var longittude : Double?
    var apiKey = "FOlYKG2nt8nWCqD8eYChaRBHIGGoYpcnkdAMuc75"
    var imageCounter = 0
    
    
    var overlayView = UIView()
    var overlay : UIView?
    var activityIndicator = UIActivityIndicatorView()
    
    var storeImage = [retrievedImages]()
    
    var requestNumber : Int = 10
    var dateCounter : Int = 16
    var sliderTimeout : Double = 1
    
    @IBOutlet var mapImage: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setLoadingScreen(true)
        self.performNASARequestSequence()
    }
    
    // set the loading screen
    func setLoadingScreen(display: Bool){
        
        if display {
            
            overlay = UIView(frame: view.frame)
            overlay!.backgroundColor = UIColor.blackColor()
            overlay!.alpha = 0.8
            
            view.addSubview(overlay!)
            
            overlayView.frame = CGRectMake(0, 0, 80, 80)
            overlayView.center = view.center
            overlayView.backgroundColor = UIColor(white: 0x0000000, alpha: 1)
            overlayView.clipsToBounds = true
            overlayView.layer.cornerRadius = 10
            
            activityIndicator.frame = CGRectMake(0, 0, 40, 40)
            activityIndicator.activityIndicatorViewStyle = .WhiteLarge
            activityIndicator.center = CGPointMake(overlayView.bounds.width / 2, overlayView.bounds.height / 2)
            
            overlayView.addSubview(activityIndicator)
            view.addSubview(overlayView)
            
            activityIndicator.startAnimating()
        }else {

            overlay?.removeFromSuperview()
            activityIndicator.stopAnimating()
            overlayView.removeFromSuperview()
        }
    }
    
    
    // creates the dates to send to the NASA request method
    
    func performNASARequestSequence(){
        
        var curDate = self.dateCounter * self.requestNumber
        curDate = curDate * -1
        
        let components = NSDateComponents()
        let date : NSDate = NSDate()
        
        
        for _ in 0..<self.requestNumber {
            components.setValue(curDate, forComponent: NSCalendarUnit.Day)
            let tempDate = NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: date, options: NSCalendarOptions(rawValue: 0))
            
            self.performNASARequest(tempDate!)
            
            curDate = curDate + self.dateCounter
            
        }
        
    }
    
    // perform the NASA Request
    
    func performNASARequest(date : NSDate){
        
        urlComponents.scheme = "https"
        urlComponents.host = "api.nasa.gov"
        urlComponents.path = "/planetary/earth/imagery"
        
        let dateString = self.createDateString(date)
        
        let longitudeParam = NSURLQueryItem(name: "lon", value: String(self.longittude!))
        let latitudeParam = NSURLQueryItem(name: "lat", value: String(self.latitude!))
        let dateParam = NSURLQueryItem(name: "date", value: dateString)
        let apiParam = NSURLQueryItem(name: "api_key", value: self.apiKey)
        
        urlComponents.queryItems = [longitudeParam, latitudeParam, dateParam, apiParam]
        
        
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: urlComponents.URL!)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                
                do{
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                    let imageURL = json["url"] as! String
                    let date = json["date"] as! String
                    
                    let found = date.indexOf("T")
                    let dateSub = date.substringToIndex(found)
                    
                    self.fetchImage(imageURL, date: dateSub)
                    
                }catch {
                    fatalError("Error with Json: \(error)")
                }
            }
        }
        task.resume()

    }
    
    // get the image loaded by the URL and show it in the imageView
    
    func fetchImage(urlString : String, date: String){
        
        let tempURL = NSURL(string: urlString)
        let data = NSData(contentsOfURL: tempURL!)!
        let temp = retrievedImages(imageObject: UIImage(data: data)!, imageDate: date)
        self.storeImage.append(temp)
        self.imageCounter += 1
        self.checkCount()

    }
    
    // checks that all the images have been received before calling the image slider function
    func checkCount(){
    
        if self.imageCounter == self.requestNumber {
             self.organiseDates()
            
             dispatch_async(dispatch_get_main_queue(), {
                self.timer = NSTimer.scheduledTimerWithTimeInterval(self.sliderTimeout, target: self, selector: #selector(self.slideImage), userInfo:  nil, repeats: true)
                self.setLoadingScreen(false)
            })
        }
    }
    
    
    // sorts the dates in the array
    // sort order is the most recent date first
    // to change this, simply change the "OrderedAscending" property of the NSComparison to "OrderedDescending"
    
    func organiseDates(){
        
        let dateFmt = NSDateFormatter()
        dateFmt.dateFormat =  "yyyy-MM-dd"
        var swapped = false
        
        for _ in 0..<self.storeImage.count - 1 {
            
            swapped = false
            
            for j in 0..<self.storeImage.count - 1 {
                let dateOne = dateFmt.dateFromString(self.storeImage[j].imageDate)
                let dateTwo = dateFmt.dateFromString(self.storeImage[j + 1].imageDate)
                
                let compareResult = dateOne!.compare(dateTwo!)
                if compareResult == NSComparisonResult.OrderedAscending {
                    swap(&self.storeImage[j], &self.storeImage[j + 1])
                    swapped = true
                    
                }
            }
            
            if swapped == false{
                break
            }

        }
        
    }
    
    // changes the main map image
    func slideImage(){

        self.mapImage.image = self.storeImage[self.slideShowCount].imageObject
        self.dateLabel.text = self.storeImage[self.slideShowCount].imageDate
        
        if self.slideShowCount < self.requestNumber - 1 {
            
            self.slideShowCount = self.slideShowCount + 1
        }else {
            self.slideShowCount = 0
        }
    }
    
    // create a date string
    func createDateString(date : NSDate) -> String {
        
        var createDate = ""
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day, .Month, .Year], fromDate: date)
        let year = components.year
        let month = self.checkZero(components.month)
        let day = self.checkZero(components.day)
        
        createDate = String(year) + "-" + String(month) + "-" + String(day)
        
        return createDate
        
    }
    
    // check if a number is < 10 and add a zero to the resulting string
    func checkZero(value : Int) -> String{
        
        var zeroVal = "";
        
        if value < 10 && value > 0 {
            zeroVal = "0" + String(value)
            return zeroVal
        }else {
            return String(value)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

// extension to allow for searching for a character within a string
// returns the index of character that is found

extension String {
    func indexOf(string: String) -> String.Index {
        return rangeOfString(string, options: .LiteralSearch, range: nil, locale: nil)?.startIndex ?? startIndex
    }
}


