//
//  Utils.m
//  maze
//
//  Created by Andrew Boryk on 12/20/16.
//  Copyright © 2016 Andrew Boryk. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (void) print: (id) dictionary tag: (NSString *) tag {
    
    
    #ifdef DEBUG
        if ([Utils notNull:tag]) {
            CFShow((__bridge CFTypeRef)[NSString stringWithFormat:@"%@:\n%@", tag, dictionary]);
        }
        else {
            CFShow((__bridge CFTypeRef)(dictionary));
        }
    #endif
}

+ (void) printString: (NSString *) string {
    
    #ifdef DEBUG
        CFShow((__bridge CFTypeRef)(string));
    #endif
}

#pragma mark - Conditional Oriented
+ (BOOL)notNull:(id)object {
    if ([object isEqual:[NSNull null]] || [object isKindOfClass:[NSNull class]] || object == nil) {
        return false;
    }
    else {
        return true;
    }
}

+ (BOOL)notBlank: (NSString *) text {
    if ([Utils notNull:text]) {
        if (![text isEqualToString:@""]) {
            return YES;
        }
    }
    
    return NO;
}

+ (NSString *)removeSpecial: (NSString *) text {
    NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"] invertedSet];
    return  [[text componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
}

+ (NSString *)trimWhite: (NSString *) text andMultipleSpaces: (BOOL) trimMultiple {
    if ([Utils notNull:text]) {
        text = [text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if (trimMultiple) {
            text = [Utils trimMultipleSpaces:text];
        }
    }
    
    return text;
}

+ (NSString *)trimMultipleSpaces: (NSString *) text {
    if ([Utils notNull:text]) {
        while ([text containsString:@"  "]) {
            text = [text stringByReplacingOccurrencesOfString:@"  " withString:@" "];
        }
        
        while ([text containsString:@"\n\n"]) {
            text = [text stringByReplacingOccurrencesOfString:@"\n\n" withString:@"\n"];
        }
    }
    
    return text;
}

+ (NSString *)removeSpaces: (NSString *) text {
    text = [self trimWhite:text andMultipleSpaces:NO];
    return  [text stringByReplacingOccurrencesOfString:@" " withString:@""];
}

+ (BOOL)isValidEmail: (NSString *)string
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:string];
}

+ (BOOL) boolValue: (id) value {
    if ([Utils notNull:value]) {
        if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
            return [value boolValue];
        }
    }
    
    return NO;
}

+ (float)screenWidth {
    CGRect screen = [[UIScreen mainScreen] bounds];
    
    return screen.size.width;
}

+ (float)screenHeight {
    CGRect screen = [[UIScreen mainScreen] bounds];
    
    return screen.size.height;
}

+ (UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[self removeSpaces:hex] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
@end
