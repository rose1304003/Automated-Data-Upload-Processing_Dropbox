from concurrent.futures import ThreadPoolExecutor
from datetime import datetime
import pandas as pd
import dropbox
import logging
import time
import os
from requests.exceptions import ConnectionError

script_directory = os.path.dirname(os.path.abspath(__file__))
logs_directory = os.path.join(script_directory, '..', 'logs')


def upload_image_to_dropbox(row, dbx, file):
    img_guid = row['img_guid']
    # print(row)
    if pd.isna(img_guid):
        logging.info(f"Creating folder in Dropbox...")
        try:
            dbx.files_create_folder_v2(path=f"{row['full_path']}")
        except dropbox.exceptions.ApiError as e:
            if 'WriteConflictError' in str(e):
                pass
            elif 'malformed_path' in str(e):
                pass
            else:
                raise e
        except ConnectionError:
            print("Connection refused. Reconnecting...")
            dbx.files_create_folder_v2(path=f"{row['full_path']}")

    else:
        logging.info(f"Uploading image {row['img_name']} to Dropbox...")
        image = row["oi_data"]
        file_path = f"{row['full_path']}/{row['img_name'].strip()}.{row['img_etype']}"

        try:
            dbx.files_upload(bytes(image), 
                         file_path,
                         mode=dropbox.files.WriteMode.overwrite,
                         client_modified=datetime.strptime(str(row['img_exif_date']),  "%Y-%m-%d %H:%M:%S"))
        
        except dropbox.exceptions.ApiError as e:
            if 'malformed_path' in str(e):
                full_path = row['full_path'].split("/")[:3]
                full_path = list(map(str.strip, full_path))
                full_path = '/'.join(full_path) + '/malformed_path'
                malformed_file_path = f"{full_path}/{row['img_guid']}.{row['img_etype']}"
                
                dbx.files_upload(bytes(image), 
                         malformed_file_path,
                         mode=dropbox.files.WriteMode.overwrite,
                         client_modified=datetime.strptime(str(row['img_exif_date']),  "%Y-%m-%d %H:%M:%S"))
                
            else:
                raise e
            
        except ConnectionError:
            print("Connection refused. Reconnecting...")
            dbx.files_upload(bytes(image), 
                         file_path,
                         mode=dropbox.files.WriteMode.overwrite,
                         client_modified=datetime.strptime(str(row['img_exif_date']),  "%Y-%m-%d %H:%M:%S"))
        
        
        file.write(f"{img_guid}\n")
 
        logging.info(f"Image {row['img_name']} successfully uploaded to Dropbox.")
    
    return True



def upload_to_dropbox_concurrently(dbx, df, file):
    with ThreadPoolExecutor(max_workers=8) as executor: 
        results = list(executor.map(upload_image_to_dropbox, [row for _, row in df.iterrows()], [dbx]*len(df), [file]*len(df)))
    return results
