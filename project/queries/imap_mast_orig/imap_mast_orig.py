select 
    imap_folder_guid,
    imap_img_guid,
    img_guid, 
    img_name, 
    img_etype,
    oi_data, 
    img_exif_date
from (
    select imap_folder_guid,
        imap_img_guid
    from virtual_folder_imagemap
    where imap_folder_guid in ({ids})
    ) vfi
left join image_mast im on im.img_guid = vfi.imap_img_guid
left join orig_images oi on im.img_guid = oi.oi_guid
