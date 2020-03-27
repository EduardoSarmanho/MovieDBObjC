//
//  ViewController.swift
//  TheMovieDBObjc
//
//  Created by Gustavo Travassos on 26/03/20.
//  Copyright © 2020 Eduardo Sarmanho. All rights reserved.
//

import UIKit

class SwiftViewController: UIViewController {
    
    @IBOutlet weak var movieListTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var nowPlayingMovieList: [Movie] = []
    var popularMovieList: [Movie] = []
    var searchedMovieList: [Movie] = []
    var selectedMovie: Movie?
    var functions = Functions()
    
    var isSearchSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieListTableView.delegate = self
        movieListTableView.dataSource = self
        searchBar.delegate = self
        fetchNowPlayingMovies()
        fetchPopularMovies()
    }
    
    func fetchNowPlayingMovies() {
        functions.fetchNowPlayingMovies(nil) { (result) in
            self.nowPlayingMovieList = result as? [Movie] ?? []
            DispatchQueue.main.async {
                self.movieListTableView.reloadData()
            }
        }
    }
    
    func fetchPopularMovies(){
        functions.fetchPopularMovies(nil) { (result) in
            self.popularMovieList = result as? [Movie] ?? []
            DispatchQueue.main.async {
                self.movieListTableView.reloadData()
            }
        }
    }
    
    func fetchSearchMovies(movieName: String) {
        functions.fetchSearchMovies(movieName, nil) { (result
            ) in
            self.searchedMovieList = result as? [Movie] ?? []
            DispatchQueue.main.async {
                self.movieListTableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "GoToDetail") {
            if let destination = segue.destination as? SwiftDetailViewControler {
                guard let movie = selectedMovie else {return}
                destination.movie = movie
            }
        }
    }
}

extension SwiftViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        var searchString = searchBar.text
        
        if !(text == "") {
            searchString = searchString! + text
        } else {
            searchString?.removeLast()
        }
        
        if (searchString == "") {
            isSearchSelected = false
        } else {
            isSearchSelected = true
        }
        
        return true
    }
}

extension SwiftViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            return "Filmes Populares"
        } else {
            return "Em cartaz"
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if (isSearchSelected) {
            return 1
        }
        return 2
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMovie = Movie()
        if isSearchSelected {
            selectedMovie = searchedMovieList[indexPath.row]
            performSegue(withIdentifier: "GoToDetail", sender: nil)
        }
        if indexPath.section == 0 {
            selectedMovie = popularMovieList[indexPath.row]
        } else {
            selectedMovie = nowPlayingMovieList[indexPath.row]
        }
        performSegue(withIdentifier: "GoToDetail", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (isSearchSelected) {
            return searchedMovieList.count
        }
        if (section == 0) {
            return popularMovieList.count
        } else {
            return nowPlayingMovieList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let simpleTableIdentifier = "cell"
        let cell = movieListTableView.dequeueReusableCell(withIdentifier: simpleTableIdentifier) as! MovieTableViewCell
        
        if (isSearchSelected){
            let movie = searchedMovieList[indexPath.row]
            
            cell.movieTitle.text = movie.title
            cell.movieDescription.text = movie.overview
            cell.movieRating.text = "\(movie.rating)"
            
            DispatchQueue.global(qos: .background).async {
                let imageURL = "https://image.tmdb.org/t/p/w500\(movie.posterPath)"
                let url = URL(fileURLWithPath: imageURL)
                if let data = try? Data(contentsOf: url){
                    DispatchQueue.main.async {
                        let image = UIImage(data: data)
                        cell.movieImage.image = image
                    }
                }
            }
        }
        if (indexPath.section == 0) {
            let movie = popularMovieList[indexPath.row]
            
            cell.movieTitle.text = movie.title
            cell.movieDescription.text = movie.overview
            cell.movieRating.text = "\(movie.rating)"
            
            DispatchQueue.global(qos: .background).async {
                let imageURL = "https://image.tmdb.org/t/p/w500\(movie.posterPath)"
                let url = URL(fileURLWithPath: imageURL)
                if let data = try? Data(contentsOf: url){
                    DispatchQueue.main.async {
                        let image = UIImage(data: data)
                        cell.movieImage.image = image
                    }
                }
            }
        } else {
            let movie = nowPlayingMovieList[indexPath.row]
            
            cell.movieTitle.text = movie.title
            cell.movieDescription.text = movie.overview
            cell.movieRating.text = "\(movie.rating)"
            
            DispatchQueue.global(qos: .background).async {
                let imageURL = "https://image.tmdb.org/t/p/w500\(movie.posterPath)"
                let url = URL(fileURLWithPath: imageURL)
                if let data = try? Data(contentsOf: url){
                    DispatchQueue.main.async {
                        let image = UIImage(data: data)
                        cell.movieImage.image = image
                    }
                }
            }
        }
        return cell
    }
}
