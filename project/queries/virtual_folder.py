select fld_guid,
    fld_parent_guid,
    fld_name
from virtual_folder 
where fld_owner = '{account_id}'
