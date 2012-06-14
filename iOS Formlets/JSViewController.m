//
//  JSViewController.m
//  iOS Formlets
//
//  Created by Jon Sterling on 6/2/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "JSViewController.h"
#import "Formlet.h"
#import "JSTableForm.h"
#import "JSInputRow.h"
#import "JSTableSection.h"
#import "JSMenuRow.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@protocol Animal <Formlet>
@property (readonly) id <Text> name;
@property (readonly) id <Text> nickName;
@property (readonly) id <Text> favoriteFood;
@property (readonly) id <Animal> friend;
@property (readonly) id <Number> age;
+ (instancetype)name:(id <Text>)name nickName:(id <Text>)nickName favoriteFood:(id <Text>)food age:(id <Number>)age;
+ (instancetype)name:(id <Text>)name nickName:(id <Text>)nickName friend:(id <Animal>)friend;
@end

@protocol Pets <Formlet>
@property (strong, readonly) id <Animal> dog;
@property (strong, readonly) id <Animal> cat;
+ (instancetype)dog:(id<Animal>)dog cat:(id<Animal>)cat;
@end

@interface JSViewController () <JSMenuRowDelegate>
@end

@implementation JSViewController {
    JSTableForm <Pets> *_form;
}

- (void)loadView
{
    Class AnimalModel = [JSReifiedProtocol model:@protocol(Animal)];
    id <Animal> rover = [AnimalModel name:@"Rover"
                                 nickName:@"Peanut"
                             favoriteFood:@"kibbles"
                                      age:[NSNumber numberWithInt:6]];
    id <Animal> tucker = [AnimalModel name:@"Tucker"
                                  nickName:@"Tuckey"
                                    friend:rover];

    JSInputRow <Text> *textRow = [[JSInputRow text] satisfies:^BOOL(NSString *value) {
        NSMutableCharacterSet *allowed = [NSMutableCharacterSet letterCharacterSet];
        [allowed formUnionWithCharacterSet:[NSCharacterSet whitespaceCharacterSet]];
        return [value rangeOfCharacterFromSet:allowed.invertedSet].location == NSNotFound;
    }];

    Class AnimalMenu = [JSMenuRow model:@protocol(Animal)];
    JSMenuRow <Animal> *animalMenu = [AnimalMenu name:[textRow placeholder:@"name"]
                                             nickName:[textRow placeholder:@"nickname"]
                                         favoriteFood:[textRow placeholder:@"favoriteFood"]
                                                  age:[[JSInputRow number] placeholder:@"age"]];
    animalMenu.delegate = self;

    Class AnimalSection = [JSTableSection model:@protocol(Animal)];
    JSTableSection <Animal> *animalSection = [AnimalSection name:[textRow placeholder:@"name"]
                                                        nickName:[textRow placeholder:@"nickname"]
                                                          friend:[animalMenu withTitle:@"friend"]];

    Class PetsTable = [JSTableForm model:@protocol(Pets)];
    _form = [PetsTable dog:[[animalSection title:@"Doggy"] initialData:tucker]
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

- (void)menuRow:(JSMenuRow *)row displayViewController:(UITableViewController *)controller
{
    [self.navigationController pushViewController:controller animated:YES];
}

@end
