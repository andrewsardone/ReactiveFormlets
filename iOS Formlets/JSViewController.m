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
#import "RFMenuRow.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@protocol Animal <RFFormlet>
@property (readonly) id <Text> name;
@property (readonly) id <Text> nickName;
@property (readonly) id <Text> favoriteFood;
@property (readonly) id <Animal> friend;
@property (readonly) id <Number> age;
+ (instancetype)name:(id <Text>)name nickName:(id <Text>)nickName favoriteFood:(id <Text>)food age:(id <Number>)age;
+ (instancetype)name:(id <Text>)name nickName:(id <Text>)nickName friend:(id <Animal>)friend;
@end

@protocol Pets <RFFormlet>
@property (strong, readonly) id <Animal> dog;
@property (strong, readonly) id <Animal> cat;
+ (instancetype)dog:(id<Animal>)dog cat:(id<Animal>)cat;
@end

@interface JSViewController () <JSMenuRowDelegate>
@end

@implementation JSViewController {
    RFTableForm <Pets> *_form;
}

- (void)loadView
{
    Class AnimalModel = [RFReifiedProtocol model:@protocol(Animal)];
    id <Animal> rover = [AnimalModel name:@"Rover"
                                 nickName:@"Peanut"
                             favoriteFood:@"kibbles"
                                      age:@6];
    id <Animal> tucker = [AnimalModel name:@"Tucker"
                                  nickName:@"Tuckey"
                                    friend:rover];

    RFInputRow <Text> *textRow = [RFInputRow text];

    Class AnimalMenu = [RFMenuRow model:@protocol(Animal)];
    RFMenuRow <Animal> *animalMenu = [AnimalMenu name:[textRow placeholder:@"name"]
                                             nickName:[textRow placeholder:@"nickname"]
                                         favoriteFood:[textRow placeholder:@"favoriteFood"]
                                                  age:[[RFInputRow number] placeholder:@"age"]];
    animalMenu.delegate = self;

    Class AnimalSection = [RFTableSection model:@protocol(Animal)];
    RFTableSection <Animal> *animalSection = [AnimalSection name:[textRow placeholder:@"name"]
                                                        nickName:[textRow placeholder:@"nickname"]
                                                          friend:[animalMenu withTitle:@"friend"]];

    Class PetsTable = [RFTableForm model:@protocol(Pets)];
    _form = [PetsTable dog:[[animalSection title:@"Doggy"] withValue:tucker]
                       cat:[animalSection title:@"Kitty"]];

    [self rac_bind:@selfpath(title) to:[_form.dog.friend select:^(id <Animal> buddy) {
        return [NSString stringWithFormat:@"%@ is %@", buddy.name, buddy.age];
    }]];

    [_form.dog subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];

    self.view = _form.view;
}


#pragma mark - JSMenuRowDelegate

- (void)menuRow:(RFMenuRow *)row displayViewController:(UITableViewController *)controller
{
    [self.navigationController pushViewController:controller animated:YES];
}

@end
