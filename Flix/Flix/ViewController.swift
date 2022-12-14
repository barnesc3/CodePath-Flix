//
//  ViewController.swift
//  Flix
//
//  Created by Calvin Barnes on 9/6/22.
//

import UIKit
import AlamofireImage

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    
    @IBOutlet var tableView: UITableView!
    
    var movies = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                 
                 self.movies = dataDictionary["results"] as! [[String:Any]]
                 
                 self.tableView.reloadData()

             }
        }
        task.resume()    }
        



    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let synopsis = movie["overview"] as! String
        
        
        cell.title.text = title
        cell.synopsis.text = synopsis
        
        let baseUrl = "https://image.tmdb.org/t/p/original"
        let coverPath = movie["poster_path"] as! String
        let coverUrl = URL(string: baseUrl + coverPath)
        
        cell.cover.af.setImage(withURL: coverUrl!)
        
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return movies.count
       
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        
        let movie = movies[indexPath.row]
        
        let detailsViewController = segue.destination as! MovieDetailsViewController
        detailsViewController.movie = movie
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
