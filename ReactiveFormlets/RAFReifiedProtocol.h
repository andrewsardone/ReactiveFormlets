//
//  RAFReifiedProtocol.h
//  ReactiveFormlets
//
//  Created by Jon Sterling on 6/12/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveFormlets/RAFOrderedDictionary.h>

// `RAFReifiedProtocol` is a way to generate model classes from protocols,
// to do away with following kinds of boilerplate:
//
//   * defining model classes and their storage
//   * registering model classes to protocols
//
// Protocol reification is useful when you wish to have in addition to a model,
// an enriched version of that model (such as a formlet). To avoid duplicating
// interfaces, we would really prefer to just have a model and whatever else
// conform to the same protocol.
//
// Model protocols are expected to have the following charactaristics:
//
//   * All properties are readonly objects
//
//   * Any number of constructors may be provided, of the form
//     +key1:key2:key3:...keyN
//   where key1...keyN are all properties on the protocol.
//
// An example model protocol might look like this:
//
//     @protocol Boy <RAFModel>
//     - (id<Text>)name;
//     - (id<Number>)age;
//     - (id<Boy>)buddy;
//     + (instancetype)name:name age:age buddy:buddy;
//     + (instancetype)name:name age:age;
//     @end
//
// A model class can be generated from that as follows:
//
//     Class Boy = [RAFReifiedProtocol model:@protocol(Boy)];
//     id<Boy> steve = [Boy name:@"Steve" age:@7];
//     id<Boy> dan = [Boy name:@"Dan" age:@9 buddy:steve];
//

@interface RAFReifiedProtocol : RAFOrderedDictionary

// Generates a new model class according to a protocol.
//
// model - The protocol from which to generate a class with properties and a
// constructor.
//
// Returns the generated class, which is a subclass of the class to which
// `+model:` was sent.
+ (Class)model:(Protocol *)model;

// The model associated with any particular `RAFReifiedProtocol`-generated
// subclass.
+ (Protocol *)model;
@end

