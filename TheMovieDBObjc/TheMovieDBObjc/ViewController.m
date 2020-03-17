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

@interface ViewController () <UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *movieArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray<Movie *> *movies;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self arraySetUp];
    [self fetchMoviesUsingJSON];
}

- (void) setupMovies {
    self.movies = NSMutableArray.new;
}

- (void) fetchMoviesUsingJSON {
    NSLog(@"Fetching Movies...");
    
    NSString *urlString = @"https://api.themoviedb.org/3/discover/movie?api_key=ca01e6658836c07edbe8b8ce2ac738c1&language=pt-BR&sort_by=popularity.desc&include_adult=false&include_video=false&page=1";
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
        
        self.movies = movies;
        
        NSLog(@"Finished fetching courses!");
        
        for (Movie *movie in movies) {
            NSLog(@"%@", movie.title);
        }
        
    }] resume];
}




- (void)arraySetUp {
    movieArray = [NSMutableArray arrayWithArray: @[@"1",@"2",@"3",@"4",@"5",@"6",@"7"]];
}

#pragma mark - UITableView Delegate, DataSource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
//    static NSString *cellID = @"cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//
   static NSString *simpleTableIdentifier = @"cell";
    
       TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
       if (cell == nil)
       {
           NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SimpleTableCell" owner:self options:nil];
           cell = [nib objectAtIndex:0];
       }
    cell.movieDescriptionLabel.text = @"Gustavo, coloca aqui a descrição";
    cell.movieImage.image = [UIImage imageNamed:[movieArray objectAtIndex:indexPath.row]]; //[nomeDoArrayDeFilmes objectAtIndex:indexPath.row]
    cell.movieTitle.text = @"titulo do filme, por gentileza";
    cell.movireRatingLabel.text = @"nota";

    
       return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    
    return movieArray.count;

}

@end
