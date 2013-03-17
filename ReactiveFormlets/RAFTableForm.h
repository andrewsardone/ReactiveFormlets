//
//  RAFTableForm.h
//  ReactiveFormlets
//
//  Created by Jon Sterling on 6/12/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveFormlets/RAFFormlet.h>

// Many RAFTableSection
@interface RAFTableForm : RAFCompoundFormlet <UITableViewDataSource, UITableViewDelegate>
- (UITableView *)buildView;
@end

// Many RAFTableRow
@interface RAFSingleSectionTableForm : RAFTableForm
@end
