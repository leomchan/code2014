//
//  CODECharityInformationViewController.h
//  CODE2014
//
//  Created by Allan Chu on 2014-03-01.
//  Copyright (c) 2014 Nobis Studios. All rights reserved.
//

#import "CODEBaseViewController.h"

@interface CODECharityInformationViewController : CODEBaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) PFObject *selectedCountry;
@property (nonatomic, weak) IBOutlet UITableView * mainTableView;

@end
