//
//  RAFTableForm.h
//  ReactiveCocoa
//
//  Created by Jon Sterling on 6/12/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "RAFFormlet.h"

// Many RAFTableSection
@interface RAFTableForm : RAFCompoundFormlet
- (UITableView *)view;
@end

// Many RAFTableRow
@interface RAFSingleSectionTableForm : RAFTableForm
@end
