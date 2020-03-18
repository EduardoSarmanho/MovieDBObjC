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
}
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    movieImage.image = [UIImage imageNamed:[_movie.imageURL];
    movieTitleLabel.text = _movie.title;
    MovieCategoriesLabel.text = _movie.category;
    movieDescriptionTextView.text = _movie.description;
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
