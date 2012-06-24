//
//  JSTableRow.h
//  iOS Formlets
//
//  Created by Jon Sterling on 6/13/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "Formlet.h"

@protocol JSTableRow <Formlet>
@property (strong, readonly) UITableViewCell *cell;
- (void)rowWasSelected;
@end
