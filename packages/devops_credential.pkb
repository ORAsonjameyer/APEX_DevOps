--
-- Package_Body "DEVOPS_CREDENTIAL"
--
CREATE OR REPLACE EDITIONABLE PACKAGE BODY "WKSP_DEVOPS"."DEVOPS_CREDENTIAL" as

  PROCEDURE create_credential
    ( p_cred_name IN VARCHAR2, -- default 'DEV_TEST', 
      p_username IN VARCHAR2,
      p_password IN VARCHAR2 )  -- default 'Dev_Ops_2024'
  IS

  BEGIN
    dbms_cloud.create_credential (
      credential_name => p_cred_name,
      username        => p_username,
      password        => p_password
    );
  END create_credential;

end "DEVOPS_CREDENTIAL";
/