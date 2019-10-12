//
//  modelCrawler.swift
//  Twitkuy
//
//  Created by Willa on 03/10/19.
//  Copyright © 2019 WillaSaskara. All rights reserved.
//

import Foundation
import UIKit

//MARK: - Places Crawler Response
class PlacesResponse: Codable {
    var results : [DataPlaces]
}

class DataPlaces: Codable{
    var name : String?
    var place_id : String?
    var photos: [DetailPhotos]?
    var geometry : DataLocation?
}

//MARK: - Detail Places Crawler Response
class DetailResponse: Codable{
    var result: DataDetail?
    var status: String?
}


class DataDetail: Codable{
    var formatted_address : String?
    var formatted_phone_number : String?
    var name : String?
    var geometry : DataLocation?
    var rating : String?
    var reviews : [DetailReview]?
    var opening_hours : DetailOpenHour?
    var photos : [DetailPhotos]?
    var website : String?
    var place_id : String?
}

class DataLocation: Codable{
    var location : DetailLocation?
    var viewport : DetailViewPort?
}

class DetailViewPort: Codable{
    var northeast : DetailLocation?
    var southwest : DetailLocation?
}

class DetailLocation: Codable{
    var lat : Float?
    var lng : Float?
}

class DetailOpenHour: Codable{
    var open_now : String?
    var weekday_text : [String]?
}

class DetailReview: Codable{
    var author_name : String?
    var text : String?
    var rating : String?
}


class DetailPhotos: Codable{
    var height : Int?
    var width : Int?
    var photo_reference : String?
}

class imageRespone: Codable {
    var image : Data?
}

extension UIImage {
    var data: Data? {
        if let data = self.jpegData(compressionQuality: 1.0) {
            return data
        } else {
            return nil
        }
    }
    
}

extension Data {
    var image: UIImage? {
        if let image = UIImage(data: self) {
            return image
        } else {
            return nil
        }
    }
}


