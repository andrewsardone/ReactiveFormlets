//
//  JSReifiedProtocol.h
//  iOS Formlets
//
//  Created by Jon Sterling on 6/12/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/RACSubscribable.h>
#import "JSOrderedDictionary.h"

// JSReifiedProtocol is a way to generate model classes from protocols,
// to do away with following kinds of boilerplate:
//
//   * defining model classes and their storage
//   * registering model classes to protocols
//
// The reason we can't just use plain old model classes is that we want
// to be able to decorate other objects with their protocol: that is, a
// formlet should *be* the model, but lifted into the *idiom* of forms.
// So, we need protocols; hence, we need protocol reification.
//
// Model protocols are expected to have the following charactaristics:
//
//   * All properties are readonly objects
//
//   * Any number of constructors may be provided, of the form
//       +key1:key2:key3:...keyN
//     where key1...keyN are all properties on the protocol.
//
// An example model protocol might look like this:
//
//     @protocol Boy
//     @property (readonly) id <Text> name;
//     @property (readonly) id <Number> age;
//     @property (readonly) id <Boy> buddy;
//     + (instancetype)name:(id <Text>)name age:(id <Number>)age buddy:(id <Boy>)buddy;
//     + (instancetype)name:(id <Text>)name age:(id <Number>)age;
//     @end
//
// A model class can be generated from that as follows:
//
//     Class Boy = [JSReifiedProtocol model:@protocol(Boy)];
//     id <Boy> steve = [Boy name:@"Steve" age:@7];
//     id <Boy> dan = [Boy name:@"Dan" age:@9 buddy:steve];
//
@interface JSReifiedProtocol : JSOrderedDictionary <RACSubscribable>
+ (Class)model:(Protocol *)model;
+ (Protocol *)model;
@end
