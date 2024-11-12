--
-- Package_Body "DEVOPS_BRANCH"
--
CREATE OR REPLACE EDITIONABLE PACKAGE BODY "WKSP_DEVOPS"."DEVOPS_BRANCH" as

    PROCEDURE Create_Repository(
        p_credential_name IN VARCHAR2,
        p_repo_name       IN VARCHAR2,
        p_repo_owner      IN VARCHAR2,
        p_description     IN VARCHAR2 DEFAULT 'Repo created',
        p_private         IN BOOLEAN DEFAULT TRUE
    ) IS
        l_repo_handle CLOB;
    BEGIN
        -- Initialize the GitHub repository handle
        l_repo_handle := dbms_cloud_repo.init_github_repo(
                             credential_name => p_credential_name,
                             repo_name       => p_repo_name,
                             owner           => p_repo_owner
                         );

        -- Create the GitHub repository
        dbms_cloud_repo.create_repository(
            repo        => l_repo_handle,
            description => p_description,
            private     => p_private
        );
        
        dbms_output.put_line('Repository ' || p_repo_name || ' created successfully.');
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('Error: ' || SQLERRM);
    END Create_Repository;

end "DEVOPS_BRANCH";
/