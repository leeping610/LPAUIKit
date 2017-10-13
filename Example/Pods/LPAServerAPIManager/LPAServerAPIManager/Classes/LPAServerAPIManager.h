//
//  LPAServerAPIManager.h
//  LPAServerAPIManager
//
//  Created by 平果太郎 on 2017/9/22.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXTERN NSString *const LPAServerAPIManagerFailureErrorResponseKey;
FOUNDATION_EXTERN NSString *const LPAServerAPIManagerFailureErrorServerCodeKey;

typedef NS_ENUM(NSInteger, LPAServerAPIManagerRequestType)
{
    LPAServerAPIManagerRequestTypeUnknow,
    LPAServerAPIManagerRequestTypeGet,
    LPAServerAPIManagerRequestTypePost,
    LPAServerAPIManagerRequestTypeHead,
    LPAServerAPIManagerRequestTypePut,
    LPAServerAPIManagerRequestTypePatch,
    LPAServerAPIManagerRequestTypePatchInURL,
    LPAServerAPIManagerRequestTypeDelete
};

typedef void(^LPAServerAPIManagerRequestSuccessHandlerBlock)(id responseObject);
typedef void(^LPAServerAPIManagerRequestFailedHandlerBlock)(NSError *error);

@class LPAServerAPIManager;

@protocol LPAServerAPIManagerAPIDelegate <NSObject>

@required

/**
 return request type

 @return request type
 */
- (LPAServerAPIManagerRequestType)requestType;

/**
 return request URL

 @return request url string
 */
- (NSString *)requestURL;

/**
 return request method name

 @return request method name
 */
- (NSString *)requestMethodName;

@end

@protocol LPAServerAPIManagerDelegate <NSObject>

@optional

/**
 Request success delegate

 @param serverAPIManager request manager
 @param responseObject request repsonseObject
 */
- (void)serverAPIManager:(LPAServerAPIManager *)serverAPIManager didRequestSuccess:(id)responseObject;

/**
 request failed delegate

 @param serverAPIManager request manager
 @param error request error
 */
- (void)serverAPIManager:(LPAServerAPIManager *)serverAPIManager didRequestFailed:(NSError *)error;

@end

@protocol LPAServerAPIManagerParamSource <NSObject>

@required

/**
 request param for manager

 @param serverAPIManager request manager
 @return the request's param
 */
- (NSDictionary *)paramSourceForServerAPIManager:(LPAServerAPIManager *)serverAPIManager;

@end

@interface LPAServerAPIManager : NSObject

@property (nonatomic, weak) id<LPAServerAPIManagerParamSource> paramSource;
@property (nonatomic, weak) id<LPAServerAPIManagerDelegate> delegate;

@property (nonatomic, copy) NSString *pageIndexKey;
@property (nonatomic, copy) NSString *pageLimitKey;
@property (nonatomic, assign) NSInteger pageLimit;
@property (nonatomic, assign, readonly) NSInteger pageIndex;

@property (nonatomic, assign) NSTimeInterval timeoutInterval;

@property (nonatomic, assign) BOOL multiTask; // Multi task processing
@property (nonatomic, assign, readonly, getter=isRequest) BOOL requesting;
@property (nonatomic, assign) BOOL allowInvalidCertificates;

@property (nonatomic, strong, readonly) NSMutableDictionary *extraParamDictionary;
@property (nonatomic, strong, readonly) NSMutableDictionary *headerFieldDictionary;

// Cancel all of requests
+ (void)cancelAllRequest;

// Request
- (void)startRequest;
- (void)startRequestSuccess:(LPAServerAPIManagerRequestSuccessHandlerBlock)successBlock
                     failed:(LPAServerAPIManagerRequestFailedHandlerBlock)failedBlock;
- (void)cancel;
// The param in URL
- (void)addParamForMethodName:(NSString *)param;
- (void)addParamsForMethodName:(NSArray *)params;


@end

@interface LPAServerAPIManager (Information)

@property (nonatomic, copy, readonly) NSString *requestFinalURL;
@property (nonatomic, copy, readonly) NSDictionary *requestParamDictionary;
@property (nonatomic, assign, readonly) NSTimeInterval requestTime;

@end

@interface NSError (LPAServerAPIManager)

- (NSError *)lpa_error;

@end
