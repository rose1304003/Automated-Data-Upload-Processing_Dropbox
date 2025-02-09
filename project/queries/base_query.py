select fld_guid, 
    fld_name,
    concat('/', fld_owner, '/', pat_lname, ',', pat_fname, ',', pat_mname, '(', date(pat_bdate), '),', fld_guid) pat_fullname,
    concat('/', fld_owner, '/', pat_lname, ',', pat_fname, ',', pat_mname, '(', date(pat_bdate), '),', fld_guid) full_path
from virtual_folder, patient_info
where virtual_folder.fld_owner = '{account_id}'
and virtual_folder.fld_guid = patient_info.pat_fguid

union all

select fld_guid,
    fld_name,
    concat('/', fld_owner, '/', fld_name, '(', fld_guid, ')') pat_fullname,
    concat('/', fld_owner, '/', fld_name, '(', fld_guid, ')') full_path
from virtual_folder
where fld_parent_guid = 'ph-{account_id}-tbf'   
