//
//  DOKCaclModel.m
//  Calc
//
//  Created by Diarmuid O'Keeffe on 26/01/2013.
//  Copyright (c) 2013 dermo. All rights reserved.
//

#import "DOKCalcModel.h"

@interface DOKCalcModel ()

@end

@implementation DOKCalcModel

@synthesize operand = _operand;
@synthesize waitingOperand = _waitingOperand;
@synthesize waitingOperation = _waitingOperation;
@synthesize expression = _expression;
@synthesize storedOperand = _storedOperand;
@synthesize propertyList = _propertyList;

- (double)performOperation:(NSString *)operation
{
    if([operation isEqual:@"sqrt"]) {
        if(self.operand>0) {
            self.operand = sqrt(self.operand);
        }
    }
    else if([@"+/-" isEqualToString:operation])
        self.operand = - self.operand;
    else if ([operation isEqual:@"C"]) {
        self.operand = 0;
        self.waitingOperand = 0;
        self.waitingOperation = nil;
        _expression = nil;
    }
    else if ([operation isEqual:@"sin"])
        self.operand = sin(self.operand);
    else if ([operation isEqual:@"cos"])
        self.operand = cos(self.operand);
    else if ([operation isEqual:@"STO"])
        self.storedOperand = self.operand;
    else if ([operation isEqual:@"RCL"])
        self.operand = self.storedOperand;
    else if ([operation isEqual:@"M+"])
        self.storedOperand = self.operand + self.storedOperand;
    else if ([operation isEqual:@"1/x"]) {
        if (!self.operand == 0) {
            self.operand = 1/self.operand;
        }
    }
    else {
        NSMutableArray *currExpression = [[NSMutableArray alloc] initWithArray:_expression];
        [currExpression addObject:operation];
        _expression = currExpression;
        [self performWaitingOperation];
        self.waitingOperation = operation;
        self.waitingOperand = self.operand;
    }
    return self.operand;
}

- (void)digitPressed:(NSString *)operation inMiddleOfDigit:(bool)inMiddleOfDigit
{
    if (inMiddleOfDigit) {
        NSMutableArray *currExpression = [[NSMutableArray alloc] initWithArray:_expression];
        [currExpression removeLastObject];
        [currExpression addObject:operation];
        _expression = currExpression;
    } else {
        NSMutableArray *currExpression = [[NSMutableArray alloc] initWithArray:_expression];
        [currExpression addObject:operation];
        _expression = currExpression;
    }
}

- (void)performWaitingOperation
{
    if([@"+" isEqualToString:self.waitingOperation])
        self.operand = self.waitingOperand + self.operand;
    else if([@"-" isEqualToString:self.waitingOperation])
        self.operand = self.waitingOperand - self.operand;
    else if([@"*" isEqualToString:self.waitingOperation])
        self.operand = self.waitingOperand * self.operand;
    else if([@"/" isEqualToString:self.waitingOperation])
        if(!self.operand == 0)
            self.operand = self.waitingOperand / self.operand;
}

- (void)setVariableAsOperand:(NSString *)variableName value:(NSString *)value {
    if ([variableName isEqualToString:@"a"]) {
        self.a = [value doubleValue];
    } else if ([variableName isEqualToString:@"b"]) {
        self.b = [value doubleValue];
    } else if ([variableName isEqualToString:@"x"]) {
        self.x = [value doubleValue];
    }
    
    if (self.variableValues == nil) {
        NSArray *objects = [[NSArray alloc] initWithObjects:[NSNumber numberWithDouble:self.a],[NSNumber numberWithInt:self.b],[NSNumber numberWithInt:self.x], nil];
        NSArray *keys = [[NSArray alloc] initWithObjects:@"a",@"b",@"c", nil];
        self.variableValues = [[NSMutableDictionary alloc] initWithObjects:objects forKeys:keys];
    } else {
        [self.variableValues setObject:[NSString stringWithFormat:@"%f",self.a] forKey:@"a"];
        [self.variableValues setObject:[NSString stringWithFormat:@"%f",self.b] forKey:@"b"];
        [self.variableValues setObject:[NSString stringWithFormat:@"%f",self.x] forKey:@"x"];
        
    }
    
}

- (void)setVariableAsOperand:(NSString *)variableName {
    NSMutableArray *currExpression = [[NSMutableArray alloc] initWithArray:_expression];
    [currExpression addObject:variableName];
    _expression = currExpression;
}

+ (double)evaluateExpression:(id)anExpression
         usingVariableValues:(NSDictionary *)variables {
    NSMutableArray *expressionArray = anExpression;
    NSMutableArray *evaluationArray = [[NSMutableArray alloc] init];
    NSNumberFormatter * numberFormat = [[NSNumberFormatter alloc] init];
    [numberFormat setNumberStyle:NSNumberFormatterDecimalStyle];
    for (NSString *part in expressionArray) {
        NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        if ([part rangeOfCharacterFromSet:notDigits].location == NSNotFound)
        {
            [evaluationArray addObject:[numberFormat numberFromString:part]];
        } else if ([part isEqualToString:@"x"]) {
            [evaluationArray addObject:[numberFormat numberFromString:[variables objectForKey:@"x"]]];
        } else if ([part isEqualToString:@"a"]) {
            [evaluationArray addObject:[numberFormat numberFromString:[variables objectForKey:@"a"]]];
        } else if ([part isEqualToString:@"b"]) {
            [evaluationArray addObject:[numberFormat numberFromString:[variables objectForKey:@"b"]]];
        } else if ([part isEqualToString:@"="]) {
            [evaluationArray addObject:@"+"];
        } else {
            [evaluationArray addObject:part];
        }
    }
    double currentNumber = 0;
    double totalNumber = 0;
    NSString *waitingOp = nil;
    for (int i = 0; i < [evaluationArray count]; i++) {
        if ([[evaluationArray objectAtIndex:i] isKindOfClass:[NSNumber class]])
        {
            currentNumber = [[evaluationArray objectAtIndex:i] doubleValue];
            if (waitingOp != nil) {
                if([@"+" isEqualToString:waitingOp]) {
                    totalNumber = totalNumber + currentNumber;
                    waitingOp =nil;
                }
                else if([@"-" isEqualToString:waitingOp]) {
                    totalNumber = totalNumber - currentNumber;
                    waitingOp =nil;
                }
                else if([@"*" isEqualToString:waitingOp]) {
                    totalNumber = totalNumber * currentNumber;
                    waitingOp =nil;
                }
                else if([@"/" isEqualToString:waitingOp]) {
                    totalNumber = totalNumber / currentNumber;
                    waitingOp =nil;
                }
            } else
                totalNumber = currentNumber;
        }
        else {
            waitingOp = [evaluationArray objectAtIndex:i];
        }
    }
    return totalNumber;
}
+ (NSSet *)variablesInExpression:(id)anExpression {
    NSMutableSet *myMutableSet = [[NSMutableSet alloc] init];
    for (NSString *myID in anExpression) {
        if ([myID isEqualToString:@"x"] || [myID isEqualToString:@"a"] || [myID isEqualToString:@"b"]) {
            if (![myMutableSet member:myID]) {
                [myMutableSet addObject:myID];
            }
        }
        
    }
    if ([myMutableSet count] > 0) {
        return myMutableSet;
    }
    return nil;
}
- (NSString *)descriptionOfExpression:(id)anExpression {
    NSString *stringDescription = @"";
    for (NSString *myString in anExpression) {
        stringDescription = [stringDescription stringByAppendingString:[NSString stringWithFormat:@"%@ ",myString]];
    }
    return stringDescription;
}

+ (id)propertyList
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *expressionPlistDirectory = [documentsDirectory stringByAppendingPathComponent:@"expression"];
    return expressionPlistDirectory;
}


+ (id)propertyListForExpression:(id)anExpression {
    NSArray *myExpression = (NSArray *)anExpression;
    NSString *expressionPlistDirectory = self.propertyList;
    [myExpression writeToFile:expressionPlistDirectory atomically:YES];
    return expressionPlistDirectory;
}

- (id)expressionForPropertyList:(id)propertyList {
    NSArray *array;
    if ([[NSFileManager defaultManager] fileExistsAtPath:propertyList]) {
        array = [[NSArray alloc] initWithContentsOfFile:propertyList];
    }
    return array;
}

@end
