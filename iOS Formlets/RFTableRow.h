//
//  RFTableRow.h
//  iOS Formlets
//
//  Created by Jon Sterling on 6/13/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "RFFormlet.h"

@protocol RFTableRow <RFFormlet>
@property (strong, readonly) UITableViewCell *cell;
- (void)rowWasSelected;
@end
