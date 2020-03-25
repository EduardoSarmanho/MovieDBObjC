//
//  ViewController.m
//  TheMovieDBObjc
//
//  Created by Eduardo Sarmanho on 16/03/20.
//  Copyright © 2020 Eduardo Sarmanho. All rights reserved.
//
 
#import "ViewController.h"
#import "Movie.h"
#import "TableViewCell.h"
#import "DetailViewController.h"
#import "Genre.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate> {
    NSMutableArray *movieArray;
    Movie *movie;
    Boolean *isSearchSelected;
}

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray<Movie *> *popularMovies;
@property (strong, nonatomic) NSMutableArray<Movie *> *nowPlayingMovies;
@property (strong, nonatomic) NSMutableArray<Genre *> *genres;
@property (strong, nonatomic) NSMutableArray<Movie *> *searchedMovies;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchPopularMovies];
    [self fetchNowPlayingMovies];
    isSearchSelected = false;
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self.tableView reloadData];
    });
}

- (void) fetchSearchMovies: (NSString *) name {
    dispatch_async(dispatch_get_global_queue(0,0), ^{

    NSLog(@"Fetching searched string...");
    
    NSMutableArray<Movie *> *searchedMovies = NSMutableArray.new;
    
    NSString *urlString = @"https://api.themoviedb.org/3/search/movie?api_key=ca01e6658836c07edbe8b8ce2ac738c1&language=pt-BR&query=";
    NSString *urlString2 = @"&page=1&include_adult=false";
    urlString = [urlString stringByAppendingString: name];
    urlString = [urlString stringByAppendingString:urlString2];
    
    NSURL *url = [NSURL URLWithString:urlString];
    [[NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSError *err;
        NSArray *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
        if (err){
            NSLog(@"Failed to serialize into JSON: %@", err);
            return;
        }
        
        NSDictionary *resultDictionary = [results valueForKey: @"results"];
        for (NSDictionary *movieList in resultDictionary) {
            NSString *title = movieList[@"title"];
            NSString *overview = movieList[@"overview"];
            NSNumber *rating = movieList[@"vote_average"];
            NSString *posterPath = @"";
            if(![movieList[@"poster_path"] isEqual: [NSNull null]]){
                posterPath = movieList[@"poster_path"];
            }
            NSNumber *identifier = movieList[@"id"];
            
            Movie *movie = Movie.new;
            movie.title = title;
            movie.overview = overview;
            movie.posterPath = posterPath;
            movie.rating = rating;
            movie.identifier = identifier;
            
            [searchedMovies addObject:movie];
        }
        self.searchedMovies = searchedMovies;
        
        NSLog(@"Finished fecthing searched string!");
        [self reloadData];

    }] resume];
    });
}
- (void) reloadData {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}
- (void) fetchMovieGenres: (NSNumber *) movieId {
    NSLog(@"Fetching selected movie genres...");
    
    NSMutableArray<Genre *> *genres = NSMutableArray.new;
    
    NSString *urlString = @"https://api.themoviedb.org/3/movie/";
    NSString *urlString2 = @"?api_key=ca01e6658836c07edbe8b8ce2ac738c1&language=pt-BR";
    NSString *movieIdentifier = [movieId stringValue];
    urlString = [urlString stringByAppendingString: movieIdentifier];
    urlString = [urlString stringByAppendingString:urlString2];
    NSURL *url = [NSURL URLWithString:urlString];
    [[NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSError *err;
        NSArray *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
        if (err){
            NSLog(@"Failed to serialize into JSON: %@", err);
            return;
        }
        
        NSDictionary *resultDictionary = [results valueForKey: @"genres"];
        for (NSDictionary *genreList in resultDictionary) {
            NSString *name = genreList[@"name"];
            NSNumber *identifier = genreList[@"id"];
            
            Genre *genre = Genre.new;
            genre.name = name;
            genre.identifier = identifier;
            
            [genres addObject:genre];
        }
        self.genres = genres;
        
        NSLog(@"Finished fetching selected movie genres!");
    }] resume];
}



- (void) fetchPopularMovies {
    NSLog(@"Fetching popular movies...");
    
    NSString *urlString = @"https://api.themoviedb.org/3/movie/popular?api_key=ca01e6658836c07edbe8b8ce2ac738c1&language=pt-BR&page=1";
    NSURL *url = [NSURL URLWithString:urlString];
    
    [[NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSError *err;
        NSArray *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
        if (err){
            NSLog(@"Failed to serialize into JSON: %@", err);
            return;
        }
        
        NSDictionary *queryDictionary = [results valueForKey:@"results"];
        NSMutableArray<Movie *> *movies = NSMutableArray.new;
        
        for (NSDictionary *movieList in queryDictionary) {
            NSString *title = movieList[@"title"];
            NSString *overview = movieList[@"overview"];
            NSNumber *rating = movieList[@"vote_average"];
            NSString *posterPath = movieList[@"poster_path"];
            NSNumber *identifier = movieList[@"id"];
            
            Movie *movie = Movie.new;
            movie.title = title;
            movie.overview = overview;
            movie.posterPath = posterPath;
            movie.rating = rating;
            movie.identifier = identifier;
            
            [movies addObject:movie];
        }
        self.popularMovies = movies;
        NSLog(@"Finished fetching popular movies!");
    }] resume];
}

- (void) fetchNowPlayingMovies {
    NSLog(@"Fetching now movies...");
    NSString *urlString = @"https://api.themoviedb.org/3/movie/now_playing?api_key=ca01e6658836c07edbe8b8ce2ac738c1&language=pt-BR&page=1";
    NSURL *url = [NSURL URLWithString:urlString];
    [[NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError *err;
        NSArray *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
        if (err){
            NSLog(@"Failed to serialize into JSON: %@", err);
            return;
        }
        
        NSDictionary *queryDictionary = [results valueForKey:@"results"];
        NSMutableArray<Movie *> *movies = NSMutableArray.new;
        
        for (NSDictionary *movieList in queryDictionary) {
            NSString *title = movieList[@"title"];
            NSString *overview = movieList[@"overview"];
            NSNumber *rating = movieList[@"vote_average"];
            NSString *posterPath = movieList[@"poster_path"];
            NSNumber *identifier = movieList[@"id"];
            
            Movie *movie = Movie.new;
            movie.title = title;
            movie.overview = overview;
            movie.posterPath = posterPath;
            movie.rating = rating;
            movie.identifier = identifier;
            
            [movies addObject:movie];
        }
        self.nowPlayingMovies = movies;
        
        NSLog(@"Finished fetching now playing movies!");
    }] resume];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"GoToDetail"])
    {
        // Get reference to the destination view controller
        DetailViewController *destination = (DetailViewController *)[segue destinationViewController];
        
        destination.movie = movie;
    }
}


#pragma mark - UITableView Delegate, DataSource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"cell";
    
    TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SimpleTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    // if search bar is not empty return a new array of movies
    if (isSearchSelected){
        cell.movieDescriptionLabel.text = self.searchedMovies[indexPath.row].overview;
        cell.movieTitle.text = self.searchedMovies[indexPath.row].title;
        NSString *rate = [self.searchedMovies[indexPath.row].rating stringValue];
        cell.movireRatingLabel.text = rate;
        
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            NSString *imageURL = @"https://image.tmdb.org/t/p/w500/";
            if (self.searchedMovies[indexPath.row].posterPath == nil) {
                self.searchedMovies[indexPath.row].posterPath = @"/140ewbWv8qHStD3mlBDvvGd0Zvu.jpg";
            }
            imageURL = [imageURL stringByAppendingString:self.searchedMovies[indexPath.row].posterPath];
            
            NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imageURL]];
            if ( data == nil )
                return;
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.movieImage.image = [UIImage imageWithData:data];
            });
        });
        return cell;
    }
    
    
    if (indexPath.section == 0) {
        cell.movieDescriptionLabel.text = self.popularMovies[indexPath.row].overview;
        cell.movieTitle.text = self.popularMovies[indexPath.row].title;
        NSString *rate = [self.popularMovies[indexPath.row].rating stringValue];
        cell.movireRatingLabel.text = rate;
        
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            NSString *imageURL = @"https://image.tmdb.org/t/p/w500/";
            imageURL = [imageURL stringByAppendingString:self.popularMovies[indexPath.row].posterPath];
            
            NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imageURL]];
            if ( data == nil )
                return;
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.movieImage.image = [UIImage imageWithData:data];
            });
        });
        
    } else {
        cell.movieDescriptionLabel.text = self.nowPlayingMovies[indexPath.row].overview;
        cell.movieTitle.text = self.nowPlayingMovies[indexPath.row].title;
        NSString *rate = [self.nowPlayingMovies[indexPath.row].rating stringValue];
        cell.movireRatingLabel.text = rate;
        
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            NSString *imageURL = @"https://image.tmdb.org/t/p/w500/";
            imageURL = [imageURL stringByAppendingString:self.nowPlayingMovies[indexPath.row].posterPath];
            
            NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imageURL]];
            if ( data == nil )
                return;
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.movieImage.image = [UIImage imageWithData:data];
            });
        });
    }
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isSearchSelected){
        return _searchedMovies.count;
    }
    if (section == 0) {
        return _popularMovies.count;
    } else {
        return _nowPlayingMovies.count;
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (isSearchSelected){
        return 1;
    }
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Filmes Populares";
    } else {
        return @"Em cartaz";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    movie = Movie.new;
    if (isSearchSelected){
        movie = movieArray[indexPath.row];
        [self performSegueWithIdentifier:@"GoToDetail" sender: nil];
    }
    if (indexPath.section == 0) {
        movie = _popularMovies[indexPath.row];
    } else {
        movie = _nowPlayingMovies[indexPath.row];
    }
    [self performSegueWithIdentifier:@"GoToDetail" sender: nil];
    
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text API_AVAILABLE(ios(3.0))
{
    NSString * searchString = searchBar.text;
    if (![text  isEqual: @""]) {
        searchString = [searchString stringByAppendingString: text];
    } else {
        searchString = [searchString substringToIndex:[searchString length] - 1];
    }
    
    if ([searchString  isEqual: @""]) {
        isSearchSelected = false;
    } else {
        isSearchSelected = true;
    }
    // usa searchString pra filtrar ex: filtrarArrayRequest(StringFiltrada: searchString)
    [self fetchSearchMovies: searchString];
//    [self.tableView reloadData];
    
    return YES;
}
@end
