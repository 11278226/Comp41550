//
//  PolygonShape.h
//  HelloPoly
//
//  Created by Diarmuid O'Keeffe on 15/01/2013.
//  Copyright (c) 2013 dermo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PolygonShape : NSObject {
}

@property (nonatomic) int numberOfSides;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic) UIColor *insideColor;
@property (nonatomic) UIColor *borderColor;

@end
