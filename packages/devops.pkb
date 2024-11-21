--
-- Package_Body "DEVOPS"
--
CREATE OR REPLACE EDITIONABLE PACKAGE BODY "WKSP_DEVOPS"."DEVOPS" AS

-- Definition der Prozedur create_credential, um ein Cloud-Credential zu erstellen
  PROCEDURE create_credential
    ( p_cred_name IN VARCHAR2, -- default 'DEV_TEST', 
      p_username IN VARCHAR2,
      p_password IN VARCHAR2 )  -- default 'Dev_Ops_2024'
  IS
  BEGIN
    dbms_cloud.create_credential 
    ( credential_name => p_cred_name,
      username        => p_username,
      password        => p_password
    );
  END create_credential;

-- Definition der Prozedur create_branch, um einen Branch in einem GitHub-Repository zu erstellen
  PROCEDURE create_branch
    ( p_credname  IN VARCHAR2,
      p_reponame  IN VARCHAR2,
      p_repoowner IN VARCHAR2 )
  IS
    repoHandle CLOB;
  BEGIN
    repoHandle := dbms_cloud_repo.init_github_repo(
                   credential_name => p_credname,
                   repo_name       => p_reponame,
                   owner           => p_repoowner
                 );

    dbms_cloud_repo.create_branch(
        repo                => repoHandle,
        branch_name         => 'first_branch',
        parent_branch_name  => 'main'
    );  
  END create_branch;


END "DEVOPS";
/