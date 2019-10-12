//
//  PlaceViewController.swift
//  Twitkuy
//
//  Created by Willa on 03/10/19.
//  Copyright © 2019 WillaSaskara. All rights reserved.
//

import UIKit

class PlaceViewController: UIViewController {
    
    let dataManager = DataManager.instance
    let userLoc = UserLocation.instance
    
    @IBOutlet var tableView: UITableView!
    
    var placeArray = [DataPlaces]()
    var imagePlacesArray = [UIImage]()
    var distance = [Double]()


    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }
    
    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        let refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "pull to refresh")
//        refresher.addTarget(self, action: #selector(lastUserLocation(latitude:longtitude:)), for: .valueChanged)
        self.tableView.refreshControl = refresher
    }
    
    
    func fetchData(){
        dataManager.crawlDataHotel(fetchingType: .nearbyPlaces) { (result) in
            switch result{
            case .success(let placeRespone):
                placeRespone.results.forEach { (places) in
                    self.placeArray.append(places)
                }
                for i in 0..<placeRespone.results.count{
                    self.calcDistance(index: i)
                    print("DISTANCE AT \(i) is \(self.distance[i])")
                }
                
                
                //disini penting karena harus keluar dulu ke foreach nya lalu rubah ke main thread reload data lalu masuk lagi ke global thread buat fetching image.
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    DispatchQueue.global().async {
                        self.fetchImage()
                    }
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func fetchImage(){
        for i in 0..<placeArray.count{
            if let photos = placeArray[i].photos{
                dataManager.fetchImage(refPhotos: photos[0].photo_reference!, width: 300, height: 300) { (data) in
                    switch data{
                    case .failure(let err):
                        print(err)
                    case .success(let data):
                        self.imagePlacesArray.insert(data, at: i)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        print("success insert data ke \(i), trs jumlah array imagenya \(self.imagePlacesArray.count)")
                    }
                }
            }else{
                let image = #imageLiteral(resourceName: "whiteblank")
                self.imagePlacesArray.insert(image, at: i)
            }
        }
    }
    
    func calcDistance(index: Int){
        let lat = Double((self.placeArray[index].geometry?.location?.lat)!)
        let long = Double((self.placeArray[index].geometry?.location?.lng)!)
        self.distance.insert(userLoc.calcDistanceTo(lat: lat, long: long), at: index)
    }
}

extension PlaceViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath) as! PlaceCustomTableViewCell

        cell.placeNameOutlet.text = placeArray[indexPath.row].name!
        cell.imageOutlet.image = UIImage(named: "whiteblank")
        for i in 0..<imagePlacesArray.count{
            if i == indexPath.row{
                cell.imageOutlet.image = imagePlacesArray[indexPath.row]
            }
        }
        cell.distanceOutlet.text = String(Int(self.distance[indexPath.row])) + " KM"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
