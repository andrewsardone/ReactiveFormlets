//
//  RAFTableForm.m
//  ReactiveFormlets
//
//  Created by Jon Sterling on 6/12/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import <ReactiveFormlets/RAFTableForm.h>
#import <ReactiveFormlets/RAFTableSection.h>
#import <ReactiveFormlets/RAFInputRow.h>

@implementation RAFTableForm

- (UITableView *)buildView {
	UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
	tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	tableView.backgroundColor = [UIColor colorWithWhite:0.94f alpha:1.f];
	tableView.dataSource = self;
	tableView.delegate = self;
	return tableView;
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [[(self.allValues)[indexPath.section] allValues][indexPath.row] height];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [(self.allValues)[section] title];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [(self.allValues)[section] numberOfRows];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [(self.allValues)[indexPath.section] cellForRow:indexPath.row];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	[[(self.allValues)[indexPath.section] allValues][indexPath.row] willDisplayCell:cell];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	RAFInputRow *row = [self.allValues[indexPath.section] allValues][indexPath.row];
	[row.rowWasSelected execute:row];
}

@end


@implementation RAFSingleSectionTableForm

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [self.allValues[indexPath.row] height];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.allValues.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	RAFInputRow *row = self.allValues[indexPath.row];
	UITableViewCell *cell = row.cell;
	[row willDisplayCell:row.cell];
	return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	RAFInputRow *row = self.allValues[indexPath.row];
	[row willDisplayCell:cell];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	RAFInputRow *row = self.allValues[indexPath.row];
	[row.rowWasSelected execute:row];
}

@end
