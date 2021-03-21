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

def delete_table(project, dataset, table):
    from google.cloud import bigquery
    table_id = '.'.join([project, dataset, table])
    client = bigquery.Client(project)
    client.delete_table(table_id, not_found_ok=True)  # Make an API request.
    print("Deleted table '{}'.".format(table_id))

objects = ['skaters','goalies','lines','teams']
bucket_name = 'moneypuck_data'

for object in objects:
    print('setting up ' + object)
    table_def_file = f'data-moneypuck/bq_table_def_{object}.json'
    source_file = f'data-moneypuck/{object}.csv'
    dest_file = f'{object}.csv'
    table_name = object.upper()

    delete_table(project_id, output_dataset, table_name)

    # upload to GCS
    upload_blob(project_id, bucket_name, source_file, dest_file)

    # create definition file, and save as json
    os.system(
    f'bq mkdef --autodetect --source_format=CSV' + \
    ' ' + \
    f'gs://{bucket_name}/{dest_file} > {table_def_file}'
    )

    # using above definition file, create bigquery external table
    os.system(f'bq mk --force=true' + \
    ' ' + \
    f'--external_table_definition={table_def_file}' + \
    ' ' + \
    f'{output_dataset}.{table_name}'
    )

    print(f'Created table {output_dataset}.{table_name}')
