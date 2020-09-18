import SotoS3
import Vapor

// configures your application
public func configure(_ app: Application) throws {

    app.aws.client = AWSClient(
        httpClientProvider: .shared(app.http.client.shared),
        logger: app.logger
    )
    app.aws.s3 = S3(client: app.aws.client, region: .euwest1)

    // register routes
    try routes(app)
}
