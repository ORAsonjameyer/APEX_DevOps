--
-- Package_Spec "DEVOPS_BRANCH"
--
CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_DEVOPS"."DEVOPS_BRANCH" as

    -- Procedure to initialize and create a GitHub repository
    PROCEDURE Create_Repository(
        p_credential_name IN VARCHAR2,
        p_repo_name       IN VARCHAR2,
        p_repo_owner      IN VARCHAR2,
        p_description     IN VARCHAR2 DEFAULT 'Repo created',
        p_private         IN BOOLEAN DEFAULT TRUE
    );
    
end "DEVOPS_BRANCH";
/