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
                    fatalError("AWSClient not setup. Use application.aws = ...")
                }
                return client
            }
            nonmutating set {
                self.application.storage[ClientKey.self] = newValue
            }
        }

        struct S3Key: StorageKey {
            typealias Value = S3
        }

        public var s3: S3 {
            get {
                guard let s3 = self.application.storage[S3Key.self] else {
                    fatalError("AWSClient not setup. Use application.aws = ...")
                }
                return s3
            }
            nonmutating set {
                self.application.storage[S3Key.self] = newValue
            }
        }

        let application: Application
    }
}

