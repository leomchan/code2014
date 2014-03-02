//
//  CODEMapViewController.m
//  CODE2014
//
//  Created by Allan Chu on 2014-03-01.
//  Copyright (c) 2014 Nobis Studios. All rights reserved.
//

#import "CODEMapViewController.h"
#import "CODEDataManager.h"
#import "CODECalloutView.h"
#import "CODECharityInformationViewController.h"
#import "TTTOrdinalNumberFormatter.h"

NSString * const CODEMapViewControllerCountryAnnotationIdentifier = @"country";
NSString * const CODEMapViewControllerPushToInfoSegueIdentifier = @"CODEPushToInfo";
NSString * const CODEMapViewControllerPushToListSegueIdentifier = @"CODEPushToList";
NSString * const CODEMapViewControllerPushToCharitySegueIdentifier = @"CODEPushToCharities";

NSTimeInterval const CODEMapViewControllerFadeDuration = 0.5;

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

#pragma mark - Annotation

@interface CODEAnnotation : NSObject <MKAnnotation>
@property (nonatomic)CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic,strong) PFObject *countryInfo;
@end

@implementation CODEAnnotation
@end

@interface CODEAnnotationView : MKAnnotationView
@property(nonatomic,strong) UIImage *postImage;
@property(nonatomic,strong) UIColor *pinColor;
@property(nonatomic,assign) BOOL blink;

- (void)fadeIn;
- (void)fadeOut;

@end

@implementation CODEAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0.0f, 0.0f, 30.0f, 40.0f);
        self.backgroundColor = [UIColor clearColor];
        self.postImage = [UIImage imageNamed:@"post.png"];
        self.centerOffset = CGPointMake(10.0f, -16.0f);
        self.pinColor = [UIColor redColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self.postImage drawInRect:CGRectMake(2.0f, 18.0f, 28.0f, 31.0f)];
    
    CGContextSetFillColorWithColor(context, self.pinColor.CGColor);
    CGContextFillEllipseInRect(context, CGRectMake(0.0f, 10.0f, 13.0f, 13.0f));
    
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillEllipseInRect(context, CGRectMake(3.0f, 12.0f, 3.0f, 3.0f));
}

- (void)setBlink:(BOOL)blink
{
    if (_blink != blink) {
        _blink = blink;
        
        self.alpha = 1.0f;
        if (blink) {
            [self fadeOut];
        }
    }
}

- (void)fadeOut
{
    [UIView animateWithDuration:CODEMapViewControllerFadeDuration
                          delay:0.0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^(void) {
                         self.alpha = 0.2f;
                     }
                     completion:^(BOOL finished) {
                         if (self.blink) {
                             [self fadeIn];
                         }
                         else {
                             self.alpha = 1.0f;
                         }
                     }];
}

- (void)fadeIn
{
    [UIView animateWithDuration:CODEMapViewControllerFadeDuration
                          delay:0.0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^(void) {
                         self.alpha = 1.0f;
                     }
                     completion:^(BOOL finished) {
                         if (self.blink) {
                             [self fadeOut];
                         }
                     }];
}

@end
/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

#pragma mark - Map View Controller

@interface CODEMapViewController ()
@property (nonatomic, strong) NSMutableArray *arrayOfCountries;
@property (nonatomic,assign) double maxContributions;
@property (nonatomic,strong) NSArray *calloutViews;

- (void)infoTapped:(id)sender;
@end

@implementation CODEMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.arrayOfCountries  = [NSMutableArray array];
    
    [self.mapView setZoomEnabled:YES];
    [[CODEDataManager manager] getApplicableCountriesWithBlock:^(NSArray *items, NSError *error) {
        
        self.arrayOfCountries = [NSMutableArray arrayWithArray:items];
        self.maxContributions = 0.0;
        
        NSMutableArray *annotationsToAdd = [NSMutableArray array];
        for (PFObject *object in self.arrayOfCountries){
            PFGeoPoint *geoPoint = object[@"location"];
            if (geoPoint != nil){
                CODEAnnotation *annotation = [[CODEAnnotation alloc] init];
                annotation.coordinate = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude);

                annotation.countryInfo = object;
                NSNumber *totalContributions = object[@"totalContributions"];
                if (totalContributions) {
                    self.maxContributions = MAX(self.maxContributions, [totalContributions doubleValue]);
                }
                
                annotation.title = [object[@"englishName"] capitalizedString];
                [annotationsToAdd addObject:annotation];
            }
        }
        
        [self.mapView addAnnotations:annotationsToAdd];
    }];
    
    
    
	// Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   /*
    if (self.selectedObject != nil){
        
        PFGeoPoint *geoPoint = self.selectedObject[@"location"];
        CLLocationCoordinate2D track;
        track.latitude = geoPoint.latitude;
        track.longitude = geoPoint.longitude;
        
        MKCoordinateRegion region;
        MKCoordinateSpan span;
        span.latitudeDelta = 5;
        span.longitudeDelta = 5;
        region.span = span;
        region.center = track;
        [self.mapView setRegion:region];
    }
    */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

#pragma mark - Map View

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    CODEAnnotationView *annotationView = (CODEAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:CODEMapViewControllerCountryAnnotationIdentifier];
    if (!annotationView) {
        annotationView = [[CODEAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:CODEMapViewControllerCountryAnnotationIdentifier];
    }
    else {
        annotationView.annotation = annotation;
    }
    
    CODEAnnotation *customAnnotation = ((CODEAnnotation *)annotation);
    double value = [customAnnotation.countryInfo[@"totalContributions"] doubleValue];
    value = MIN(MAX(0.0f, value), self.maxContributions);
    double t = value / self.maxContributions;
    annotationView.pinColor = [UIColor colorWithHue:0.6f - 0.33f * t
                                         saturation:0.8f
                                         brightness:0.95f
                                              alpha:1.0f];
    
    if ([customAnnotation.countryInfo[@"trending"] boolValue]) {
        annotationView.blink = YES;
    }
    else {
        annotationView.blink = NO;
    }
    
    [annotationView setNeedsDisplay];
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    self.selectedObject = ((CODEAnnotation *) view.annotation).countryInfo;
    [self performSegueWithIdentifier:CODEMapViewControllerPushToCharitySegueIdentifier sender:self];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    const CGFloat centerOffset = 8.0f;
    const CGFloat spacingFromEdge = 8.0f;

    CODECalloutView *calloutView = [[[NSBundle mainBundle] loadNibNamed:@"CODECalloutView" owner:self options:nil] objectAtIndex:0];
    UIImageView *calloutArrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"callout-arrow.png"]];
    
    CGRect arrowFrame = calloutArrowImageView.frame;
    CGRect calloutFrame = calloutView.frame;

    CGSize calloutSize = CGSizeMake(calloutFrame.size.width, calloutFrame.size.height + arrowFrame.size.height);
    
    // Does it fit above?
    if (view.frame.origin.y - calloutSize.height > spacingFromEdge) {
        calloutFrame.origin = CGPointMake(-calloutFrame.size.width / 2.0f + centerOffset, -calloutFrame.size.height - arrowFrame.size.height);
        calloutView.frame = calloutFrame;
        
        arrowFrame.origin = CGPointMake(-arrowFrame.size.width / 2.0f + centerOffset, -arrowFrame.size.height - 1.0f);
        calloutArrowImageView.frame = arrowFrame;
    }
    else {
        calloutArrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"callout-arrow-top.png"]];
        calloutFrame.origin = CGPointMake(-calloutFrame.size.width / 2.0f + centerOffset, arrowFrame.size.height + view.frame.size.height);
        calloutView.frame = calloutFrame;
        
        arrowFrame.origin = CGPointMake(-arrowFrame.size.width / 2.0f + centerOffset, 1.0f + view.frame.size.height);
        calloutArrowImageView.frame = arrowFrame;
    }
    
    PFObject *countryInfo = ((CODEAnnotation *)view.annotation).countryInfo;
    self.selectedObject = countryInfo;
    
    calloutView.countryLabel.text = [countryInfo[@"englishName"] uppercaseString];
    
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    currencyFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    currencyFormatter.usesGroupingSeparator = YES;
    
    calloutView.donationAmountLabel.text = [currencyFormatter stringFromNumber:countryInfo[@"totalContributions"]];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    numberFormatter.usesGroupingSeparator = YES;
    
    calloutView.charitiesLabel.text = [numberFormatter stringFromNumber:countryInfo[@"numPrograms"]];
    
    TTTOrdinalNumberFormatter *ordinalFormatter = [[TTTOrdinalNumberFormatter alloc] init];
    [ordinalFormatter setLocale:[NSLocale currentLocale]];
    [ordinalFormatter setGrammaticalGender:TTTOrdinalNumberFormatterMaleGender];
    
    calloutView.rankLabel.text = [ordinalFormatter stringFromNumber:countryInfo[@"contributionRank"]];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(infoTapped:)];
    [calloutView.infoButton addGestureRecognizer:tapGestureRecognizer];
    
    calloutView.frame = [view.superview convertRect:calloutView.frame fromView:view];
    [view.superview addSubview:calloutView];
    
    calloutArrowImageView.frame = [view.superview convertRect:calloutArrowImageView.frame fromView:view];
    [view.superview addSubview:calloutArrowImageView];
    
    self.calloutViews = @[calloutView, calloutArrowImageView];
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    for (UIView *subview in self.calloutViews) {
        [subview removeFromSuperview];
    }
    
    self.calloutViews = nil;
}

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

#pragma mark - Storyboard
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:CODEMapViewControllerPushToListSegueIdentifier]){
        CODEListViewController *controller = segue.destinationViewController;
        controller.delegate = self;
    }else if ([segue.identifier isEqualToString:CODEMapViewControllerPushToCharitySegueIdentifier]){
        CODECharityInformationViewController *controller = segue.destinationViewController;
        controller.selectedCountry = self.selectedObject;
    }
}

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

#pragma mark - CODEListViewControllerDelegate

- (void)listViewController:(CODEListViewController *)controller didSelectCountryInfo:(PFObject *)countryInfo
{
    self.selectedObject = countryInfo;
}

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

#pragma mark - Actions

- (void)infoTapped:(id)sender
{
    CODEDebugLog(@"hello?");
    if (self.selectedObject) {
        [self performSegueWithIdentifier:CODEMapViewControllerPushToCharitySegueIdentifier sender:self];
    }
}

@end
