--
-- View "MY_REPOS"
--
CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_DEVOPS"."MY_REPOS" ("NAME", "OWNER", "DESCRIPTION", "CREATED", "LAST_MODIFIED") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT name, owner, description, created, last_modified 
  FROM dbms_cloud_repo.list_repositories(dbms_cloud_repo.init_github_repo(
        credential_name => 'GITHUB_CRED',       -- Name of the previously created credential
        repo_name       => 'APEX_DevOps',     -- Name of the GitHub Repository
        owner           => 'ORAsonjameyer'      -- Name of the GitHub Repository Owner
    ))
/