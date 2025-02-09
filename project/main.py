import os
import sys
import json
import logging
import pandas as pd
import pymysql
import dropbox

from datetime import datetime
from timeit import default_timer as timer
from modules import data_processing, dropbox_upload
from tqdm import tqdm

# -------------------------------
# Script Purpose:
# This script processes accounts from a database, extracts virtual folder structures,
# filters out already processed items, and uploads images to Dropbox in chunks.
# It maintains logs and archives to track processed accounts and files.
# -------------------------------

def read_secrets(file_path='secrets.json'):
    """
    Reads sensitive credentials from a JSON file.
    
    :param file_path: Path to the secrets file.
    :return: Dictionary containing credentials.
    """
    with open(file_path) as s:
        secrets = json.load(s)
    return secrets

def config(account_id):
    """
    Initializes necessary archive files for tracking processed folders and images.
    
    :param account_id: ID of the account being processed.
    """
    archive_name = f'archive/{account_id}-ids.csv'
    folder_filename = f'archive/{account_id}-folder-ids'
    
    for filename in [archive_name, folder_filename]:
        if not os.path.exists(filename):
            with open(filename, 'w') as f:
                f.write('id\n')

def main():
    """
    Main function that orchestrates the extraction, processing, and uploading of account images.
    """
    start_time = timer()
    
    # Set up logging
    logging.basicConfig(
        filename='logs/app.log', 
        level=logging.INFO, 
        format='%(asctime)s - %(levelname)s - %(message)s'
    )
    
    # Argument validation (Chunk size must be provided)
    if (args_count := len(sys.argv)) != 2:
        print(f'Expected one argument (chunk size), got {args_count - 1}')
        raise SystemExit(2)
    
    chunk_size = int(sys.argv[1])
    begin_date = datetime.now()
    logging.info(f"Process started at {begin_date.strftime('%Y-%m-%d %H:%M:%S')}")
    print(f"Process started at {begin_date.strftime('%Y-%m-%d %H:%M:%S')}")
    
    # Ensure the loaded accounts tracking file exists
    if not os.path.exists('accounts/loaded_accounts.csv'):
        with open('accounts/loaded_accounts.csv', 'w') as f:
            f.write('account_id\n')
    
    # Load processed and unprocessed accounts
    loaded_accounts = pd.read_csv('accounts/loaded_accounts.csv').squeeze('columns')
    accounts = pd.read_csv('accounts/accounts.csv')
    ready_accounts = accounts[accounts['ready_to_share'] == 1]
    ready_accounts = ready_accounts[~ready_accounts['account_id'].isin(loaded_accounts)]
    
    # Load database credentials
    secrets = read_secrets()
    
    # Process each account
    for _, row in ready_accounts.iterrows():
        account_id = row['account_id']
        config(account_id)
        print(f"Processing account {account_id}")
        account_start_time = timer()
        
        # Database Connection
        logging.info("Connecting to database...")
        cnx = pymysql.connect(
            user=secrets["USER"],
            password=secrets["PASSWORD"],
            host=secrets["HOST"],
            database=secrets["DATABASE"],
            charset="utf8"
        )
        
        # Data extraction
        logging.info("Fetching data from database...")
        vf_df = data_processing.get_virtual_folder_df(cnx, account_id)
        base_df = data_processing.get_base_df(cnx, account_id)
        
        # Folder hierarchy processing
        logging.info("Calculating folder paths...")
        vfwp_df = data_processing.get_hierarchy(vf_df, base_df)
        
        # Load already processed folder IDs
        folder_filename = f'archive/{account_id}-folder-ids.csv'
        folder_ids = pd.read_csv(folder_filename).squeeze('columns')
        vfwp_df = vfwp_df[~vfwp_df['fld_guid'].isin(folder_ids)]
        
        # Dropbox Connection
        logging.info("Connecting to Dropbox...")
        dbx = dropbox.Dropbox(oauth2_access_token=secrets["ACCESS_TOKEN"])
        
        # Processing in chunks
        archive_filename = f"archive/{account_id}-ids.csv"
        total_rows = len(vfwp_df)
        
        for i in tqdm(range(0, total_rows, chunk_size), desc=f"Processing account {account_id}"):
            chunk = vfwp_df.iloc[i:i + chunk_size]
            chunk['full_path'] = chunk.apply(data_processing.replace_long_paths, axis=1)
            
            # Fetch image metadata
            fld_id_string = chunk['fld_guid'].apply(lambda x: f"'{x}'").str.cat(sep=',')
            imap_mast_orig_query = data_processing.get_query('queries/imap_mast_orig.sql').format(ids=fld_id_string)
            imap_mast_orig_df = pd.read_sql(imap_mast_orig_query, cnx)
            
            # Filter out already uploaded images
            ids = pd.read_csv(archive_filename).squeeze('columns')
            result_df = pd.merge(chunk, imap_mast_orig_df, left_on='fld_guid', right_on='imap_folder_guid', how='left')
            result_df = result_df.fillna(value={'oi_data': b''})
            result_df = result_df[~result_df['imap_img_guid'].isin(ids)]
            
            if len(result_df) == 0:
                continue
            
            # Upload images to Dropbox
            logging.info("Uploading images to Dropbox...")
            with open(archive_filename, 'a') as f:
                dropbox_upload.upload_to_dropbox_concurrently(dbx, result_df, f)
            
            # Mark processed folder IDs
            with open(folder_filename, 'a') as f:
                f.write(f"{chunk['fld_guid'].str.cat(sep='\n')}\n")
        
        # Mark the account as processed
        with open('accounts/loaded_accounts.csv', 'a') as f:
            f.write(f'{account_id}\n')
        
        print(f"Finished processing account {account_id}: {timer() - account_start_time}s")
        cnx.close()
    
    # Process completion log
    end_time = timer()
    logging.info(f"Total execution time: {end_time - start_time} seconds")
    print(f"Total execution time: {end_time - start_time} seconds")
    
    now = datetime.now()
    logging.info(f"Process started at {begin_date} and ended at {now}")
    print(f"Process started at {begin_date} and ended at {now}")

if __name__ == "__main__":
    main()
