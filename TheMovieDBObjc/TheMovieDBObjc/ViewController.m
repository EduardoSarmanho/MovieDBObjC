//
//  ViewController.m
//  TheMovieDBObjc
//
//  Created by Eduardo Sarmanho on 16/03/20.
//  Copyright © 2020 Eduardo Sarmanho. All rights reserved.
//

#import "ViewController.h"
#import "Movie.h"
#import "APIAnswer.h"
#import "TableViewCell.h"
#import "DetailViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *movieArray;
    Movie *movie;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray<Movie *> *popularMovies;
@property (strong, nonatomic) NSMutableArray<Movie *> *nowPlayingMovies;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self movieSetUp];
    [self arraySetUp];
    [self fetchPopularMovies];
    [self fetchNowPlayingMovies];
    
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self.tableView reloadData];
    });
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
            NSString *description = movieList[@"overview"];
            NSNumber *rate = movieList[@"vote_average"];
            NSString *imageURL = movieList[@"poster_path"];
            //            NSString *category = movieList[@""]
            
            
            Movie *movie = Movie.new;
            movie.title = title;
            movie.overview = description;
            movie.resume = description;
            movie.imageURL = imageURL;
            movie.rate = rate;
            //            movie.category = category;
            
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
            NSString *description = movieList[@"overview"];
            NSNumber *rate = movieList[@"vote_average"];
            NSString *imageURL = movieList[@"poster_path"];
            //            NSString *category = movieList[@""]
            
            
            Movie *movie = Movie.new;
            movie.title = title;
            movie.overview = description;
            movie.resume = description;
            movie.imageURL = imageURL;
            movie.rate = rate;
            //            movie.category = category;
            
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
        [self movieSetUp];
        // Get reference to the destination view controller
        DetailViewController *destination = (DetailViewController *)[segue destinationViewController];
        
        destination.movie = movie;
        }
}

- (void)arraySetUp {
    movieArray = [NSMutableArray arrayWithArray: @[@"1",@"2",@"3",@"4",@"5",@"6",@"7"]];
}
- (void)movieSetUp {
    movie = Movie.new;
    movie.category = @"";
    movie.title = @"212";
    movie.resume = @"212";
    movie.overview = @"212";
    movie.rate = @12;
    movie.category = @"212";
    movie.imageURL = @"212";
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
    if (indexPath.section == 0) {
        cell.movieDescriptionLabel.text = self.popularMovies[indexPath.row].resume;
        cell.movieTitle.text = self.popularMovies[indexPath.row].title;
        NSString *rate = [self.popularMovies[indexPath.row].rate stringValue];
        cell.movireRatingLabel.text = rate;
        
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            NSString *imageURL = @"https://image.tmdb.org/t/p/w500/";
            imageURL = [imageURL stringByAppendingString:self.popularMovies[indexPath.row].imageURL];
            
            NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imageURL]];
            if ( data == nil )
                return;
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.movieImage.image = [UIImage imageWithData:data];
            });
        });
        
    } else {
        cell.movieDescriptionLabel.text = self.nowPlayingMovies[indexPath.row].resume;
        cell.movieTitle.text = self.nowPlayingMovies[indexPath.row].title;
        NSString *rate = [self.nowPlayingMovies[indexPath.row].rate stringValue];
        cell.movireRatingLabel.text = rate;
        
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            NSString *imageURL = @"https://image.tmdb.org/t/p/w500/";
            imageURL = [imageURL stringByAppendingString:self.nowPlayingMovies[indexPath.row].imageURL];
            
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
    
    if (section == 0) {
        return _popularMovies.count;
    } else {
        return _nowPlayingMovies.count;
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
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
//    if (indexPath.section == 0) {
//        movie = movieArray[indexPath.row];
//    } else {
//        movie = movieArray[indexPath.row];
//    }
    [self performSegueWithIdentifier:@"GoToDetail" sender: nil];
    
}
@end
