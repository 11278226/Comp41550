//
//  Photo+Flickr.h
//  FlickrPicker
//
//  Created by comp41550 on 13/03/2013.
//  Copyright (c) 2013 comp41550. All rights reserved.
//

#import "DOKTeamModel.h"

@interface DOKTeamModel (LeagueTable)
+ (DOKTeamModel *)teamWithTableInfo:(NSDictionary *)flickrInfo inManagedObjectContext:(NSManagedObjectContext *)context;
- (NSNumber *)goalDifference;
@end
