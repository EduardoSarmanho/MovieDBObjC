//
//  DetailViewController.m
//  TheMovieDBObjc
//
//  Created by Eduardo Sarmanho on 18/03/20.
//  Copyright © 2020 Eduardo Sarmanho. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController (){
 NSMutableArray *movieArray;
    __weak IBOutlet UIImageView *movieImage;
    __weak IBOutlet UILabel *movieTitleLabel;
    __weak IBOutlet UILabel *MovieCategoriesLabel;
    __weak IBOutlet UITextView *movieDescriptionTextView;
    __weak IBOutlet UILabel *rateLabel;
}
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    movieImage.image = [UIImage imageNamed:[_movie.imageURL];
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSString *imageURL = @"https://image.tmdb.org/t/p/w500/";
        imageURL = [imageURL stringByAppendingString:self.movie.posterPath];
        
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imageURL]];
        if ( data == nil )
            return;
        dispatch_async(dispatch_get_main_queue(), ^{
            self->movieImage.image = [UIImage imageWithData:data];
        });
    });
    movieTitleLabel.text = _movie.title;
    MovieCategoriesLabel.text = _movie.category;
    movieDescriptionTextView.text = _movie.overview;
    NSString *rate = [self.movie.rating stringValue];
    rateLabel.text = rate;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
