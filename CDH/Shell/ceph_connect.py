import boto
import boto.s3.connection
access_key = 'BBBBBBBBBBBBBBBBBBBB'
secret_key = 'eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee'

conn = boto.connect_s3(
        aws_access_key_id = access_key,
        aws_secret_access_key = secret_key,
        host = '10.125.137.200', port=8000,
        is_secure=False, calling_format = boto.s3.connection.OrdinaryCallingFormat(),
        )

for bucket in conn.get_all_buckets():
        print "{name}\t{created}".format(
                name = bucket.name,
                created = bucket.creation_date,
        )




----------

import boto
import boto.s3.connection

access_key = 'BBBBBBBBBBBBBBBBBBBB'
secret_key = 'eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee'
conn = boto.connect_s3(
        aws_access_key_id = access_key,
        aws_secret_access_key = secret_key,
        host = '{hostname}', port = {port},
        is_secure=False, calling_format = boto.s3.connection.OrdinaryCallingFormat(),
        )

bucket = conn.create_bucket('my-new-bucket')
    for bucket in conn.get_all_buckets():
            print "{name}".format(
                    name = bucket.name,
                    created = bucket.creation_date,
 )



---
conn = S3Connection('BBBBBBBBBBBBBBBBBBBB', 'eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee')

for bucket in conn.get_all_buckets():
    print "{name}\t{created}".format(name = bucket.name)


for bucket in conn.get_all_buckets():
         print "{name}\t{created}".format(
                 name = bucket.name,
                 created = bucket.creation_date,
         )