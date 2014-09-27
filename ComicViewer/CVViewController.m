//
//  CVViewController.m
//  ComicViewer
//
//  Created by Damonique Thomas on 9/24/14.
//  Copyright (c) 2014 Damonique Thomas. All rights reserved.
//

#import "CVViewController.h"

@interface CVViewController () <UIScrollViewDelegate>

@end

@implementation CVViewController

@synthesize scrollView;
@synthesize imageView;


- (void)viewDidLoad
{
    [super viewDidLoad];
    //Scrolling
    self.scrollView.minimumZoomScale = 0.43;
    self.scrollView.maximumZoomScale = 6.0;
    self.scrollView.delegate = self;
    
    //Loads random comic from site
    self.alt = [[NSString alloc] init];
    self.comicList = [[NSNumber alloc] init];
    [self getRandomComic];
    
    //Buttons
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(getNextComic)];
    
    UIBarButtonItem *prevButton = [[UIBarButtonItem alloc] initWithTitle:@"Previous" style:UIBarButtonItemStyleBordered target:self action:@selector(getPrevComic)];
    
    self.navigationItem.rightBarButtonItem = nextButton;
    self.navigationItem.leftBarButtonItem = prevButton;
}

-(void)getRandomComic
{
    int comicNum = arc4random_uniform(1000);
    [self getComic:comicNum];
}

-(void)getNextComic
{
    int comicNum = [self.comicList intValue] + 1 ;
    [self getComic:comicNum];

}

-(void)getPrevComic
{
    int comicNum = [self.comicList intValue] - 1 ;
    [self getComic:comicNum];
}

-(void)getComic: (int)comicNum
{
    //JSON info
    NSString *url = @"http://xkcd.com/~/info.0.json";
    NSURL *jsonURL = [[NSURL alloc]initWithString:[url stringByReplacingOccurrencesOfString:@"~" withString:[NSString stringWithFormat:@"%d", comicNum]]];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:jsonURL];
    NSURLResponse *response;
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error: &error];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error: &error];
    self.json = json;
    if (error) {
        NSLog(@"Error: %@", error.localizedDescription);
    }
    NSString *title = json[@"safe_title"];
    NSString *imgStr = json[@"img"];
    NSString *num = json[@"num"];
    self.alt =json[@"alt"];
    self.comicList = [NSNumber numberWithInt:[num intValue]];
    NSLog(@"Num: @%d",[num intValue]);
    NSURL *url_img = [NSURL URLWithString:imgStr];
    NSData *data_img = [NSData dataWithContentsOfURL:url_img];
    UIImage *img = [[UIImage alloc] initWithData:data_img];
    self.navigationItem.title = title;
    
    //Image w/ Scrolling
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.image = img;
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(img.size.width+50, img.size.height+150)];
    self.imageView.contentMode = UIViewContentModeCenter;
    [self.imageView sizeToFit];
    int screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.scrollView.contentSize = self.imageView.image.size;
    
    if(img.size.width < screenWidth)
    {
        int horizontalOffset = (screenWidth - img.size.width)/2;
        self.imageView.frame = CGRectMake(horizontalOffset,0,img.size.width,img.size.height);
        self.scrollView.zoomScale = 1;
    }
//    else if(screenWidth/img.size.width >= self.scrollView.minimumZoomScale)
//    {
//        self.scrollView.zoomScale = screenWidth/img.size.width;
//    }
//    else
//    {
//        self.scrollView.zoomScale = self.scrollView.minimumZoomScale;
//    }
    
    self.imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *altTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(altAlert)];
    [self.imageView addGestureRecognizer:altTapRecognizer];

}

-(void)altAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:self.alt delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
