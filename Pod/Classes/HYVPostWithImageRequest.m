//
//  HYVBasicPostWithObject.m
//  Pods
//
//  Created by Herasymenko Yevhen on 12.02.15.
//
//

#import "HYVPostWithImageRequest.h"

@implementation HYVPostWithImageRequest

- (void)execute {
    self.operation =
    [[HYVConfiguratorAFNetworking sharedConfigurator] POST:self.path
                                                parameters:self.parameters
                                 constructingBodyWithBlock:^(id <AFMultipartFormData> formData) {
                                     if (self.imagesArray.count) {
                                         for (UIImage *image in self.imagesArray) {
                                             [self appendImage:image toFormData:formData];
                                         }
                                     } else {
                                         [self appendImage:self.image toFormData:formData];
                                     }
                                 }
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       [self executeSuccess:responseObject];
                                                       [self updateSessionWithResponse:operation.response];
                                                   }
                                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                       [self executeError:error];
                                                   }];
}

- (void)appendImage:(UIImage *)image toFormData:(id <AFMultipartFormData>)formData {
    if (!image) {
        return;
    }
    [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 1.0)
                                name:self.objectParamKey
                            fileName:[NSString stringWithFormat:@"%@%@.jpeg",
                                      self.name,
                                      [[NSUUID UUID] UUIDString]]
                            mimeType:@"image/jpeg"];
}

@end
