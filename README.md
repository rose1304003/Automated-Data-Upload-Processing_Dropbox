# Automated Data Upload & Processing (Dropbox)

## Overview

This project automates the upload, processing, and export of image data stored in Dropbox. It integrates with a structured database to extract, clean, and process images based on metadata. The system ensures seamless image organization and retrieval, reducing manual effort and improving efficiency.

## Features

- **Automated Image Export**: Extracts images from a structured database based on user-defined parameters (Account ID and Batch Count).
- **Database Traversal**: Navigates through hierarchical structures (patients, folders, subfolders) to locate and process images.
- **EXIF Metadata Extraction**: Reads image metadata (timestamps) and applies it to exported files.
- **Optimized File Naming**: Generates structured filenames based on metadata and user-defined rules.
- **SQL-Based Data Processing**: Uses SQL scripts to query and process relevant data.
- **Cross-Language Implementation**: Includes Python for database interactions and Java for image export automation.

## Installation & Setup

### Prerequisites

Ensure you have the following installed:

- **Python 3.x**
- **Java 8+**
- **SQL Server/MySQL** (or relevant database system)
- **Dropbox API** (if integrating with cloud storage)

### Setup Instructions

1. Clone this repository:
   ```sh
   git clone https://github.com/your-username/dropbox-data-processing.git
   cd dropbox-data-processing
   ```
2. Install required Python dependencies:
   ```sh
   pip install -r requirements.txt
   ```
3. Configure the database:
   - Execute `data.sql` in your SQL database.
   - Update database credentials in `load_images_to_db.py`.
4. Run the Python script to load images into the database:
   ```sh
   python load_images_to_db.py
   ```
5. Execute the Java program to export images:
   ```sh
   javac ExportImages.java
   java ExportImages
   ```

## Usage

- Run the Python script to extract and upload images to the database.
- Use the Java program to retrieve, process, and store images with correct metadata.
- Modify batch size and Account ID parameters for customized exports.

## Technologies Used

- **Python**: Data processing, database interaction
- **Java**: Image export automation
- **SQL**: Data storage and retrieval
- **Dropbox API**: Cloud integration (optional)

## Contributing

Feel free to fork this repository and submit pull requests with improvements.

## License

This project is licensed under the MIT License. See `LICENSE` for details.

---

For questions or suggestions, please open an issue or contact the repository owner.

