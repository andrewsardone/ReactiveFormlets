//
//  JSInputRow.h
//  iOS Formlets
//
//  Created by Jon Sterling on 6/12/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "RFTableRow.h"

// JSInputRow is a table row with a text field.
@interface RFInputRow : RFFormlet <RFTableRow, Text, Number>
- (instancetype)placeholder:(NSString *)placeholder;
@end
