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

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Load the SKScene from 'GameScene.sks'
//    GameScene *scene = (GameScene *)[SKScene nodeWithFileNamed:@"GameScene"];
    
    // Set the scale mode to scale to fit the window
//    scene.scaleMode = SKSceneScaleModeAspectFill;
    
//    SKView *skView = (SKView *)self.view;
    
    self.view.backgroundColor = [Utils colorWithHexString:@"141414"];
    
    NSLog(@"Width %f Height %f", [Utils screenWidth], [Utils screenHeight]);
    [[SpaceView sharedInstance] setDefaultSpaceSize:30.0f];
    
    Board *testBoard = [[Board alloc] initWithWidth:([Utils screenWidth]/[[SpaceView sharedInstance] defaultSpaceSize]) height:([Utils screenHeight]/[[SpaceView sharedInstance] defaultSpaceSize])];
    BoardView *boardView = [[BoardView alloc] initWithBoard:testBoard];
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
    
    // Present the scene
//    [skView presentScene:scene];
    
//    skView.showsFPS = YES;
//    skView.showsNodeCount = YES;
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

@end
