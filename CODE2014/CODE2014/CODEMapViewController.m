//
//  CODEMapViewController.m
//  CODE2014
//
//  Created by Allan Chu on 2014-03-01.
//  Copyright (c) 2014 Nobis Studios. All rights reserved.
//

#import "CODEMapViewController.h"

@interface CODEMapViewController ()

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
    if (self.selectedPlacemark != nil){
        [self.mapView setCenterCoordinate:[self.selectedPlacemark.location coordinate] animated:NO];
        MKCoordinateRegion region;
        [self.mapView setZoomEnabled:YES];
        region.center.latitude = self.selectedPlacemark.location.coordinate.latitude;
        region.center.longitude = self.selectedPlacemark.location.coordinate.latitude;
        region.span.latitudeDelta = 5;
        region.span.longitudeDelta = 5;
       // self.mapView.region = region;
        
        CODEAnnotation *annotation = [[CODEAnnotation alloc] init];
        annotation.coordinate = self.selectedPlacemark.location.coordinate;
        annotation.title = @"TEST";
        [self.mapView addAnnotation:annotation];
    }
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"loc"];
    annotationView.canShowCallout = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return annotationView;
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"CODEPushToInfo" sender:self];
}
@end
