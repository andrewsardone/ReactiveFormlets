//
//  JSViewController.m
//  ReactiveCocoa
//
//  Created by Jon Sterling on 6/2/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "JSViewController.h"
#import "RAFFormlet.h"
#import "RAFTableForm.h"
#import "RAFInputRow.h"
#import "RAFTableSection.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@protocol Animal <RAFModel>
- (id<Text>)name;
- (id<Text>)nickName;
- (id<Text>)favoriteFood;
- (id<Number>)age;
+ (instancetype)name:(id<Text>)name nickName:(id<Text>)nickName favoriteFood:(id<Text>)food age:(id<Number>)age;
@end

@protocol Pets <RAFModel>
- (id<Animal>)dog;
- (id<Animal>)cat;
+ (instancetype)dog:(id<Animal>)dog cat:(id<Animal>)cat;
@end

@implementation JSViewController {
	RAFTableForm <Pets> *_form;
}

- (void)loadView {
	Class AnimalModel = [RAFReifiedProtocol model:@protocol(Animal)];
	id<Animal> tucker = [AnimalModel name:@"Tucker"
								 nickName:@"Tuckey"
							 favoriteFood:@"kibbles"
									  age:@6];

	RAFTextInputRow *textRow = [RAFTextInputRow new];
	RAFNumberInputRow *numberRow = [RAFNumberInputRow new];

	Class AnimalSection = [RAFTableSection model:@protocol(Animal)];
	RAFTableSection <Animal> *animalSection = [AnimalSection name:[textRow placeholder:@"name"]
														nickName:[textRow placeholder:@"nickname"]
													favoriteFood:[textRow placeholder:@"food"]
															 age:[numberRow placeholder:@"age"]];

	Class PetsTable = [RAFTableForm model:@protocol(Pets)];
	_form = [PetsTable dog:[[animalSection title:@"Doggy"] update:tucker]
					   cat:[animalSection title:@"Kitty"]];

	RAC(self.title) = _form.dog.name;
	[_form.dog.rf_signal subscribeNext:^(id x) {
		NSLog(@"%@", x);
	}];

	self.view = _form.view;
}

@end
