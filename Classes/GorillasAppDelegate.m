/*
 * This file is part of Gorillas.
 *
 *  Gorillas is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  Gorillas is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with Gorillas in the file named 'COPYING'.
 *  If not, see <http://www.gnu.org/licenses/>.
 */

//
//  GorillasAppDelegate.m
//  Gorillas
//
//  Created by Maarten Billemont on 18/10/08.
//  Copyright, lhunath (Maarten Billemont) 2008. All rights reserved.
//

#import "GorillasAppDelegate.h"


@implementation GorillasAppDelegate

@synthesize gameLayer, mainMenuLayer, statsLayer, configLayer, hudLayer;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
    // Start the background music.
    /*audioController = [[[AudioController alloc] initWithFile:@"veritech.wav"] retain];
    [audioController playOrStop];
    [[audioController audioPlayer] setRepeat:true];*/

    // Random seed with timestamp.
    srandom(time(nil));
    
    // Menu items font.
    [MenuItemFont setFontSize:[[GorillasConfig get] fontSize]];
    [MenuItemFont setFontName:[[GorillasConfig get] fontName]];

	// Director and OpenGL Setup.
    [Director setPixelFormat:RGBA8];
	//[[Director sharedDirector] setDisplayFPS:true];
	[[Director sharedDirector] setDepthTest:false];
	[[Director sharedDirector] setLandscape:true];
	//glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    //glEnable(GL_POINT_SMOOTH);
	
    // Build the scene.
	gameLayer = [GameLayer node];
	Scene *scene = [Scene node];
	[scene add: gameLayer];
    
    // Start the scene and bring up the menu.
	[[Director sharedDirector] runScene: scene];
    [self showMainMenu];
    
    // Load the HUD.
    hudLayer = [[HUDLayer alloc] init];
    [gameLayer add:hudLayer];
}


-(void) revealHud {
    
    [hudLayer reveal];
}


-(void) hideHud {
    
    [hudLayer dismiss];
}


-(void) dismissLayer {
    
    [currentLayer dismiss];
}


-(void) showLayer: (ShadeLayer *)layer {
    
    if([currentLayer showing])
        [currentLayer dismiss];
    
    currentLayer = layer;
    [currentLayer reveal];
}


-(void) showMainMenu {
    
    if(!mainMenuLayer) {
        mainMenuLayer = [[MainMenuLayer alloc] init];
        [gameLayer add:mainMenuLayer];
    }    
    
    
    [self showLayer:mainMenuLayer];
}


-(void) showStatistics {

    if(!statsLayer) {
        statsLayer = [[StatisticsLayer alloc] init];
        [gameLayer add:statsLayer];
    }    
    
    [self showLayer:statsLayer];
}


-(void) showConfiguration {
    
    if(!configLayer) {
        configLayer = [[ConfigurationLayer alloc] init];
        [gameLayer add:configLayer];
    }
    
    [self showLayer:configLayer];
}


-(void) applicationWillResignActive:(UIApplication *)application {
    
    [[Director sharedDirector] pause];
}


-(void) applicationDidBecomeActive:(UIApplication *)application {
    
    [[Director sharedDirector] resume];
}


- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    
	[[TextureMgr sharedTextureMgr] removeAllTextures];
    
    if(![currentLayer showing])
        if(currentLayer == mainMenuLayer) {
            [gameLayer remove:mainMenuLayer];
            [mainMenuLayer release];
            mainMenuLayer = nil;
        }
        else if(currentLayer == statsLayer) {
            [gameLayer remove:statsLayer];
            [statsLayer release];
            statsLayer = nil;
        }
        else if(currentLayer == configLayer) {
            [gameLayer remove:configLayer];
            [configLayer release];
            configLayer = nil;
        }
    
    if([audioController audioPlayer])
        [audioController playOrStop];
    [audioController release];
    audioController = nil;
}


+(GorillasAppDelegate *) get {
    
    return (GorillasAppDelegate *) [[UIApplication sharedApplication] delegate];
}


- (void)dealloc {
    
    [mainMenuLayer release];
    [statsLayer release];
    [configLayer release];
    [audioController release];
    [hudLayer release];
    
    [super dealloc];
}


@end