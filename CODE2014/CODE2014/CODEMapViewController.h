//
//  CODEMapViewController.h
//  CODE2014
//
//  Created by Allan Chu on 2014-03-01.
//  Copyright (c) 2014 Nobis Studios. All rights reserved.
//

#import "CODEBaseViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "CODEListViewController.h"

@interface CODEMapViewController : CODEBaseViewController<MKMapViewDelegate, CODEListViewControllerDelegate>

@property (nonatomic, strong) PFObject *selectedObject;
@property (nonatomic, weak) IBOutlet MKMapView * mapView;

@end
