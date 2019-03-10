--------------------------------------------------------
--  File created - Sunday-March-10-2019   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package Body VOLUNTEER3A_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GROUP8"."VOLUNTEER3A_PKG" 
IS
procedure CREATE_LOCATION_PP (
  p_location_id		    OUT	INTEGER,        -- an output parameter
  p_location_country	IN	VARCHAR,        -- must not be NULL
  p_location_postal_code IN	VARCHAR,        -- must not be NULL
  p_location_street1	IN	VARCHAR,
  p_location_street2	IN	VARCHAR,
  p_location_city	    IN	VARCHAR,
  p_location_administrative_region IN VARCHAR
)
IS
location_postal_code_check NUMBER;
location_country_check NUMBER;
location_street1_check NUMBER;
ex_error EXCEPTION;
lv_errormsg_txt VARCHAR(100);

BEGIN

SELECT COUNT (*)
INTO location_postal_code_check
FROM VM_LOCATION
WHERE p_location_postal_code = LOCATION_POSTAL_CODE;

SELECT COUNT (*)
INTO location_country_check
FROM VM_LOCATION
WHERE p_location_country = LOCATION_COUNTRY;

SELECT COUNT (*)
INTO location_street1_check
FROM VM_LOCATION
WHERE p_location_street1 = LOCATION_STREET_1;

IF location_postal_code_check > 0 AND location_country_check > 0 AND location_street1_check > 0 THEN

SELECT LOCATION_ID
INTO p_location_ID
FROM VM_LOCATION
WHERE p_location_postal_code = LOCATION_POSTAL_CODE AND p_location_country = LOCATION_COUNTRY 
AND p_location_street1 = LOCATION_STREET_1;

lv_errormsg_txt := 'this location already exists which is used by LocationID ' || p_location_id;
RAISE ex_Error;

ELSIF location_postal_code_check = 0 AND location_country_check = 0 AND location_street1_check = 0 THEN
p_location_ID := LOCATION_ID_SQ.nextval;

END IF;

IF p_location_country is NULL OR p_location_postal_code is NULL THEN
   RAISE NO_DATA_FOUND;
END IF;

	INSERT INTO VM_LOCATION (
    location_id,
    location_country,
    location_postal_code,
    location_street_1,
    location_street_2,
    location_city,
    location_administrative_region
    
) VALUES (
    inc_seq.nextval,
    p_location_country,
    p_location_postal_code,
    p_location_street1,
    p_location_street2,
    p_location_city,
    p_location_administrative_region    
);

COMMIT;

EXCEPTION
 WHEN ex_error THEN
    DBMS_OUTPUT.PUT_LINE (lv_errormsg_txt);
    ROLLBACK;
 WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Error text:  "Missing mandatory value for parameter (x).  No location added.');
    DBMS_OUTPUT.PUT_LINE(' Error meaning: A mandatory value is missing.  Here, y = ''CREATE_LOCATION_SP''');
    DBMS_OUTPUT.PUT_LINE('Error effect: Because a mandatory value is not provided, no data are 
    inserted into the VM_LOCATION table.  The p_location_id value returned is 
    NULL.');
    ROLLBACK;
 WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE ('THE ERROR CODE IS ' || SQLCODE);
    DBMS_OUTPUT.PUT_LINE ('THE ERROR msg IS ' || SQLERRM);
    ROLLBACK;
END CREATE_LOCATION_PP;
procedure CREATE_PERSON_PP (
    p_person_ID             OUT INTEGER,     -- an output parameter
    p_person_email          IN VARCHAR,  -- Must be unique, not null
    P_person_given_name     IN VARCHAR,  -- NOT NULL, if email is unique (new)
    p_person_surname        IN VARCHAR,  -- NOT NULL, if email is unique (new)
    p_person_phone          IN VARCHAR
)
IS
email_check NUMBER;
ex_Error EXCEPTION;
ex_Error_null EXCEPTION;
lv_errormsg_txt VARCHAR(100);
lv_errormsg_null_txt VARCHAR(300);
BEGIN

SELECT COUNT (*)
INTO email_check
FROM VM_PERSON
WHERE p_person_email = PERSON_EMAIL;

IF email_check > 0 THEN

SELECT PERSON_ID
INTO p_person_ID
FROM VM_PERSON
WHERE p_person_email = PERSON_EMAIL;

lv_errormsg_txt := 'Email address ' || p_person_email || ' is used by Person id ' || p_person_ID;
RAISE ex_Error;

ELSIF email_check = 0 THEN
p_person_ID := PERSON_ID_SEQ.nextval;

END IF;

IF p_person_email is NULL THEN
lv_errormsg_null_txt := 'Because a mandatory value is not provided, no data are inserted into person id '|| p_person_ID || ' , no person added.';
RAISE ex_Error_null;
END IF;


    INSERT INTO vm_person (
    person_id,
    person_email,
    person_given_name,
    person_surname,
    person_phone )
    VALUES (
    p_person_id,
    p_person_email,
    P_person_given_name,
    p_person_surname,
    p_person_phone
);


 COMMIT;
 

  EXCEPTION
  When ex_Error THEN
  DBMS_OUTPUT.PUT_LINE (lv_errormsg_txt);
  ROLLBACK;
  
  WHEN ex_Error_null THEN
  DBMS_OUTPUT.PUT_LINE (lv_errormsg_null_txt);
    
   
   WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE ('THE ERROR CODE IS ' || SQLCODE);
    DBMS_OUTPUT.PUT_LINE ('THE ERROR msg IS ' || SQLERRM);
    ROLLBACK;  
END CREATE_PERSON_PP;
end volunteer3a_pkg;

/
