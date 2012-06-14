//
//  JSTableForm.h
//  iOS Formlets
//
//  Created by Jon Sterling on 6/12/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "ValidatingFormlet.h"

// Many JSTableSection
@interface JSTableForm : ValidatingFormlet
- (UITableView *)view;
@end

// Many JSTableRow
@interface JSSingleSectionTableForm : JSTableForm
@end
