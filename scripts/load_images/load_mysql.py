import mysql.connector
import os

"""
==================================================================================
Script Name: Upload Images to MySQL
==================================================================================
Purpose:
    This script uploads image files as BLOBs into a MySQL database.
    It checks for file existence, handles database errors, and ensures 
    proper resource cleanup.

Warnings:
    - Ensure the MySQL server is running and accessible.
    - Update the file paths correctly before running the script.
    - This script overwrites existing records with the same oi_guid.
==================================================================================
"""

def convert_to_binary_data(filename):
    """Convert a file into binary format for database storage."""
    try:
        with open(filename, 'rb') as file:
            return file.read()
    except FileNotFoundError:
        print(f"Warning: File {filename} not found. Skipping upload.")
        return None

def insert_blob(oi_guid, oi_data):
    """Insert an image into the MySQL database as a BLOB."""
    try:
        # Establish database connection
        cnx = mysql.connector.connect(
            user='admin', 
            password='09062003u',
            host='localhost',
            database='drop_box'
        ) 
        cursor = cnx.cursor()

        sql_insert_blob_query = """ INSERT INTO orig_images (oi_guid, oi_data) VALUES (%s, %s) """
        
        binary_image = convert_to_binary_data(oi_data)
        if binary_image is None:
            print(f"Skipping {oi_guid} due to missing file.")
            return

        insert_blob_tuple = (oi_guid, binary_image)
        cursor.execute(sql_insert_blob_query, insert_blob_tuple)
        cnx.commit()
        print(f"Successfully inserted: {oi_guid}")
    
    except mysql.connector.Error as error:
        print(f"Error inserting BLOB data into MySQL table: {error}")
    
    finally:
        if 'cnx' in locals() and cnx.is_connected():
            cursor.close()
            cnx.close()
            print("MySQL connection closed.")

# List of images to upload (Update paths accordingly)
image_data = [
    ('i1-1-1-1', "path/to/image1.jpeg"),
    ('i1-1-1-2', "path/to/image2.jpeg"),
    ('i1-1-2-1', "path/to/image3.jpeg"),
    ('i1-1-2-1-1', "path/to/image4.jpeg"),
    ('i1-1-2-2-1-1', "path/to/image5.jpeg"),
    ('i1-2-1-1', "path/to/image6.jpeg"),
    ('i2-1-1', "path/to/image7.jpeg")
]

# Iterate and insert each image
for guid, filepath in image_data:
    insert_blob(guid, filepath)

print("Image upload process completed.")

