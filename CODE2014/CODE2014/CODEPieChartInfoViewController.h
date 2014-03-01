//
//  CODEPieChartInfoViewController.h
//  CODE2014
//
//  Created by Allan Chu on 2014-03-01.
//  Copyright (c) 2014 Nobis Studios. All rights reserved.
//

#import "CODEBaseViewController.h"

@interface CODEPieChartInfoViewController : CODEBaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *pieTableView;

@end
