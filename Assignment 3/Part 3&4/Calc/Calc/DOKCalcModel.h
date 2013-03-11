//
//  DOKCaclModel.h
//  Calc
//
//  Created by Diarmuid O'Keeffe on 26/01/2013.
//  Copyright (c) 2013 dermo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DOKCalcModel : NSObject

@property (nonatomic) double operand;
@property (nonatomic) double waitingOperand;
@property (nonatomic) double storedOperand;
@property (nonatomic,strong) NSString *waitingOperation;
@property (readonly,strong) id expression;
@property (nonatomic) id propertyList;
@property (nonatomic) NSMutableDictionary *variableValues;

- (double)performOperation:(NSString *)operation;
- (void)digitPressed:(NSString *)operation inMiddleOfDigit:(bool)inMiddleOfDigit;
- (void)setVariableAsOperand:(NSString *)variableName value:(NSString *)value;
- (void)setVariableAsOperand:(NSString *)variableName;
+ (double)evaluateExpression:(id)anExpression
         usingVariableValues:(NSDictionary *)variables;
+ (NSSet *)variablesInExpression:(id)anExpression;
+ (NSString *)descriptionOfExpression:(id)anExpression;
- (id)propertyListForExpression:(id)anExpression;
- (id)expressionForPropertyList:(id)propertyList;
@end
