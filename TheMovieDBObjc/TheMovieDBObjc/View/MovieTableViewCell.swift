//
//  MovieTableViewCell.swift
//  TheMovieDBObjc
//
//  Created by Gustavo Travassos on 26/03/20.
//  Copyright © 2020 Eduardo Sarmanho. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieDescription: UILabel!
    @IBOutlet weak var movieRating: UILabel!
}
