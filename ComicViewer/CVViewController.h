//
//  CVViewController.h
//  ComicViewer
//
//  Created by Damonique Thomas on 9/24/14.
//  Copyright (c) 2014 Damonique Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CVViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSDictionary *json;
@property (strong, nonatomic) NSNumber *comicList;
@property (strong, nonatomic) NSString *alt;
@property (strong, nonatomic) NSURLSession *session;


@end
