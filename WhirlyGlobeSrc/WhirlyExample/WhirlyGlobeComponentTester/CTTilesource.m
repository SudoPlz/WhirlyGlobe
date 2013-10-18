//
//  CTTilesource.m
//  mapboxCocoaInstallTest
//
//  Created by John Kokkinidis on 9/5/13.
//  Copyright (c) 2013 John Kokkinidis. All rights reserved.
//

#import "CTTilesource.h"
#define MIN_ZOOM_LVL 1
#define MAX_ZOOM_LVL 22
#define TILE_SIZE 256

@interface CTTilesource ()

@end


@implementation CTTilesource



- (bool)tileIsLocal:(MaplyTileID)tileID
{
    return true;    //true if local false if online
}



/// Minimum zoom level (e.g. 0)
- (int)minZoom
{
    return MIN_ZOOM_LVL;
}

/// Maximum zoom level (e.g. 17)
- (int)maxZoom
{
    //    NSLog(@"MAX zoom is: %d", customMaxZoom);
    return MAX_ZOOM_LVL;
}

/// Number of pixels on the side of a single tile (e.g. 128, 256)
- (int)tileSize
{
    return TILE_SIZE;
}



- (NSData *)imageForTile:(MaplyTileID)tileID
{

//    NSLog(@"Tile ZOOM LEVEL:%d ::::: x: %d and y: %d",tileID.level,tileID.x, tileID.y);
    

    UIImage *image = [UIImage imageNamed:@"map_pin.png"];
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
    
    return imageData;
}





@end
