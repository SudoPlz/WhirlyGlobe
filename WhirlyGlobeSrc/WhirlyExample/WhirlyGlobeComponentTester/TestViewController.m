/*
 *  TestViewController.m
 *  WhirlyGlobeComponentTester
 *
 *  Created by Steve Gifford on 7/23/12.
 *  Copyright 2011-2013 mousebird consulting
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 */

//#import <QuartzCore/QuartzCore.h>
#import "TestViewController.h"
//#import "AFJSONRequestOperation.h"
//#import "AFKissXMLRequestOperation.h"
//#import "AnimationTest.h"
//#import "WeatherShader.h"


@interface TestViewController()
{
}
@property    MaplyViewControllerLayer *baseLayer;
@property (nonatomic,strong) MaplyQuadImageTilesLayer *myBasicMapLayer;
@property (nonatomic,strong) CTTilesource* myTileSrc;

@end

typedef struct
{
    char name[20];
    float lat,lon;
} LocationInfo;

LocationInfo locations[2] =
{
    {"Random loc 1",40.56871, 22.95833},
    {"Random loc 2",37.33170, -122.03023}
};


@implementation TestViewController

@synthesize myTileSrc;
@synthesize baseLayer;
@synthesize myBasicMapLayer;





- (void)dealloc
{
    // This should release the globe view
    if (baseViewC)
    {
        [baseViewC.view removeFromSuperview];
        [baseViewC removeFromParentViewController];
        baseViewC = nil;
    }
}



- (void)viewDidLoad
{

    [super viewDidLoad];
    
    //CHOOSE Wether or not the map should be 2D or 3D !!!!!!!!!!!//
    //                                                           //
    //Uncomment for 2D                                           //
    //[self setupWhirlyForMaptype:Maply2DMap];                   //
    //                                                           //
    //Uncomment for 3D                                           //
        [self setupWhirlyForMaptype:MaplyGlobe];                     //
    //                                                           //
    //CHOOSE Wether or not the map should be 2D or 3D !!!!!!!!!!!//
    
}

-(void) setupWhirlyForMaptype: (MapType) maptype
{
    
    switch(maptype)
    {
        case MaplyGlobe:
            globeViewC = [[WhirlyGlobeViewController alloc] init];
            globeViewC.delegate = self;
            baseViewC = globeViewC;
            break;
            
        case Maply3DMap:
            mapViewC = [[MaplyViewController alloc] init];
            mapViewC.delegate = self;
            baseViewC = mapViewC;
            break;
            
        case Maply2DMap:
            mapViewC = [[MaplyViewController alloc] initAsFlatMap];
            mapViewC.delegate = self;
            baseViewC = mapViewC;
            break;
    }
    
    //add the map as a subview
    [self.view addSubview:baseViewC.view];
    [self.view sendSubviewToBack:baseViewC.view];
    baseViewC.view.frame = self.view.bounds;
    [self addChildViewController:baseViewC];
    
    
    // Set the background color for the globe
    baseViewC.clearColor = [UIColor blackColor];
    
    
    
    if (maptype==MaplyGlobe)
    {
        
        //globeViewC.clearColor = [UIColor colorWithRed:0.19 green:0.64 blue:0.89 alpha:1];
        
        globeViewC.height = 0.8;    //0.00009;//0.8;//0.00009;
//        [globeViewC animateToPosition:MaplyCoordinateMakeWithDegrees(currentLocation.x, currentLocation.y) time:1.0];
        //        globeViewC.keepNorthUp = YES;
        
        
    } else {
        //default height 1
        mapViewC.height = 1;//0.00009;
//        [mapViewC animateToPosition:MaplyCoordinateMakeWithDegrees(-122.0361328125, 36.96744946416934) time:1.0];
    }
    
    
    //self explainatory.. (Sudo plz additions)
    globeViewC.autoMoveToTap = false;
    globeViewC.zoomInOnDoubleTap = true;
    

    [self feedWhirlyWithMapData:maptype];   //start loading map data
}





- (void)globeViewController:(WhirlyGlobeViewController *)viewC didTapAt:(WGCoordinate)coord
{
 //DO something when user taps on the globe
}




-(void) feedWhirlyWithMapData:(MapType) maptype
{
    
    //==========================================================================================//
    //  example 1:  Shape files loading (instead of a tilesource)
    
    //self.title = @"Vector data";
    //float vecWidth = 4.0;
    //
    //    NSDictionary* countryLinesDesc = @{
    //                                       kMaplyColor: [UIColor whiteColor],
    //                                       kMaplySubdivType: kMaplySubdivSimple,
    //                                       kMaplySubdivEpsilon: @(0.001),
    //                                       kMaplyVecWidth: @(vecWidth),
    //                                       kMaplyFilled: kWGFilled
    //                                       };
    //
    //    NSMutableArray* vectorLayers = [[NSMutableArray alloc] init];
    //
    //    //    //Vectors (country lines)
    //    //    vectorDb = [MaplyVectorDatabase vectorDatabaseWithShape:@"filenameOfShapefile_administrative"];
    //    //    MaplyVectorObject* vectors = [vectorDb fetchAllVectors];
    //    //    [vectorLayers addObject:vectors];
    //
    //
    //    //Vectors (Coastlines)
    //    MaplyVectorDatabase* coastlines = [MaplyVectorDatabase vectorDatabaseWithShape:@"filenameOfShapefile_coastline"];
    //    MaplyVectorObject* coastVector = [coastlines fetchAllVectors];
    //    [vectorLayers addObject:coastVector];
    //
    //
    //
    //    [globeViewC addVectors:vectorLayers desc:countryLinesDesc];
    //
    //
    //
    //
    //    NSDictionary *locDesc = @{kMaplyColor: [UIColor colorWithRed:1.0 green:186/255.0 blue:103/255.0 alpha:1.0],
    ////                              kMaplyDrawOffset: @(0),
    ////                              kMaplyDrawPriority: @(600),
    //                              kMaplyFilled: @(YES),
    ////                              kMaplyFade: @(YES),
    ////                              kMaplyEnable: @(NO),
    //                              kMaplyMinVis: @0.007f,
    //                              kMaplyMaxVis: @0.017f
    //                              };
    //
    //
    ////  @{
    ////                              kMaplyColor: [UIColor blueColor],
    ////                              kMaplySubdivType: kMaplySubdivSimple,
    ////                              kMaplySubdivEpsilon: @(0.001),
    ////                              kMaplyVecWidth: @(vecWidth),
    ////                              kMaplyFilled: kWGFilled
    ////                              };
    //
    //    NSMutableArray* locationLayers = [[NSMutableArray alloc] init];
    //    //Vectors (Coastlines)
    //    MaplyVectorDatabase* locationDb = [MaplyVectorDatabase vectorDatabaseWithShape:@"greece_natural"];
    //    MaplyVectorObject* locationVector = [locationDb fetchAllVectors];
    //    [locationLayers addObject:locationVector];
    //
    //    [globeViewC addVectors:locationLayers desc:locDesc];
    
    
    
    
    //==========================================================================================//
    
    
    
    
    // example 2: Implementing the MaplyTileSource protocol

    
    self.title = @"Tilesource data";
    //    create a custom tilesource
    myTileSrc = [[CTTilesource alloc] init];
    
    MaplySphericalMercator* coordSystem = [[MaplySphericalMercator alloc] initWebStandard];
    
    myBasicMapLayer = [[MaplyQuadImageTilesLayer alloc]
               initWithCoordSystem:coordSystem
               tileSource:myTileSrc ];
    
    
    //    myBasicMapLayer.waitLoad = true;
    //    myBasicMapLayer.waitLoadTimeout = 4; //set this to a lower value if using local tile files and experience reloading problems
    
//    myBasicMapLayer.flipY = false;    //correct flipped Google coords (if using EPSG)
    
    baseLayer = myBasicMapLayer;
    if (maptype==MaplyGlobe)
    {
        myBasicMapLayer.handleEdges = true;
        myBasicMapLayer.coverPoles = true;
    }
    else
    {
        myBasicMapLayer.handleEdges = false;
        myBasicMapLayer.coverPoles = false;
    }
    
    
    //    layer.requireElev = requireElev;
    //    add the layer on top
    
    [baseViewC addLayer:myBasicMapLayer];
    myBasicMapLayer.drawPriority = 0;
    
    //==========================================================================================//

}







// Add screen (2D) markers at all our locations
- (void)addScreenMarkers:(LocationInfo *)locations len:(int)len stride:(int)stride offset:(int)offset
{
    CGSize size = CGSizeMake(40, 40);
    UIImage *pinImage = [UIImage imageNamed:@"map_pin"];
    
    NSMutableArray *markers = [NSMutableArray array];
    for (unsigned int ii=offset;ii<len;ii+=stride)
    {
        LocationInfo *location = &locations[ii];
        MaplyScreenMarker *marker = [[MaplyScreenMarker alloc] init];
        marker.image = pinImage;
        marker.loc = MaplyCoordinateMakeWithDegrees(location->lon,location->lat);
        marker.size = size;
        marker.userObject = [NSString stringWithFormat:@"%s",location->name];
        [markers addObject:marker];
    }
    
    [baseViewC addScreenMarkers:markers desc:nil];
}



// Add 3D markers
- (void)addMarkers:(LocationInfo *)locations len:(int)len stride:(int)stride offset:(int)offset
{
    CGSize size = CGSizeMake(0.05, 0.05);
    UIImage *startImage = [UIImage imageNamed:@"Star"];
    
    NSMutableArray *markers = [NSMutableArray array];
    for (unsigned int ii=offset;ii<len;ii+=stride)
    {
        LocationInfo *location = &locations[ii];
        MaplyMarker *marker = [[MaplyMarker alloc] init];
        marker.image = startImage;
        marker.loc = MaplyCoordinateMakeWithDegrees(location->lon,location->lat);
        marker.size = size;
        marker.userObject = [NSString stringWithFormat:@"%s",location->name];
        [markers addObject:marker];
    }
    
    
    [baseViewC addMarkers:markers desc:nil];
}


@end
