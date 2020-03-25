
import Foundation

class DataConsuming {
    
    var viewController = ViewController()
    func printNowPlayingMovies() {
        viewController.fetchPopularMovies()
        print(viewController.popularMovies)
    }
    
    func printPopularMovies() {
        
    }
    
    func getMovieDetails() {
        
    }

}


