//
//  GameViewController.m
//  maze
//
//  Created by Andrew Boryk on 12/20/16.
//  Copyright © 2016 Andrew Boryk. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"
#import "Board.h"
#import "BoardView.h"

@implementation GameViewController {
    Player *testPlayer;
    
    BoardView *boardView;
    
    Board *testBoard;
    
    /// Recognizes swipes on board left
    UISwipeGestureRecognizer *swipeRecognizerLeft;
    
    /// Recognizes swipes on board right
    UISwipeGestureRecognizer *swipeRecognizerRight;
    
    /// Recognizes swipes on board up
    UISwipeGestureRecognizer *swipeRecognizerUp;
    
    /// Recognizes swipes on board down
    UISwipeGestureRecognizer *swipeRecognizerDown;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Load the SKScene from 'GameScene.sks'
    //GameScene *scene = (GameScene *)[SKScene nodeWithFileNamed:@"GameScene"];
    
    // Set the scale mode to scale to fit the window
    //scene.scaleMode = SKSceneScaleModeAspectFill;
    
    //SKView *skView = (SKView *)self.view;
    
    [[SpaceView sharedInstance] setDefaultSpaceSize:40.0f];
    
    testBoard = [[Board alloc] initWithWidth:([Utils screenWidth]/[[SpaceView sharedInstance] defaultSpaceSize]) height:([Utils screenHeight]/[[SpaceView sharedInstance] defaultSpaceSize])];
    
    [testBoard replacePoint:CGPointMake(4, 1) withType:SpaceTypeEnemyHome];
    [testBoard replacePoint:CGPointMake(4, testBoard.height - 2) withType:SpaceTypeFriendlyHome];
    
    boardView = [[BoardView alloc] initWithBoard:testBoard];
    
    testPlayer = [[Player alloc] initWithType:PlayerTypeFriendly playerID:@"12345" withPosition:CGPointMake(4, testBoard.height - 2)];
    
    [boardView addPlayer:testPlayer];
    
    boardView.center = self.view.center;
    
    [self.view addSubview:boardView];
    
//    [Utils print:testBoard.boardArray tag:@"Board"];
    for (int y = 0; y < testBoard.height; y++) {
        NSString *rowString = @"";
        for (int x = 0; x < testBoard.width; x++) {
            rowString = [NSString stringWithFormat:@"%@ %@", rowString, [testBoard numberForPoint:CGPointMake(x, y)]];
        }
        
        [Utils printString:rowString];
    }
    boardView.userInteractionEnabled = NO;
    
    
    swipeRecognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
    swipeRecognizerLeft.direction = (UISwipeGestureRecognizerDirectionLeft);
    swipeRecognizerLeft.delegate = self;
    
    swipeRecognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    swipeRecognizerRight.direction = (UISwipeGestureRecognizerDirectionRight);
    swipeRecognizerRight.delegate = self;
    
    swipeRecognizerDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDown:)];
    swipeRecognizerDown.direction = (UISwipeGestureRecognizerDirectionDown);
    swipeRecognizerDown.delegate = self;
    
    swipeRecognizerUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUp:)];
    swipeRecognizerUp.direction = (UISwipeGestureRecognizerDirectionUp);
    swipeRecognizerUp.delegate = self;
    
    
    [self.view addGestureRecognizer:swipeRecognizerLeft];
    [self.view addGestureRecognizer:swipeRecognizerRight];
    [self.view addGestureRecognizer:swipeRecognizerDown];
    [self.view addGestureRecognizer:swipeRecognizerUp];
    
    // Present the scene
    //[skView presentScene:scene];
    
    //skView.showsFPS = YES;
    //skView.showsNodeCount = YES;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [boardView movePlayer:testPlayer toPosition:CGPointMake(4, testBoard.height - 2)];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

int gcd (int a, int b){
    int c;
    while ( a != 0 ) {
        c = a; a = b%a; b = c;
    }
    return b;
}

- (void) handleSwipeLeft: (UISwipeGestureRecognizer *)gesture {
    CGPoint newPosition = testPlayer.position;
    
    newPosition.x--;
    
    [UIView animateWithDuration:0.1f animations:^{
        [boardView movePlayer:testPlayer toPosition:newPosition];
    }];
}

- (void) handleSwipeRight: (UISwipeGestureRecognizer *)gesture {
    CGPoint newPosition = testPlayer.position;
    
    newPosition.x++;
    
    [UIView animateWithDuration:0.1f animations:^{
        [boardView movePlayer:testPlayer toPosition:newPosition];
    }];
}

- (void) handleSwipeDown: (UISwipeGestureRecognizer *)gesture {
    CGPoint newPosition = testPlayer.position;
    
    newPosition.y++;
    
    [UIView animateWithDuration:0.1f animations:^{
        [boardView movePlayer:testPlayer toPosition:newPosition];
    }];
}

- (void) handleSwipeUp: (UISwipeGestureRecognizer *)gesture {
    CGPoint newPosition = testPlayer.position;
    newPosition.y--;
    
    [UIView animateWithDuration:0.1f animations:^{
        [boardView movePlayer:testPlayer toPosition:newPosition];
    }];
    
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
