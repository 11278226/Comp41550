//
//  Photo+Flickr.m
//  FlickrPicker
//
//  Created by comp41550 on 13/03/2013.
//  Copyright (c) 2013 comp41550. All rights reserved.
//

#import "DOKTeamModel+LeagueTable.h"
//#import "FlickrFetcher.h"
//#import "Photographer+Create.h"

@implementation DOKTeamModel (LeagueTable)

+ (DOKTeamModel *)teamWithTableInfo:(NSDictionary *)flickrInfo inManagedObjectContext:(NSManagedObjectContext *)context {
    DOKTeamModel *team;
    
//    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
//    request.predicate = [NSPredicate predicateWithFormat:@"uniqueID = %@",[flickrInfo objectForKey:FLICKR_PHOTO_ID]];
//    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
//    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
//    NSError *error = nil;
//    NSArray *matches = [context executeFetchRequest:request error:&error];
    
//    if (!matches || ([matches count] > 1)) {
//        // error
//    } else if ([matches count] == 0) {
//        photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
//        photo.uniqueID = [flickrInfo objectForKey:FLICKR_PHOTO_ID];
//        photo.title = [flickrInfo objectForKey:FLICKR_PHOTO_TITLE];
//        photo.subtitle = [flickrInfo objectForKey:FLICKR_PHOTO_DESCRIPTION];
//        photo.imageURL = [[FlickrFetcher urlForPhoto:flickrInfo format:FlickrPhotoFormatOriginal] absoluteString];
//        photo.whoTook = [Photographer photographerWithName:[flickrInfo objectForKey:FLICKR_PHOTO_OWNER] inManagedObjectContext:context];
//        NSLog(@"%@",[photo description]);
//    } else {
//        photo = [matches lastObject];
//    }
    
    return team;
}

@end
