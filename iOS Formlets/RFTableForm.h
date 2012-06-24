//
//  RFTableForm.h
//  iOS Formlets
//
//  Created by Jon Sterling on 6/12/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "RFFormlet.h"

// Many RFTableSection
@interface RFTableForm : RFFormlet
- (UITableView *)view;
@end

// Many RFTableRow
@interface RFSingleSectionTableForm : RFTableForm
@end
