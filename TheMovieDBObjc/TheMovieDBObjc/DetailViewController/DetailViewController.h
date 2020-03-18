//
//  DetailViewController.h
//  TheMovieDBObjc
//
//  Created by Eduardo Sarmanho on 18/03/20.
//  Copyright © 2020 Eduardo Sarmanho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailViewController : UIViewController 
    @property (strong, nonatomic)  Movie *movie;



@end

NS_ASSUME_NONNULL_END
