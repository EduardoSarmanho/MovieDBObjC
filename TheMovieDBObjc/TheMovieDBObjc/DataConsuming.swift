
import Foundation

class DataConsuming {
    
    var functions = Functions()
    var popularMovies: [Movie] = []
    var nowPlayingMovies: [Movie] = []
    var serchedMovies: [Movie] = []
    
    func fetchNowPlayingMovies() {
        functions.fetchNowPlayingMovies(nil) { (result) in
            self.nowPlayingMovies = result as! [Movie]
            //            tableView.reloadData
        }
    }
    
    func fetchPopularMovies(){
        functions.fetchPopularMovies(nil) { (result) in
            self.popularMovies = result as! [Movie]
            //            tableView.reloadData
        }
    }
    
    func fetchSearchMovies(movieName: String) {
        functions.fetchSearchMovies(movieName, nil) { (result
            ) in
            self.serchedMovies = result as! [Movie]
            //            tableView.reloadData
            
        }
    }
}




