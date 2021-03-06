/*
 *  MaplyShader.h
 *  WhirlyGlobe-MaplyComponent
 *
 *  Created by Steve Gifford on 2/7/13.
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

#import <Foundation/Foundation.h>

@class MaplyBaseViewController;

/** The Maply Shader is a direct interface to the OpenGL ES 2.0 shader language.
    You can use it to specify a custom shader program to replace an existing default
    shader or to assign to your own data.
  */
@interface MaplyShader : NSObject

/// Initialize a shader with the filenames of the vertex and fragment programs
- (id)initWithName:(NSString *)name vertexFile:(NSString *)vertexFileName fragmentFile:(NSString *)fragFileName viewC:(MaplyBaseViewController *)baseViewC;

/// Initialize a shader with the vertex and fragment programs in strings
- (id)initWithName:(NSString *)name vertex:(NSString *)vertexProg fragment:(NSString *)fragProg viewC:(MaplyBaseViewController *)baseViewC;

/// Name (but not scene name)
@property NSString *name;

/// Add the given texture as a named attribute.  Must be called on the main thread.
- (void)addTextureNamed:(NSString *)shaderAttrName image:(UIImage *)image;

/// After creating it, check that it's valid
- (bool)valid;

/// If it wasn't valid, this was the error
- (NSString *)getError;

@end
