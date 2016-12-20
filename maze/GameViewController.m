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
    GameScene *scene = (GameScene *)[SKScene nodeWithFileNamed:@"GameScene"];
    
    // Set the scale mode to scale to fit the window
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    SKView *skView = (SKView *)self.view;
    
    // Present the scene
    [skView presentScene:scene];
    
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    Board *testBoard = [[Board alloc] initWithScale:10];
    BoardView *boardView = [[BoardView alloc] initWithBoard:testBoard];
    
    [self.view addSubview:boardView];
    
//    [Utils print:testBoard.boardArray tag:@"Board"];
    for (int y = 0; y < testBoard.scale; y++) {
        NSString *rowString = @"";
        for (int x = 0; x < testBoard.scale; x++) {
            rowString = [NSString stringWithFormat:@"%@ %@", rowString, [testBoard numberForPoint:CGPointMake(x, y)]];
        }
        
        [Utils printString:rowString];
    }
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

@end
