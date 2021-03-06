//
//  ScreeningDetailViewController.m
//  Reeel
//
//  Created by Paul Dariye on 4/19/15.
//  Copyright (c) 2015 colp. All rights reserved.
//

#import "ScreeningDetailViewController.h"
#import "KINWebBrowserViewController.h"
#import "RSVPDetailViewController.h"
#import <FXBlurView/FXBlurView.h>
#import "UIColor+BFPaperColors.h"


@interface ScreeningDetailViewController () <UINavigationControllerDelegate, UIScrollViewDelegate>
@property (strong, nonatomic) UIImageView *screeningImageView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *scrollContentView;
@property (strong, nonatomic) UIImageView *gradientImageView;
@property (strong, nonatomic) UIImageView *upIconImageView;
@property (strong, nonatomic) UIButton *rsvpButton;
@property (strong, nonatomic) FXBlurView *blurScreeningImageView;
@property (assign, nonatomic) CGFloat lastContentOffset;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *synopsisLabel;
@property (strong, nonatomic) UILabel *metaLabel;
@property (strong, nonatomic) UILabel *directorsLabel;
@property (strong, nonatomic) UILabel *starsLabel;
@property (strong, nonatomic) UIButton *urlButton;
//@property (strong, nonatomic) UILabel *terms;

@end

@implementation ScreeningDetailViewController

@synthesize screening = _screening;
@synthesize scrollView = _scrollView;


- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
    }
    return _scrollView;
}

- (void)rsvpButtonPressed
{
    RSVPDetailViewController *rsvpDetail = [[RSVPDetailViewController alloc] init];
    
    rsvpDetail.screening = self.screening;
    
    [self.navigationController pushViewController:rsvpDetail animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat y = scrollView.contentOffset.y;
    
    if (self.lastContentOffset > scrollView.contentOffset.y) {
        self.blurScreeningImageView.alpha = y / ([UIScreen mainScreen].bounds.size.height * 0.65);
        self.gradientImageView.alpha = y / ([UIScreen mainScreen].bounds.size.height * 0.5);
        self.upIconImageView.alpha = 0.0;
    } else if (self.lastContentOffset < scrollView.contentOffset.y) {
        self.gradientImageView.alpha = ([UIScreen mainScreen].bounds.size.height)/y;
        self.upIconImageView.alpha = ([UIScreen mainScreen].bounds.size.height * 0.5)/y;
    }
    self.lastContentOffset = scrollView.contentOffset.y;

    
}

- (void)initContent
{
    UIImage *gradient = [UIImage imageNamed:@"gradient"];
    self.gradientImageView = [[UIImageView alloc] initWithImage:gradient];
    self.gradientImageView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 1.70);
    self.gradientImageView.clipsToBounds = YES;
    self.gradientImageView.tintColor = [UIColor blackColor];
    self.gradientImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.scrollView addSubview:self.gradientImageView];
    
    UIImage *upIconImage = [UIImage imageNamed:@"up"];
    self.upIconImageView = [[UIImageView alloc] initWithImage:upIconImage];
    self.upIconImageView.frame = CGRectMake((self.scrollView.bounds.size.width - self.upIconImageView.frame.size.width)/2.0, [UIScreen mainScreen].bounds.size.height - 280, 25, 15);
    [self.scrollView addSubview:self.upIconImageView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, [UIScreen mainScreen].bounds.size.height - 250, [UIScreen mainScreen].bounds.size.width - 50, 21)];
    
    NSDateFormatter *year = [[NSDateFormatter alloc] init];
    [year setDateFormat:@"yyyy"];

    self.titleLabel.text = [NSString stringWithFormat:@"%@ (%@)", [self.screening objectForKey:@"screeningTitle"], [year stringFromDate:[self.screening objectForKey:@"screeningReleaseDate"]]];
    self.titleLabel.font = [UIFont systemFontOfSize:30];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.numberOfLines = 0;
    [self.titleLabel sizeToFit];
    [self.scrollView addSubview:self.titleLabel];
    
    self.metaLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, [UIScreen mainScreen].bounds.size.height - 205, [UIScreen mainScreen].bounds.size.width - 50, 21)];
    self.metaLabel.text = [NSString stringWithFormat:@"%@ | %@ | %@", [self.screening objectForKey:@"screeningContentRating"], [self.screening objectForKey:@"screeningDuration"], [self.screening objectForKey:@"screeningGenre"]];
    self.metaLabel.textColor = [UIColor whiteColor];
    self.metaLabel.numberOfLines = 0;
    [self.metaLabel sizeToFit];
    [self.scrollView addSubview:self.metaLabel];
    
    UIImageView *horizonatalLine = [[UIImageView alloc] initWithFrame:CGRectMake(25, [UIScreen mainScreen].bounds.size.height - 180, self.metaLabel.frame.size.width, 1)];
    horizonatalLine.backgroundColor = [UIColor lightTextColor];
    [self.scrollView addSubview:horizonatalLine];
    
    
    self.synopsisLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, [UIScreen mainScreen].bounds.size.height - 160, [UIScreen mainScreen].bounds.size.width - 50, 21)];
    self.synopsisLabel.text = [self.screening objectForKey:@"screeningSynopsis"];
    self.synopsisLabel.textColor = [UIColor whiteColor];
    self.synopsisLabel.numberOfLines = 0;
    [self.synopsisLabel sizeToFit];
    [self.scrollView addSubview:self.synopsisLabel];
    
    CGFloat height = [self.synopsisLabel.text boundingRectWithSize:CGSizeMake(self.synopsisLabel.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:nil context:nil].size.height;
    
    self.directorsLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, self.synopsisLabel.frame.origin.y + height*2.6, [UIScreen mainScreen].bounds.size.width - 50, 21)];
    self.directorsLabel.text = [NSString stringWithFormat:@"Director(s): %@", [self.screening objectForKey:@"screeningDirectorInfo"]];
    self.directorsLabel.textColor = [UIColor whiteColor];
    self.directorsLabel.numberOfLines = 0;
    [self.directorsLabel sizeToFit];
    [self.scrollView addSubview:self.directorsLabel];
    
    height = [self.directorsLabel.text boundingRectWithSize:CGSizeMake(self.directorsLabel.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:nil context:nil].size.height;
    
    self.starsLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, self.directorsLabel.frame.origin.y +  height*2, [UIScreen mainScreen].bounds.size.width - 50, 21)];
    self.starsLabel.text = [NSString stringWithFormat:@"Star(s): %@", [self.screening objectForKey:@"screeningStarInfo"]];
    self.starsLabel.textColor = [UIColor whiteColor];
    self.starsLabel.numberOfLines = 0;
    [self.starsLabel sizeToFit];
    [self.scrollView addSubview:self.starsLabel];
    
    height = [self.starsLabel.text boundingRectWithSize:CGSizeMake(self.starsLabel.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:nil context:nil].size.height;
    
    
    self.urlButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    self.urlButton.frame = CGRectMake(25, self.starsLabel.frame.origin.y + height*2.3, 200, 40);
    [self.urlButton setTitle:@"" forState:UIControlStateNormal];
    [self.urlButton setContentMode:UIViewContentModeScaleAspectFit];
    [self.urlButton addTarget:self action:@selector(moreInfoButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.urlButton.center = CGPointMake(35, self.starsLabel.frame.origin.y + height*2.3);
    if ([self.screening objectForKey:@"screeningLink"]) {
        [self.scrollView addSubview:self.urlButton];
    }
    
    self.rsvpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rsvpButton.frame = CGRectMake(25, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width - 50, 80);
    [self.rsvpButton setContentMode:UIViewContentModeScaleAspectFit];
    [self.rsvpButton setClipsToBounds:YES];
    //Check if user has Rsvped for this
    PFQuery *guestlistQuery = [PFQuery queryWithClassName:@"GuestList"];
    [guestlistQuery whereKey:@"user" equalTo:[PFUser currentUser]];
    [guestlistQuery whereKey:@"screening" equalTo:self.screening];
    if ([guestlistQuery getFirstObject]) {
        [self.rsvpButton setBackgroundColor:[UIColor paperColorGreen600]];
        [self.rsvpButton setTitle:@"Change RSVP" forState:UIControlStateNormal];
    }else {
        [self.rsvpButton setBackgroundColor:[UIColor paperColorRed600]];
        [self.rsvpButton setTitle:@"RSVP" forState:UIControlStateNormal];
    }
    [self.rsvpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.rsvpButton.titleLabel setFont:[UIFont systemFontOfSize:30]];
    self.rsvpButton.layer.shadowOpacity = 0.3;
    self.rsvpButton.layer.shadowRadius = 2.0f;
    self.rsvpButton.layer.cornerRadius = 2.0f;
//    self.rsvpButton.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height  + ([UIScreen mainScreen].bounds.size.height * 0.32));
    
    self.rsvpButton.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, self.starsLabel.frame.origin.y + height*4.6);
//    
    [self.rsvpButton addTarget:self action:@selector(rsvpButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self.scrollView addSubview:self.rsvpButton];
    
    [self.scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight ];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initContent];
    [self.scrollView layoutIfNeeded];
}

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    self.navigationItem.title = [_screening objectForKey:@"screeningTitle"];
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareButtonPressed)];
    self.navigationItem.rightBarButtonItem = shareButton;
    
    self.gradientImageView.alpha = 1;
    
    // Set background color of view
    self.view.backgroundColor = [UIColor whiteColor];
    // Set assign image from assets
    PFFile *screeningPoster =  [_screening objectForKey:@"screeningPoster"];
    
    [screeningPoster getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error){
        if (!error) {
            self.screeningImageView.image = [UIImage imageWithData:imageData];
        }
        
    }];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.screeningImageView = backgroundImageView;
    [self.view addSubview:self.screeningImageView];
    
    self.blurScreeningImageView = [[FXBlurView alloc] initWithFrame:self.screeningImageView.frame];
    self.blurScreeningImageView.alpha = 0;
    [self.screeningImageView addSubview:self.blurScreeningImageView];

    self.scrollView.delegate = self;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 1.65);
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.scrollView];
}

-(void)shareButtonPressed
{
    NSString *text = [NSString stringWithFormat:@"Get FREE tickets for screening of %@", [self.screening objectForKey:@"screeningTitle"]];
    NSURL *screeningLink = [self.screening objectForKey:@"screeningLink"];
    
    NSArray *sharePayload = @[text, screeningLink];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:sharePayload applicationActivities:nil];
    
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo];
    
    activityVC.excludedActivityTypes = excludeActivities;
    
    [self.navigationController presentViewController:activityVC animated:YES completion:nil];
}

- (void)moreInfoButtonPressed
{
    KINWebBrowserViewController *webBrowser = [KINWebBrowserViewController webBrowser];
    [self.navigationController pushViewController:webBrowser animated:YES];
    
    [webBrowser loadURLString:[self.screening objectForKey:@"screeningLink"]];
    
    webBrowser.tintColor = [UIColor whiteColor];
    webBrowser.barTintColor = [UIColor paperColorRed];
    [webBrowser.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
//    webBrowser.navigationController.navigationBar.translucent = NO;
    webBrowser.actionButtonHidden = YES;
    webBrowser.showsURLInNavigationBar = NO;
    webBrowser.uiWebView.scrollView.showsVerticalScrollIndicator = NO;
    webBrowser.showsPageTitleInNavigationBar = YES;
    
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
