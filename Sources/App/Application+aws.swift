//===----------------------------------------------------------------------===//
//
// This source file is part of the AWSSDKSwift open source project
//
// Copyright (c) 2017-2020 the AWSSDKSwift project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of AWSSDKSwift project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

import AWSS3
import Vapor

public extension Application {
    var aws: AWS {
        .init(application: self)
    }

    struct AWS {
        struct ClientKey: StorageKey {
            typealias Value = AWSClient
        }

        public var client: AWSClient {
            get {
                guard let client = self.application.storage[ClientKey.self] else {
                    fatalError("AWSClient not setup. Use application.aws.client = ...")
                }
                return client
            }
            nonmutating set {
                self.application.storage.set(ClientKey.self, to: newValue) {
                    try $0.syncShutdown()
                }
            }
        }

        struct ServiceKey<T>: StorageKey {
            typealias Value = T
        }

        func getService<T>() -> T {
            return getService(key: ServiceKey<T>.self)
        }

        func setService<T>(_ service: T) {
            setService(service, key: ServiceKey<T>.self)
        }

        func getService<T, Key: StorageKey>(key: Key.Type) -> T where Key.Value == T {
            guard let service = self.application.storage[Key.self] else {
                fatalError("\(T.self) not setup. Use application.aws.client = ...")
            }
            return service
        }

        func setService<T, Key: StorageKey>(_ service: T, key: Key.Type) where Key.Value == T {
            self.application.storage[Key.self] = service
        }

        let application: Application
    }
}

extension Application.AWS {
/*    public var s3: S3 {
        get { getService() }
        nonmutating set { setService(newValue) }
    }*/
}

extension Application.AWS {
    struct S3Key: StorageKey {
        typealias Value = S3
    }

    public var s3: S3 {
        get {
            guard let s3 = self.application.storage[S3Key.self] else {
                fatalError("S3 not setup. Use application.aws.s3 = ...")
            }
            return s3
        }
        nonmutating set {
            self.application.storage[S3Key.self] = newValue
        }
    }
}

public extension Request.AWS {
    var s3: S3 {
        return request.application.aws.s3
    }
}
