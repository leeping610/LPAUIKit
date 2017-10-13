//
//  LPAServerAPIManager.m
//  LPAServerAPIManager
//
//  Created by 平果太郎 on 2017/9/22.
//

#import "LPAServerAPIManager.h"

#import <AFNetworking/AFNetworking.h>

//NSURLErrorUnknown = -1,
//NSURLErrorCancelled = -999,
//NSURLErrorBadURL = -1000,
//NSURLErrorTimedOut = -1001,
//NSURLErrorUnsupportedURL = -1002,
//NSURLErrorCannotFindHost = -1003,
//NSURLErrorCannotConnectToHost = -1004,
//NSURLErrorDataLengthExceedsMaximum = -1103,
//NSURLErrorNetworkConnectionLost = -1005,
//NSURLErrorDNSLookupFailed = -1006,
//NSURLErrorHTTPTooManyRedirects = -1007,
//NSURLErrorResourceUnavailable = -1008,
//NSURLErrorNotConnectedToInternet = -1009,
//NSURLErrorRedirectToNonExistentLocation = -1010,
//NSURLErrorBadServerResponse = -1011,
//NSURLErrorUserCancelledAuthentication = -1012,
//NSURLErrorUserAuthenticationRequired = -1013,
//NSURLErrorZeroByteResource = -1014,
//NSURLErrorCannotDecodeRawData = -1015,
//NSURLErrorCannotDecodeContentData = -1016,
//NSURLErrorCannotParseResponse = -1017,
//NSURLErrorFileDoesNotExist = -1100,
//NSURLErrorFileIsDirectory = -1101,
//NSURLErrorNoPermissionsToReadFile = -1102,
//NSURLErrorSecureConnectionFailed = -1200,
//NSURLErrorServerCertificateHasBadDate = -1201,
//NSURLErrorServerCertificateUntrusted = -1202,
//NSURLErrorServerCertificateHasUnknownRoot = -1203,
//NSURLErrorServerCertificateNotYetValid = -1204,
//NSURLErrorClientCertificateRejected = -1205,
//NSURLErrorClientCertificateRequired = -1206,
//NSURLErrorCannotLoadFromNetwork = -2000,
//NSURLErrorCannotCreateFile = -3000,
//NSURLErrorCannotOpenFile = -3001,
//NSURLErrorCannotCloseFile = -3002,
//NSURLErrorCannotWriteToFile = -3003,
//NSURLErrorCannotRemoveFile = -3004,
//NSURLErrorCannotMoveFile = -3005,
//NSURLErrorDownloadDecodingFailedMidStream = -3006,
//NSURLErrorDownloadDecodingFailedToComplete = -3007

NSString *const LPAServerAPIManagerFailureErrorResponseKey = @"LPAServerAPIManagerFailureErrorResponseKey";
NSString *const LPAServerAPIManagerFailureErrorServerCodeKey = @"LPAServerAPIManagerFailureErrorServerCodeKey";

static AFHTTPSessionManager *sessionManager;
static NSTimeInterval const kLPAServerAPIManagerDefaultTimeoutInterval = 15;

@interface LPAServerAPIManager ()

@property (nonatomic, strong) AFHTTPSessionManager *networkManager;

@property (nonatomic, weak) id<LPAServerAPIManagerAPIDelegate> childAPI;
@property (nonatomic, assign, readwrite) NSInteger pageIndex;
@property (nonatomic, assign, readwrite, getter=isRequest) BOOL requesting;

@property (nonatomic, strong) NSMutableArray *extraRequestURLMethodParams;
@property (nonatomic, strong, readwrite) NSMutableDictionary *extraParamDictionary;
@property (nonatomic, strong, readwrite) NSMutableDictionary *headerFieldDictionary;

@property (nonatomic) dispatch_semaphore_t signal;
@property (nonatomic) dispatch_time_t overTime;

// Final request information
@property (nonatomic, copy) NSString *serverRequestURL;
@property (nonatomic, copy) NSDictionary *serverRequestParam;
@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, assign) NSTimeInterval endTime;

@end

@implementation LPAServerAPIManager

#pragma mark - Class Methods

+ (AFHTTPSessionManager *)defaultSessionManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sessionManager = [AFHTTPSessionManager manager];
        sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    });
    sessionManager.requestSerializer.timeoutInterval = kLPAServerAPIManagerDefaultTimeoutInterval;
    return sessionManager;
}

+ (void)cancelAllRequest
{
    [sessionManager.session getTasksWithCompletionHandler:^(NSArray<NSURLSessionDataTask *> *dataTasks,
                                                            NSArray<NSURLSessionUploadTask *> *uploadTasks,
                                                            NSArray<NSURLSessionDownloadTask *> *downloadTasks){
        [dataTasks makeObjectsPerformSelector:@selector(cancel)];
        [uploadTasks makeObjectsPerformSelector:@selector(cancel)];
        [downloadTasks makeObjectsPerformSelector:@selector(cancel)];
    }];
}

#pragma mark - Life Cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        if ([self conformsToProtocol:@protocol(LPAServerAPIManagerAPIDelegate)]) {
            _extraRequestURLMethodParams = [NSMutableArray array];
            _extraParamDictionary = [NSMutableDictionary dictionary];
            _headerFieldDictionary = [NSMutableDictionary dictionary];
            _childAPI = (id<LPAServerAPIManagerAPIDelegate>)self;
            // Default values
            _timeoutInterval = kLPAServerAPIManagerDefaultTimeoutInterval;
            _signal = dispatch_semaphore_create(1);
            _overTime = dispatch_time(DISPATCH_TIME_NOW, _timeoutInterval * NSEC_PER_SEC);
        }else {
            NSAssert(NO, @"subClass must protocal from LPAServerAPIManagerAPIDelegate");
        }
    }
    return self;
}

- (void)startRequest
{
    if (_requesting && !_multiTask) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_wait(_signal, _overTime);
        self.startTime = CACurrentMediaTime();
        LPAServerAPIManagerRequestType requestType = [self.childAPI requestType];
        NSString *requestURL = [self __requestURL];
        NSDictionary *requestParam = [self __requestParam];
        NSURLSessionDataTask *requestTask = nil;
        if (_headerFieldDictionary.allKeys.count) {
            [_headerFieldDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop){
                [self.networkManager.requestSerializer setValue:value forHTTPHeaderField:key];
            }];
        }
        switch (requestType) {
            case LPAServerAPIManagerRequestTypeUnknow:
                NSAssert(NO, @"Must rewrite requestType(),return a request type");
                break;
            case LPAServerAPIManagerRequestTypeGet:
                [self get:requestURL param:requestParam];
                break;
            case LPAServerAPIManagerRequestTypePost:
                [self post:requestURL param:requestParam];
                break;
            case LPAServerAPIManagerRequestTypeHead:
                [self head:requestURL param:requestParam];
                break;
            case LPAServerAPIManagerRequestTypePut:
                [self put:requestURL param:requestParam];
                break;
            case LPAServerAPIManagerRequestTypePatch:
            case LPAServerAPIManagerRequestTypePatchInURL:
                [self patch:requestURL param:requestParam];
                break;
            case LPAServerAPIManagerRequestTypeDelete:
                [self delete:requestURL param:requestParam];
                break;
        }
        if (requestTask) {
            self.requesting = YES;
            self.serverRequestURL = requestURL;
            self.serverRequestParam = requestParam;
        }
        [_extraRequestURLMethodParams removeAllObjects];
    });
}

- (void)startRequestSuccess:(LPAServerAPIManagerRequestSuccessHandlerBlock)successBlock
                     failed:(LPAServerAPIManagerRequestFailedHandlerBlock)failedBlock
{
    if (_requesting && !_multiTask) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_wait(_signal, _overTime);
        self.startTime = CACurrentMediaTime();
        LPAServerAPIManagerRequestType requestType = [self.childAPI requestType];
        NSString *requestURL = [self __requestURL];
        NSDictionary *requestParam = [self __requestParam];
        NSURLSessionDataTask *requestTask = nil;
        if (_headerFieldDictionary.allKeys.count) {
            [_headerFieldDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop){
                [self.networkManager.requestSerializer setValue:value forHTTPHeaderField:key];
            }];
        }
        switch (requestType) {
            case LPAServerAPIManagerRequestTypeUnknow:
                NSAssert(NO, @"Must rewrite requestType(),return a request type");
                break;
            case LPAServerAPIManagerRequestTypeGet:
                [self get:requestURL
                    param:requestParam
             successBlock:successBlock
              failedBlock:failedBlock];
                break;
            case LPAServerAPIManagerRequestTypePost:
                [self post:requestURL
                     param:requestParam
              successBlock:successBlock
               failedBlock:failedBlock];
                break;
            case LPAServerAPIManagerRequestTypeHead:
                [self head:requestURL
                     param:requestParam
              successBlock:successBlock
               failedBlock:failedBlock];
                break;
            case LPAServerAPIManagerRequestTypePut:
                [self put:requestURL
                    param:requestParam
             successBlock:successBlock
              failedBlock:failedBlock];
                break;
            case LPAServerAPIManagerRequestTypePatch:
            case LPAServerAPIManagerRequestTypePatchInURL:
                [self patch:requestURL
                      param:requestParam
               successBlock:successBlock
                failedBlock:failedBlock];
                break;
            case LPAServerAPIManagerRequestTypeDelete:
                [self delete:requestURL
                       param:requestParam
                successBlock:successBlock
                 failedBlock:failedBlock];
                break;
        }
        if (requestTask) {
            self.requesting = YES;
            self.serverRequestURL = requestURL;
            self.serverRequestParam = requestParam;
        }
        [_extraRequestURLMethodParams removeAllObjects];
    });
}

- (void)cancel
{
    
}

- (void)addParamForMethodName:(NSString *)param
{
    if (param) {
        [_extraRequestURLMethodParams addObject:param];
    }else {
        NSAssert(NO, @"(LPAServerAPIManager:addParamForMethodName) param is nil");
    }
}

- (void)addParamsForMethodName:(NSArray *)params
{
    if (params.count) {
        [_extraRequestURLMethodParams addObjectsFromArray:params];
    }else {
        NSAssert(NO, @"(LPAServerAPIManager:addParamsForMethodName) params is nil");
    }
}

#pragma mark - Request Methods (Delegate)

- (NSURLSessionDataTask *)get:(NSString *)requestURL
                        param:(NSDictionary *)param
{
    NSURLSessionDataTask *requestTask = [self.networkManager GET:requestURL
                                                      parameters:param
                                                        progress:^(NSProgress *downloadProgress){
        
                                                        } success:^(NSURLSessionDataTask *task, id responseObject){
                                                            if (self.delegate && [self.delegate respondsToSelector:@selector(serverAPIManager:didRequestSuccess:)]) {
                                                                [self.delegate serverAPIManager:self didRequestSuccess:responseObject];
                                                            }
                                                            [self __requestFinished:task];
                                                        } failure:^(NSURLSessionDataTask *task, NSError *error){
                                                            if (self.delegate && [self.delegate respondsToSelector:@selector(serverAPIManager:didRequestFailed:)]) {
                                                                [self.delegate serverAPIManager:self didRequestFailed:[error lpa_error]];
                                                            }
                                                            [self __requestFinished:task];
                                                        }];
    return requestTask;
}

- (NSURLSessionDataTask *)post:(NSString *)requestURL param:(NSDictionary *)param
{
    NSURLSessionDataTask *requestTask = [self.networkManager POST:requestURL
                                                       parameters:param
                                                         progress:^(NSProgress *downloadProgress){
                                                             
                                                         } success:^(NSURLSessionDataTask *task, id responseObject){
                                                              if (self.delegate && [self.delegate respondsToSelector:@selector(serverAPIManager:didRequestSuccess:)]) {
                                                                  [self.delegate serverAPIManager:self didRequestSuccess:responseObject];
                                                              }
                                                              [self __requestFinished:task];
                                                          } failure:^(NSURLSessionDataTask *task, NSError *error){
                                                              if (self.delegate && [self.delegate respondsToSelector:@selector(serverAPIManager:didRequestFailed:)]) {
                                                                  [self.delegate serverAPIManager:self didRequestFailed:[error lpa_error]];
                                                              }
                                                              [self __requestFinished:task];
                                                          }];
    return requestTask;
}

- (NSURLSessionDataTask *)head:(NSString *)requestURL param:(NSDictionary *)param
{
    NSURLSessionDataTask *requestTask = [self.networkManager HEAD:requestURL
                                                       parameters:param
                                                          success:^(NSURLSessionDataTask *task){
                                                              if (self.delegate && [self.delegate respondsToSelector:@selector(serverAPIManager:didRequestSuccess:)]) {
                                                                  [self.delegate serverAPIManager:self didRequestSuccess:nil];
                                                              }
                                                              [self __requestFinished:task];
                                                          } failure:^(NSURLSessionDataTask *task, NSError *error){
                                                              if (self.delegate && [self.delegate respondsToSelector:@selector(serverAPIManager:didRequestFailed:)]) {
                                                                  [self.delegate serverAPIManager:self didRequestFailed:[error lpa_error]];
                                                              }
                                                              [self __requestFinished:task];
                                                          }];
    return requestTask;
}

- (NSURLSessionDataTask *)put:(NSString *)requestURL param:(NSDictionary *)param
{
    NSURLSessionDataTask *requestTask = [self.networkManager PUT:requestURL
                                                      parameters:param
                                                         success:^(NSURLSessionDataTask *task, id responseObject){
                                                             if (self.delegate && [self.delegate respondsToSelector:@selector(serverAPIManager:didRequestSuccess:)]) {
                                                                 [self.delegate serverAPIManager:self didRequestSuccess:responseObject];
                                                             }
                                                             [self __requestFinished:task];
                                                         } failure:^(NSURLSessionDataTask *task, NSError *error){
                                                             if (self.delegate && [self.delegate respondsToSelector:@selector(serverAPIManager:didRequestFailed:)]) {
                                                                 [self.delegate serverAPIManager:self didRequestFailed:[error lpa_error]];
                                                             }
                                                             [self __requestFinished:task];
                                                         }];
    return requestTask;
}

- (NSURLSessionDataTask *)patch:(NSString *)requestURL param:(NSDictionary *)param
{
    NSURLSessionDataTask *requestTask = [self.networkManager PATCH:requestURL
                                                        parameters:param
                                                           success:^(NSURLSessionDataTask *task, id responseObject){
                                                               if (self.delegate && [self.delegate respondsToSelector:@selector(serverAPIManager:didRequestSuccess:)]) {
                                                                   [self.delegate serverAPIManager:self didRequestSuccess:responseObject];
                                                               }
                                                               [self __requestFinished:task];
                                                           } failure:^(NSURLSessionDataTask *task, NSError *error){
                                                               if (self.delegate && [self.delegate respondsToSelector:@selector(serverAPIManager:didRequestFailed:)]) {
                                                                   [self.delegate serverAPIManager:self didRequestFailed:[error lpa_error]];
                                                               }
                                                               [self __requestFinished:task];
                                                           }];
    return requestTask;
}

- (NSURLSessionDataTask *)delete:(NSString *)requestURL param:(NSDictionary *)param
{
    NSURLSessionDataTask *requestTask = [self.networkManager DELETE:requestURL
                                                         parameters:param
                                                            success:^(NSURLSessionDataTask *task, id responseObject){
                                                                if (self.delegate && [self.delegate respondsToSelector:@selector(serverAPIManager:didRequestSuccess:)]) {
                                                                    [self.delegate serverAPIManager:self didRequestSuccess:responseObject];
                                                                }
                                                                [self __requestFinished:task];
                                                            } failure:^(NSURLSessionDataTask *task, NSError *error){
                                                                if (self.delegate && [self.delegate respondsToSelector:@selector(serverAPIManager:didRequestFailed:)]) {
                                                                    [self.delegate serverAPIManager:self didRequestFailed:[error lpa_error]];
                                                                }
                                                                [self __requestFinished:task];
                                                            }];
    return requestTask;
}

#pragma mark - Request Methods (Block)

- (NSURLSessionDataTask *)get:(NSString *)requestURL
                        param:(NSDictionary *)param
                 successBlock:(LPAServerAPIManagerRequestSuccessHandlerBlock)successBlock
                  failedBlock:(LPAServerAPIManagerRequestFailedHandlerBlock)failedBlock
{
    NSURLSessionDataTask *requestTask = [self.networkManager GET:requestURL
                                                      parameters:param
                                                        progress:^(NSProgress *downloadProgress){
                                                            
                                                        } success:^(NSURLSessionDataTask *task, id responseObject) {
                                                             if (successBlock) {
                                                                 successBlock(responseObject);
                                                             }
                                                             [self __requestFinished:task];
                                                         } failure:^(NSURLSessionDataTask *task, NSError *error){
                                                             if (failedBlock) {
                                                                 failedBlock([error lpa_error]);
                                                             }
                                                             [self __requestFinished:task];
                                                         }];
    return requestTask;
}

- (NSURLSessionDataTask *)post:(NSString *)requestURL
                         param:(NSDictionary *)param
                  successBlock:(LPAServerAPIManagerRequestSuccessHandlerBlock)successBlock
                   failedBlock:(LPAServerAPIManagerRequestFailedHandlerBlock)failedBlock
{
    NSURLSessionDataTask *requestTask = [self.networkManager POST:requestURL
                                                       parameters:param
                                                         progress:^(NSProgress *downloadProgress){
                                                             
                                                         } success:^(NSURLSessionDataTask *task, id responseObject){
                                                              if (successBlock) {
                                                                  successBlock(responseObject);
                                                              }
                                                              [self __requestFinished:task];
                                                          } failure:^(NSURLSessionDataTask *task, NSError *error){
                                                              if (failedBlock) {
                                                                  failedBlock([error lpa_error]);
                                                              }
                                                              [self __requestFinished:task];
                                                          }];
    return requestTask;
}

- (NSURLSessionDataTask *)head:(NSString *)requestURL
                         param:(NSDictionary *)param
                  successBlock:(LPAServerAPIManagerRequestSuccessHandlerBlock)successBlock
                   failedBlock:(LPAServerAPIManagerRequestFailedHandlerBlock)failedBlock
{
    NSURLSessionDataTask *requestTask = [self.networkManager HEAD:requestURL
                                                       parameters:param
                                                          success:^(NSURLSessionDataTask *task){
                                                              if (successBlock) {
                                                                  successBlock(nil);
                                                              }
                                                              [self __requestFinished:task];
                                                          } failure:^(NSURLSessionDataTask *task, NSError *error){
                                                              if (failedBlock) {
                                                                  failedBlock([error lpa_error]);
                                                              }
                                                              [self __requestFinished:task];
                                                          }];
    return requestTask;
}

- (NSURLSessionDataTask *)put:(NSString *)requestURL
                        param:(NSDictionary *)param
                 successBlock:(LPAServerAPIManagerRequestSuccessHandlerBlock)successBlock
                  failedBlock:(LPAServerAPIManagerRequestFailedHandlerBlock)failedBlock
{
    NSURLSessionDataTask *requestTask = [self.networkManager PUT:requestURL
                                                      parameters:param
                                                         success:^(NSURLSessionDataTask *task, id responseObject){
                                                             if (successBlock) {
                                                                 successBlock(responseObject);
                                                             }
                                                             [self __requestFinished:task];
                                                         } failure:^(NSURLSessionDataTask *task, NSError *error){
                                                             if (failedBlock) {
                                                                 failedBlock([error lpa_error]);
                                                             }
                                                             [self __requestFinished:task];
                                                         }];
    return requestTask;
}

- (NSURLSessionDataTask *)patch:(NSString *)requestURL
                          param:(NSDictionary *)param
                   successBlock:(LPAServerAPIManagerRequestSuccessHandlerBlock)successBlock
                    failedBlock:(LPAServerAPIManagerRequestFailedHandlerBlock)failedBlock
{
    NSURLSessionDataTask *requestTask = [self.networkManager PATCH:requestURL
                                                        parameters:param
                                                           success:^(NSURLSessionDataTask *task, id responseObject){
                                                               if (successBlock) {
                                                                   successBlock(responseObject);
                                                               }
                                                               [self __requestFinished:task];
                                                           } failure:^(NSURLSessionDataTask *task, NSError *error){
                                                               if (failedBlock) {
                                                                   failedBlock([error lpa_error]);
                                                               }
                                                               [self __requestFinished:task];
                                                           }];
    return requestTask;
}

- (NSURLSessionDataTask *)delete:(NSString *)requestURL
                           param:(NSDictionary *)param
                    successBlock:(LPAServerAPIManagerRequestSuccessHandlerBlock)successBlock
                     failedBlock:(LPAServerAPIManagerRequestFailedHandlerBlock)failedBlock
{
    NSURLSessionDataTask *requestTask = [self.networkManager DELETE:requestURL
                                                         parameters:param
                                                            success:^(NSURLSessionDataTask *task, id responseObject){
                                                                if (successBlock) {
                                                                    successBlock(responseObject);
                                                                }
                                                                [self __requestFinished:task];
                                                            } failure:^(NSURLSessionDataTask *task, NSError *error){
                                                                if (failedBlock) {
                                                                    failedBlock([error lpa_error]);
                                                                }
                                                                [self __requestFinished:task];
                                                            }];
    return requestTask;
}

#pragma mark - Private Methods

- (void)__requestFinished:(NSURLSessionDataTask *)task
{
    self.endTime = CACurrentMediaTime();
    dispatch_semaphore_signal(_signal);
}

- (NSString *)__requestURL
{
    __block NSString *requestURL = [self.childAPI requestURL];
    NSString *requestMethodName = [self.childAPI requestMethodName];
    if (!requestURL.length) {
        NSAssert(NO, @"Must rewrite requestURL(),return a request URL");
    }
    if (requestMethodName) {
        if (_extraRequestURLMethodParams.count) {
            requestMethodName = [self __requestMethod:requestMethodName index:0];
        }
        requestURL = [NSString stringWithFormat:@"%@/%@", requestURL, requestMethodName];
    }
    return requestURL;
}

- (NSDictionary *)__requestParam
{
    NSMutableDictionary *requestParam = [NSMutableDictionary dictionaryWithDictionary:[self.paramSource paramSourceForServerAPIManager:self]];
    if (_extraParamDictionary.allKeys.count) {
        [requestParam addEntriesFromDictionary:_extraParamDictionary];
    }
    return requestParam;
}

- (NSString *)__requestMethod:(NSString *)requestMethodName index:(NSInteger)index
{
    __block NSInteger extraRequestURLMethodIndex = index;
    __block NSString *extraRequestMethodName = requestMethodName;
    [requestMethodName enumerateSubstringsInRange:NSMakeRange(0, requestMethodName.length)
                                          options:NSStringEnumerationByComposedCharacterSequences
                                       usingBlock:^(NSString *subString, NSRange subStringRange, NSRange enclosingRange, BOOL *stop){
                                           if ([subString isEqualToString:@"@"]) {
                                               extraRequestMethodName = [extraRequestMethodName stringByReplacingCharactersInRange:subStringRange
                                                                                                                        withString:_extraRequestURLMethodParams[extraRequestURLMethodIndex]];
                                               extraRequestURLMethodIndex++;
                                               *stop = YES;
                                               extraRequestMethodName = [self __requestMethod:extraRequestMethodName index:extraRequestURLMethodIndex];
                                           }
                                       }];
    return extraRequestMethodName;
}

#pragma mark - Custom Accessors

- (AFHTTPSessionManager *)networkManager
{
    if (!_networkManager) {
        _networkManager = [[self class] defaultSessionManager];
        _networkManager.requestSerializer.timeoutInterval = _timeoutInterval;
        [_networkManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        _networkManager.securityPolicy.allowInvalidCertificates = _allowInvalidCertificates;
        if ([[self childAPI] requestType] == LPAServerAPIManagerRequestTypePatchInURL) {
            _networkManager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", @"DELETE", @"PATCH", nil];
        }else {
            _networkManager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", @"DELETE", nil];
        }
    }
    return _networkManager;
}

@end

#pragma mark - LPAServerAPIManager (Information)

@implementation LPAServerAPIManager (Information)

- (NSString *)requestFinalURL
{
    return self.serverRequestURL;
}

- (NSDictionary *)requestParamDictionary
{
    return self.serverRequestParam;
}

- (NSTimeInterval)requestTime
{
    return (self.endTime - self.startTime);
}

@end

#pragma mark - NSError (LPAServerAPIManager)

@implementation NSError (LPAServerAPIManager)

- (NSError *)lpa_error
{
    if ([self.domain isEqualToString:AFURLResponseSerializationErrorDomain]) {
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        NSData *responseData = self.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        if (responseData.length) {
            NSDictionary *reseponseDictionary = [NSJSONSerialization JSONObjectWithData:responseData
                                                                                options:NSJSONReadingMutableLeaves
                                                                                  error:nil];
            [userInfo setValue:reseponseDictionary forKey:LPAServerAPIManagerFailureErrorResponseKey];
        }
        NSHTTPURLResponse *httpResponse = self.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
        [userInfo setValue:@(httpResponse.statusCode) forKey:LPAServerAPIManagerFailureErrorServerCodeKey];
        [self.userInfo enumerateKeysAndObjectsUsingBlock:^(NSString *key, id object, BOOL *stop){
            if (![key isEqualToString:AFNetworkingOperationFailingURLResponseDataErrorKey] &&
                ![key isEqualToString:AFNetworkingOperationFailingURLResponseErrorKey]) {
                [userInfo setValue:object forKey:key];
            }
        }];
        return [NSError errorWithDomain:self.domain
                                   code:self.code
                               userInfo:userInfo];
    }else {
        return self;
    }
}

@end
