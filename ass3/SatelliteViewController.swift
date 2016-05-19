//
//  SatelliteViewController.swift
//  ass3
//
//  Created by Matthew Saliba on 18/05/2016.
//  Copyright © 2016 Matthew Saliba. All rights reserved.
//

import UIKit

class SatelliteViewController: UIViewController {

    var latitude : Double?
    var longittude : Double?
    var baseURL : String = "https://api.nasa.gov/planetary/earth/imagery/"
    var apiKey = "FOlYKG2nt8nWCqD8eYChaRBHIGGoYpcnkdAMuc75"
    let urlComponents = NSURLComponents()
    var cache = NSCache()
    
    @IBOutlet var mapImage: UIImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.longittude = 150.8931239
        self.latitude = -34.424984
        
        // Do any additional setup after loading the view.
        performNASARequest()
    }
    
    // perform the NASA Request
    
    func performNASARequest(){
        
        urlComponents.scheme = "https"
        urlComponents.host = "api.nasa.gov"
        urlComponents.path = "/planetary/earth/imagery"
        
        let longitudeParam = NSURLQueryItem(name: "lon", value: String(self.longittude!))
        let latitudeParam = NSURLQueryItem(name: "lat", value: String(self.latitude!))
        let apiParam = NSURLQueryItem(name: "api_key", value: self.apiKey)
        urlComponents.queryItems = [longitudeParam, latitudeParam, apiParam]
        
        
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
                    self.fetchImage(imageURL)
                    
                }catch {
                    fatalError("Error with Json: \(error)")
                }
            }
        }
        task.resume()
    }
    
    // get the image loaded by the URL and show it in the imageView
    
    func fetchImage(url : String){
        
        let userURL = url
        
        var cachePrev : NSData? = self.cache.objectForKey(userURL) as? NSData
        
        if cachePrev == nil {

            let data : NSData = NSData(contentsOfURL: NSURL(string: userURL)!)!
            self.cache.setObject(data, forKey: userURL)
            cachePrev = self.cache.objectForKey(userURL) as? NSData
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            self.mapImage.image = UIImage(data: cachePrev!)
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
