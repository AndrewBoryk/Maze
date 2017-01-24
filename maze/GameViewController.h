//
//  GameViewController.h
//  maze
//
//  Created by Andrew Boryk on 12/20/16.
//  Copyright © 2016 Andrew Boryk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <GameplayKit/GameplayKit.h>

@interface GameViewController : UIViewController <UIGestureRecognizerDelegate, UIScrollViewDelegate>

/// Scroll view for board
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

/// Button to switch players during testing
@property (strong, nonatomic) IBOutlet UIButton *switchPlayerButton;

/// Switch players during testing
- (IBAction)switchPlayerAction:(id)sender;

@end
