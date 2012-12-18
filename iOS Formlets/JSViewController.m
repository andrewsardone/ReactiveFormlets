//
//  JSViewController.m
//  iOS Formlets
//
//  Created by Jon Sterling on 6/2/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "JSViewController.h"
#import "RFFormlet.h"
#import "RFTableForm.h"
#import "RFInputRow.h"
#import "RFTableSection.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@protocol Animal <RFFormlet>
- (id<Text>)name;
- (id<Text>)nickName;
- (id<Text>)favoriteFood;
- (id<Animal>)friend;
- (id<Number>)age;
+ (instancetype)name:(id<Text>)name nickName:(id<Text>)nickName favoriteFood:(id<Text>)food age:(id<Number>)age;
+ (instancetype)name:(id<Text>)name nickName:(id<Text>)nickName friend:(id<Animal>)friend;
@end

@protocol Pets <RFFormlet>
- (id<Animal>)dog;
- (id<Animal>)cat;
+ (instancetype)dog:(id<Animal>)dog cat:(id<Animal>)cat;
@end

@implementation JSViewController {
    RFTableForm <Pets> *_form;
}

- (void)loadView
{
    Class AnimalModel = [RFReifiedProtocol model:@protocol(Animal)];
    id<Animal> tucker = [AnimalModel name:@"Tucker"
                                 nickName:@"Tuckey"
                             favoriteFood:@"kibbles"
                                      age:@6];
    
    RFInputRow<Text> *textRow = [RFInputRow text];
    RFInputRow<Number> *numberRow = [RFInputRow number];

    Class AnimalSection = [RFTableSection model:@protocol(Animal)];
    RFTableSection <Animal> *animalSection = [AnimalSection name:[textRow placeholder:@"name"]
                                                        nickName:[textRow placeholder:@"nickname"]
                                                    favoriteFood:[textRow placeholder:@"food"]
                                                             age:[numberRow placeholder:@"age"]];

    Class PetsTable = [RFTableForm model:@protocol(Pets)];
    _form = [PetsTable dog:[[animalSection title:@"Doggy"] withValue:tucker]
                       cat:[animalSection title:@"Kitty"]];

    RAC(self.title) = _form.dog.name;

    self.view = _form.view;
}

@end
