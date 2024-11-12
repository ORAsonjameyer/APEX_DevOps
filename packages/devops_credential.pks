--
-- Package_Spec "DEVOPS_CREDENTIAL"
--
CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_DEVOPS"."DEVOPS_CREDENTIAL" as
  -- PROCEDURE grant_execute_permission;
  
  PROCEDURE create_credential(
        p_cred_name IN VARCHAR2, -- DEFAULT 'DEV_TEST', 
        p_username IN VARCHAR2, 
        p_password IN VARCHAR2)     --  DEFAULT 'Dev_Ops_2024'
        ;

end "DEVOPS_CREDENTIAL";
/