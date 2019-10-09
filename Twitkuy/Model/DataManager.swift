//
//  DataManager.swift
//  Twitkuy
//
//  Created by Willa on 03/10/19.
//  Copyright © 2019 WillaSaskara. All rights reserved.
//

import Foundation
import UIKit

enum fetchingType {
    case nearbyPlaces
    case placeDistance
    case placeDetil
}

class DataManager: NSObject {
    
    let locationManager = UserLocation.instance
    static var instance = DataManager()
    private var baseUrlHotel = "https://maps.googleapis.com/maps/api/"
    private var baseUrlImage = "https://maps.googleapis.com/maps/api/place/photo?"
    private var apiKey = "AIzaSyCaS7uhGH_kIV5emM0IfFcQCVhZYrdC1vc"
  
    var coordinate: (lat: Double?, long: Double?)
    
    override private init(){
        super.init()
        locationManager.delegate = self
    }
    
    
    func crawlDataHotel(fetchingType: fetchingType, completion: @escaping (Result<PlacesResponse, Error>) -> Void){
        
        if fetchingType == .nearbyPlaces{
            let stringLatitude = String(coordinate.lat!)
            let stringLongtitude = String(coordinate.long!)
            let stringRadius = String(5000)
            let stringURL = baseUrlHotel + "place/nearbysearch/json?location=\(stringLatitude),\(stringLongtitude)&radius=\(stringRadius)&keyword=hotel&key=AIzaSyCaS7uhGH_kIV5emM0IfFcQCVhZYrdC1vc"
            
            guard let url = URL(string: stringURL) else { return }
            
            URLSession.shared.dataTask(with: url) { (data, respone, error) in
                //error
                if let err = error{
                    print("ERROR: SOMETHING WRONG WITH URLSESION SHARED \(err.localizedDescription)")
                    completion(.failure(err))
                    return
                }
                //success
                do{
                    let places = try JSONDecoder().decode(PlacesResponse.self, from: data!)
                    completion(.success(places))
                }catch let jsonErr{
                    completion(.failure(jsonErr))
                }
            }.resume()
        }
    }
    
    
    func fetchImage(refPhotos: String, width: Int, height: Int, completion: @escaping (Result<UIImage, Error>) -> Void){
        
        let stringUrl = baseUrlImage + "maxwidth=\(width)&maxheight=\(height)&photoreference=\(refPhotos)&key=\(self.apiKey)"
        guard let url = URL(string: stringUrl) else { return }
        
        do{
            let data = try Data(contentsOf: url)
            if let image = UIImage(data: data){
                completion(.success(image))
            }
        }catch{
            print("ERROR: FAILED TO FETCH IMAGE : \(error)")
        }
        
//
//        URLSession.shared.dataTask(with: url) { (data, respone, error) in
//            if let err = error{
//                print("SOMETHING WRONG WITH URLSESSION IMAGE : \(err)")
//                completion(.failure(err))
//                return
//            }
//            if let image = UIImage(data: data!){
//                completion(.success(image))
//            }
//
//        }.resume()
    }
    
    
    
    
    
}

extension DataManager: UserLocationDelegateProtocol{
    func lastUserLocation(latitude: Double, longtitude: Double) {
        self.coordinate.lat = latitude
        self.coordinate.long = longtitude
        print("user lcoation protocol called")
        
    }
}
