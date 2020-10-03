//
//  MovieGridViewController.swift
//  flixter
//
//  Created by Mohit on 10/3/20.
//  Copyright © 2020 nmn. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieGridViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var movies = [[String : Any]]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 0
        
        let url = URL(string:"https://api.themoviedb.org/3/movie/297762/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                self.movies = (dataDictionary["results"] as? [[String : Any]])!
                self.collectionView.reloadData()
            }
        }
        task.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let movie = movies[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCellCollectionViewCell", for: indexPath) as! MovieGridCellCollectionViewCell
        let baseUrl = "https://image.tmdb.org/t/p/w185"
             let posterPath = movie["poster_path"] as! String
             let posterUrl = URL(string: baseUrl + posterPath)
             
             cell.posterView.af_setImage(withURL: posterUrl!)
             
             return cell
    }
    
    
    
    
    
}
