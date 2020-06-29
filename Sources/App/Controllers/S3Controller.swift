import AWSS3
import Vapor

extension S3.HeadObjectOutput : Content {

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(contentLength, forKey: .contentLength)
        try container.encode(contentType, forKey: .contentType)
        try container.encode(eTag, forKey: .eTag)
        try container.encode(lastModified, forKey: .lastModified)
        try container.encode(storageClass, forKey: .storageClass)
        try container.encode(versionId, forKey: .versionId)
    }
    
    private enum CodingKeys: String, CodingKey {
        case contentLength = "Content-Length"
        case contentType = "Content-Type"
        case eTag = "ETag"
        case lastModified = "Last-Modified"
        case storageClass = "x-amz-storage-class"
        case versionId = "x-amz-version-id"
    }
}

class S3Controller {

    func buckets(_ req: Request) -> EventLoopFuture<[String]> {
        print("buckets")
        return req.aws.s3.listBuckets().map { output in
            return output.buckets?.compactMap { $0.name } ?? []
        }.flatMapErrorThrowing { error in
            print("\(error)")
            if let error = error as? AWSErrorType {
                throw Abort(.badRequest, reason: error.description)
            }
            throw error
        }
    }
    
    func headObject(_ req: Request) -> EventLoopFuture<S3.HeadObjectOutput> {
        let bucket = req.parameters.get("bucket")!
        let file = req.parameters.get("file")!
        let request = S3.HeadObjectRequest(bucket: bucket, key: file)
        return req.aws.s3.headObject(request)
            .flatMapErrorThrowing { error in
                if let error = error as? AWSErrorType {
                    throw Abort(.badRequest, reason: error.description)
                }
                throw error
        }
    }
    
    func objects(_ req: Request) -> EventLoopFuture<[String]> {
        let bucket = req.parameters.get("bucket")!
        let request = S3.ListObjectsRequest(bucket: bucket, maxKeys: 100)
        return req.aws.s3.listObjects(request).map { output in
            return output.contents?.compactMap { $0.key } ?? []
        }.flatMapErrorThrowing { error in
            if let error = error as? AWSErrorType {
                throw Abort(.badRequest, reason: error.description)
            }
            throw error
        }
    }
}
