//
//  QHttpParserDownloadData.h
//  Utilities
//
//  Created by aizhongyuan on 14-7-21.
//  Copyright (c) 2014年 aizhongyuan. All rights reserved.
//

#import "QHttpParser.h"

@interface QHttpParserDownloadData : QHttpParser

@property (nonatomic, strong) NSString * i_url;

@property (nonatomic, strong) NSData * o_data;

@end
