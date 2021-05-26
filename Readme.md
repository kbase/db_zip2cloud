### db_zip2cloud

This is a container for backing up databases such as ArangoDB, compressing the backups and then synchronizing a remote S3 bucket against a local archive of the compressed backups

## Operation

1. [OPTIONAL] Perform a database dump based on environment variables provided, and place it in /dump/
2. Use 7zip to compress and encrypt the contents of the /dump/ directory and put it in into /zip/
   * The resulting zip will have have "dump/" as the relative root directory
3. Prune any files in /zip/ that are older than 30 days
4. Use rclone with an AWS S3 compatible provider to synchronize /zip/ against a remote S3 bucket and directory

This container requires the following secrets to be in /var/run/secrets:
* encryption_key - Encryption key used by 7zip for encryption of compressed files
* s3_access_key  - S3 Access Key for use with rclone
* s3_secret_key  - S3 Secret Key for use with rclone

The following environment variables need to be passed into the runtime environment
* S3_ENDPOINT  - The hostname for the S3 endpoint, without the http:// prefix, for example "storage.googleapis.com"
* BUCKET       - The name of the bucket to be used as the destinatio for copying the backups
* BUCKETPATH   - Path with the bucket to deposit the zipped db files

The following volumes need to be mounted into the running container:
* /dump/   - Directory either containing existing DB dumps or which will be the destination for a DB dump.
* /zip/    - Directory for writing the compressed/encrypted DB dumps before copying to the S3 remote