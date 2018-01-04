//
//  DetailViewController.swift
//  GoogleMapApp
//
//  Created by mobile consulting on 1/4/18.
//  Copyright © 2018 mobile consulting. All rights reserved.
//

import UIKit
import GooglePlaces

class DetailViewController: UIViewController {

    var place: GMSPlace!
    var placesClient = GMSPlacesClient.shared()
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var placeTitle: UILabel!
    @IBOutlet weak var openNow: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var website: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var address: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placesClient.lookUpPhotos(forPlaceID: place.placeID) { (photos, error) -> Void in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                if let firstPhoto = photos?.results.first {
                    self.loadImageForMetadata(photoMetadata: firstPhoto)
                } else {
                    print("No photo found")
                }
            }
        }
        
        placeTitle.text = place.name
        if(place.openNowStatus == GMSPlacesOpenNowStatus.yes) {
            openNow.text = "Open"
        } else if (place.openNowStatus == GMSPlacesOpenNowStatus.no) {
            openNow.text = "Closed"
        } else {
            openNow.text = ""
        }
        
        phone.text = place.phoneNumber
        rating.text = "Rating: \(place.rating) / 5"
        if(place.website != nil) {
            website.text = "\(place.website!)"
        } else {
            website.text = "No website found"
        }
        
        price.text = "Price: \(place.priceLevel.rawValue) / 4"
        if(place.addressComponents != nil) {
            var fullAddress = ""
            for (_,e) in (place.addressComponents?.enumerated())! {
                fullAddress.append("\(e.name) ")
            }
            
            address.text = "\(fullAddress)"
        } else {
            address.text = "Address not found"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata) {
        GMSPlacesClient.shared().loadPlacePhoto(photoMetadata, callback: {
            (photo, error) -> Void in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                self.image.image = photo
            }
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
