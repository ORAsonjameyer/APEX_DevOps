--
-- Package_Spec "DEVOPS"
--
CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_DEVOPS"."DEVOPS" as
  -- Spezifikation des Packages "DEVOPS"

  -- Prozedur zur Erstellung eines Cloud-Credentials
  PROCEDURE create_credential(
        p_cred_name IN VARCHAR2, -- Name des Credentials, z. B. 'DEV_TEST'
        p_username IN VARCHAR2,  -- Benutzername für das Credential
        p_password IN VARCHAR2); -- Passwort für das Credential
  
  -- Prozedur zum Exportieren von Objekten in ein GitHub-Repository
  PROCEDURE export_objects_to_github;

end "DEVOPS";
/