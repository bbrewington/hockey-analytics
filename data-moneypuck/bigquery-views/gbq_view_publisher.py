from google.cloud import bigquery
import os

def publish_view(project_id, view_sql_path, dest_bq_view):
    with open(view_sql_path, 'r') as file:
        view_sql = file.read()

    client = bigquery.Client(project_id)

    view = bigquery.Table(dest_bq_view)
    view.view_query = view_sql
    view_delete_result = client.delete_table(view) # this is needed to overwrite existing view
    view_create_result = view = client.create_table(view, exists_ok = True)
    print(f"Created {view_create_result.table_type}: {str(view_create_result.reference)}")

def publish_all_views_in_dir(project_id, dirpath):
    bq_view_sql_files = os.listdir(dirpath)
    dataset = 'DATA'
    for v in bq_view_sql_files:
        dest_bq_view = '.'.join([project_id, dataset, v.split('.sql')[0].upper() + '_V'])
        print(dirpath + '/' + v)
        print(dest_bq_view)
        publish_view(project_id = project_id, \
                     view_sql_path = dirpath + '/' + v, \
                     dest_bq_view = dest_bq_view)

publish_all_views_in_dir(project_id = 'moneypuckdata-sandbox', dirpath = 'data-moneypuck/bigquery-views/sql')
