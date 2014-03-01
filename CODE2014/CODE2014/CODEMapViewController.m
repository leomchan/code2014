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

NSString * const CODEMapViewControllerCountryAnnotationIdentifier = @"country";
NSString * const CODEMapViewControllerPushToInfoSegueIdentifier = @"CODEPushToInfo";
NSString * const CODEMapViewControllerPushToListSegueIdentifier = @"CODEPushToList";

@interface CODEMapViewController ()
@property (nonatomic, strong) NSMutableArray *arrayOfCountries;
@end

@interface CODEAnnotation : NSObject <MKAnnotation>
@property (nonatomic)CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@end

@implementation CODEAnnotation
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
        
        NSMutableArray *annotationsToAdd = [NSMutableArray array];
        for (PFObject *object in self.arrayOfCountries){
            PFGeoPoint *geoPoint = object[@"location"];
            if (geoPoint != nil){
                CODEAnnotation *annotation = [[CODEAnnotation alloc] init];
                annotation.coordinate = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude);
                CODEDebugLog(@"%@",object);
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
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:CODEMapViewControllerCountryAnnotationIdentifier];
    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:CODEMapViewControllerCountryAnnotationIdentifier];
    }
    else {
        annotationView.annotation = annotation;
    }
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:CODEMapViewControllerPushToInfoSegueIdentifier sender:self];
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
    
    [view addSubview:calloutView];
    [view addSubview:calloutArrowImageView];
    
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    for (UIView *subview in view.subviews) {
        [subview removeFromSuperview];
    }
}

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

#pragma mark - Storyboard
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:CODEMapViewControllerPushToListSegueIdentifier]){
        CODEListViewController *controller = segue.destinationViewController;
        controller.delegate = self;
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

@end
