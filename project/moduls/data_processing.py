import pandas as pd
import os
import sys

sys.setrecursionlimit(10000)

script_directory = os.path.dirname(os.path.abspath(__file__))
query_directory = os.path.join(script_directory, '..', 'queries')

def get_query(query_name):
    with open(query_name) as q:
        return q.read()

def get_base_df(cnx, account_id):
    base_query = get_query(f'{query_directory}/base_query.sql').format(account_id=account_id)
    return pd.read_sql(base_query, cnx)

def get_virtual_folder_df(cnx, account_id):
    vf_query = get_query(f'{query_directory}/virtual_folder.sql').format(account_id=account_id)
    return pd.read_sql(vf_query, cnx)

def get_hierarchy(vf_df, df):
    if len(df) == 0:
        return df

    ndf = pd.merge(vf_df, df[['fld_guid', 'pat_fullname', 'full_path']], 
                    how='inner', 
                    left_on='fld_parent_guid', 
                    right_on='fld_guid',
                    left_index=False,
                    right_index=False)
    
    ndf = ndf.assign(
                full_path=ndf['full_path'] + '/' + ndf['fld_name'] + '(' + ndf['fld_guid_x'] + ')'
            ).rename(
                columns={'fld_guid_x': 'fld_guid'}
            )[['fld_guid', 'pat_fullname', 'fld_name', 'full_path']]

    return pd.concat([df, get_hierarchy(vf_df, ndf)])


def replace_long_paths(row):
    full_path = row['full_path']
    if len(full_path) > 200:
        return row['pat_fullname'] + '/BULK_EXPORT/' + row['fld_name']
    
    return full_path
