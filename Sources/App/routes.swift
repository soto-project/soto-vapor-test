import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }
    
    let s3Controller = S3Controller()
    app.get("bucket", use: s3Controller.buckets)
    app.get("bucket", ":bucket", use: s3Controller.objects)
}
