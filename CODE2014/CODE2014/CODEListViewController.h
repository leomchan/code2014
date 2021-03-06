//
//  CODEViewController.h
//  CODE2014
//
//  Created by Allan Chu on 2014-02-28.
//  Copyright (c) 2014 Nobis Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CODEBaseViewController.h"

@class CODEListViewController;

@protocol CODEListViewControllerDelegate <NSObject>

- (void)listViewController:(CODEListViewController *)controller didSelectCountryInfo:(PFObject *)countryInfo;

@end

@interface CODEListViewController : CODEBaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *mainTableView;
@property (nonatomic, weak) id<CODEListViewControllerDelegate> delegate;

@end
