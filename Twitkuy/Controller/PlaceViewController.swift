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
    
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var imageOutlet: UIImageView!
    
    var placeArray = [DataPlaces]()
    var imagePlacesArray = [UIImage]()

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
            guard let photos = placeArray[i].photos else { return }
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
        }
       
        
        
    }
    
    

}

extension PlaceViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath) as! PlaceCustomTableViewCell

        cell.placeNameOutlet.text = placeArray[indexPath.row].name!
        for i in 0..<imagePlacesArray.count{
            if i == indexPath.row{
                cell.imageOutlet.image = imagePlacesArray[indexPath.row]
            }
        }
        
        print("DI CELL NYA \(imagePlacesArray.count)")
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
