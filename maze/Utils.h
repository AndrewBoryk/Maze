//
//  Utils.h
//  maze
//
//  Created by Andrew Boryk on 12/20/16.
//  Copyright © 2016 Andrew Boryk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utils : NSObject


/// Print dictionary with a tag
+ (void) print: (id) dictionary tag: (NSString *) tag;

/// Print a string
+ (void) printString: (NSString *) string;

#pragma mark - Conditional Oriented

/*!
 * @brief Determines if an object is not null
 * @param object the item looking to be analyzed
 * @return true if the object is not null, false otherwise
 */
+ (BOOL)notNull:(id)object;

/*!
 * @brief Determines if a string is not blank
 * @param text the string looking to be analyzed
 * @return true if the object is not just spaces or blank, false if otherwise
 */
+ (BOOL)notBlank: (NSString *) text;

/*!
 * @brief Removes special characters from a string (%,#,&, etc.)
 * @param text the string looking to be converted
 * @return a string without special characters
 */
+ (NSString *)removeSpecial: (NSString *) text;

/// Trims white space and removes extra new lines from string, with an option to trim multiple new lines or spaces
+ (NSString *)trimWhite: (NSString *) text andMultipleSpaces: (BOOL) trimMultiple;

/// Replaces instances of "\n\n" with "\n" and "  " with " "
+ (NSString *)trimMultipleSpaces: (NSString *) text;

/*!
 * @brief Removes spaces from a string
 * @param text the string that spaces will be removed from
 * @return a string without spaces
 */
+ (NSString *)removeSpaces: (NSString *) text;

/*!
 * @brief Determines if email is valid format
 * @param string email that is passed in
 * @return true if email is valid format, false otherwise
 */
+ (BOOL)isValidEmail: (NSString *)string;

/// Determines bool value for a NSString or NSNumber
+ (BOOL) boolValue: (id) value;

/// Width of the screen
+ (float)screenWidth;

/// Height of the screen
+ (float)screenHeight;

/// Returns UIColor given a hex string
+ (UIColor*)colorWithHexString:(NSString*)hex;

@end
