//
//  SwiftDetailViewControler.swift
//  TheMovieDBObjc
//
//  Created by Gustavo Travassos on 26/03/20.
//  Copyright © 2020 Eduardo Sarmanho. All rights reserved.
//

import UIKit

class SwiftDetailViewControler: UIViewController {

    var movie: Movie?
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieGenre: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var movieOverview: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        movieTitle.text = movie?.title
        movieGenre.text = movie?.category
        movieOverview.text = movie?.overview
        movieRating.text = "\(movie?.rating ?? 5)"
        
        DispatchQueue.global().async {
            guard let imageURL = URL(string: "https://image.tmdb.org/t/p/w500\(self.movie?.posterPath ?? "/140ewbWv8qHStD3mlBDvvGd0Zvu.jpg")") else { return }
            guard let imageData = try? Data(contentsOf: imageURL) else { return }
            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.movieImage.image = image
            }
        }
    }
}
