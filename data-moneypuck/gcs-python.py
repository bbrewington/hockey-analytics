from google.cloud import storage
from google.cloud import bigquery
import os

project_id = 'moneypuckdata-sandbox'
output_dataset = 'DATA'

def upload_blob(project_name, bucket_name, source_file_name, destination_blob_name):
    storage_client = storage.Client(project_name)
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(destination_blob_name)

    blob.upload_from_filename(source_file_name)

    print(
        "File {} uploaded to {}.".format(
            source_file_name, destination_blob_name
        )
    )

objects = ['skaters','goalies','lines','teams','games']
bucket_name = 'moneypuck_data'

for object in objects:
    print('setting up ' + object)
    table_def_file = f'data-moneypuck/bq_table_def_{object}.json'
    source_file = f'data-moneypuck/{object}.csv'
    dest_file = f'{object}.csv'
    table_name = object.upper()

    # upload to GCS
    upload_blob(project_id, bucket_name, source_file, dest_file)

    # Load from GCS csv to BigQuery table
    os.system(
    f'bq load --source_format=CSV --autodetect --replace=true --skip_leading_rows=1' + ' ' + \
    f'{output_dataset}.{table_name} gs://{bucket_name}/{dest_file}'
    )

    print(f'\nCreated table {output_dataset}.{table_name}')
