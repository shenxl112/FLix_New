//
//  NowPlayingVC.swift
//  FLix
//
//  Created by shenxianglan on 9/6/18.
//  Copyright © 2018 shenxianglan. All rights reserved.
//

import UIKit
import AlamofireImage

class NowPlayingVC: UIViewController,UITableViewDataSource,UISearchBarDelegate {
   
   
   @IBOutlet weak var tableView: UITableView!
   @IBOutlet weak var searchBar: UISearchBar!
    
   
   var movies: [[String: Any]] = []
   var refreshControl: UIRefreshControl!
   var filteredData: [String]!
   
   override func viewDidLoad() {
      //tableView.rowHeight = 215
      super.viewDidLoad()
      
      refreshControl = UIRefreshControl()
      refreshControl.addTarget(self, action: #selector(NowPlayingVC.didPullToRefresh(_:)), for: .valueChanged)
      tableView.insertSubview(refreshControl, at: 0)
      
      tableView.dataSource = self
      searchBar.delegate = self
    
      fetchMovies()
      //didPullToRefresh(refreshControl: UIRefreshControl)
   }
   
//   override func viewDidAppear(_ animated: Bool) {
//      createAlart(title: "Title", message: "Message")
//   }
   
   @objc func didPullToRefresh(_ refreshControl: UIRefreshControl){
      fetchMovies()
   }
   
   func fetchMovies(){
      let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
      let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
      let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
      let task = session.dataTask(with: request) { (data, response, error) in
         //This is will run when the network request returns
         if let error = error{
            print(error.localizedDescription)
         }else if let data = data{ //key is string value is Any
            let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            //  print(dataDictionary)
            
            let movies = dataDictionary["results"] as! [[String: Any]]
            self.movies = movies
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            
            //            for movie in movies{
            //               let title = movie["title"] as! String
            //               print(title)
            //            }
            //            print(movies)
         }
      }
      task.resume()
   }
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return movies.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
      
      let movie = movies[indexPath.row]
      let title = movie["title"]as! String
      let overview = movie["overview"] as! String
      cell.titleLabel.text = title
      cell.overviewLabel.text = overview
      
      let posterPathString = movie["poster_path"] as! String
      let baseURLString = "https://image.tmdb.org/t/p/w500/"
      
      let posterURL = URL(string: baseURLString + posterPathString)!
      cell.posterimageView.af_setImage(withURL: posterURL)
      
      return cell
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      let cell = sender as! UITableViewCell
      if let indexPath = tableView.indexPath(for: cell){
      let movie = movies[indexPath.row]
      let detailViewController = segue.destination as! DetailViewController
      detailViewController.movie = movie
      }
   }
   
   func createAlart(title:String, message:String){
      let alertController = UIAlertController(title: "Cannot Get Movies", message: "The Internet connection appears to be offline", preferredStyle: .alert)

      // create a cancel action
      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
         // handle cancel response here. Doing nothing will dismiss the view.
      }
      // add the cancel action to the alertController
      alertController.addAction(cancelAction)

      // create an OK action
      let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
         // handle response here.
      }
      // add the OK action to the alert controller
      alertController.addAction(OKAction)
      
      present(alertController, animated: true)
   }
   
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
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
