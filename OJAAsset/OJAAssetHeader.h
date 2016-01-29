
//
//  OJAHeader.h
//  OJAAssetDemo
//
//  Created by lerosua on 16/1/29.
//  Copyright © 2016年 lerosua. All rights reserved.
//

#ifndef OJAHeader_h
#define OJAHeader_h

#define OJAScreenSize [[UIScreen mainScreen] bounds].size
#define OJAScreenHeight MAX(OJAScreenSize.width, OJAScreenSize.height)
#define OJAIPhone6 (OJAScreenHeight == 667)
#define OJAIPhone6Plus (OJAScreenHeight == 736)

#define OJAAssetThumbnailLength (OJAIPhone6Plus) ? 103.0f : ( (OJAIPhone6) ? 93.0f : 78.0f )
#define OJAAssetThumbnailSize CGSizeMake(OJAAssetThumbnailLength, OJAAssetThumbnailLength)
#define OJAAssetPickerPopoverContentSize CGSizeMake(320, 480)

#endif /* OJAHeader_h */
