//
//  Networking.swift
//  TheMovieDBObjc
//
//  Created by Gustavo Travassos on 24/03/20.
//  Copyright © 2020 Eduardo Sarmanho. All rights reserved.
//

import Foundation

class Request {
    
    typealias CompletionHandler = ( _ data: [Movie]?, _ error: Error?) -> Void
    typealias CompletionHandlerGenre = ( _ data: [Genre]?, _ error: Error?) -> Void
    
    func fetchNowPlayingMovies(completionHandler: @escaping CompletionHandler) {
    
        var movies: [Movie] = []
        
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=ca01e6658836c07edbe8b8ce2ac738c1&language=pt-BR&page=1") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                
                let response = try decoder.decode(Response.self, from: data)
                movies = response.response!
                completionHandler(movies, nil)
                
            } catch let error{
                print("Error", error)
            }
        }.resume()
    }
    
    func fetchPopularMovies(completionHandler: @escaping CompletionHandler) {
        
        var movies: [Movie] = []
        
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=ca01e6658836c07edbe8b8ce2ac738c1&language=pt-BR&page=1") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(Response.self, from: data)
                movies = response.response!
                completionHandler(movies, nil)
                
            } catch let error{
                print("Error", error)
            }
            }.resume()
        
    }
    
    func fetchMovieGenres(movieId: Int, completionHandler: @escaping CompletionHandlerGenre) {
        
        var genres: [Genre] = []
        
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)?api_key=ca01e6658836c07edbe8b8ce2ac738c1&language=pt-BR") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(Response.self, from: data)
                genres = response.genres!
                completionHandler(genres, nil)
                
            } catch let error{
                print("Error", error)
            }
            }.resume()
    }
    
    func fetchSearchMovies(name: String, completionHandler: @escaping CompletionHandler) {
        
        var movies: [Movie] = []
        let name = name.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        
        guard let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=4c86680eeadb3c625a7f347b2ce6e135&language=en-US&query=\(name)&page=1&include_adult=false") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(Response.self, from: data)
                movies = response.response!
                completionHandler(movies, nil)
                
            } catch let error{
                print("Error", error)
            }
            }.resume()
        
    }
}
