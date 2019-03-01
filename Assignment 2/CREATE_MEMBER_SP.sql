create or replace procedure CREATE_MEMBER_SP (
    p_person_ID             OUT INTEGER,     -- an output parameter
    p_person_email          IN  VARCHAR,  -- passed through to CREATE_PERSON_SP
    P_person_given_name     IN  VARCHAR,  -- passed through to CREATE_PERSON_SP
    p_person_surname        IN  VARCHAR,  -- passed through to CREATE_PERSON_SP
    p_person_phone          IN  VARCHAR,  -- passed through to CREATE_PERSON_SP
    p_location_id	          IN  VARCHAR,
    p_location_country	    IN  VARCHAR,  -- passed through to CREATE_LOCATION_SP
    p_location_postal_code  IN	VARCHAR,  -- passed through to CREATE_LOCATION_SP
    p_location_street1	    IN	VARCHAR,  -- passed through to CREATE_LOCATION_SP
    p_location_street2	    IN	VARCHAR,  -- passed through to CREATE_LOCATION_SP
    p_location_city	        IN	VARCHAR,  -- passed through to CREATE_LOCATION_SP
    p_location_administrative_region IN VARCHAR, -- passed through to CREATE_LOCATION_SP
    p_member_password       IN  VARCHAR   -- NOT NULL 
)
IS
email_check NUMBER;
locationid_check NUMBER;
lv_person_id_num     VM_MEMBER.PERSON_ID%TYPE;
lv_p_location_id_num VM_LOCATION.LOCATION_ID%TYPE;
ex_Error EXCEPTION;
ex_error1 Exception;
lv_errormsg_txt VARCHAR(100);
lv_errormsg1_txt VARCHAR(100);

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

SELECT COUNT (*)
INTO locationid_check
FROM VM_LOCATION
WHERE p_location_id = LOCATION_ID;

IF locationid_check > 0 THEN

lv_errormsg1_txt := 'Location ' || p_location_id || ' is used ';
RAISE ex_Error1;

END IF;
  
IF p_person_id is NULL THEN
   RAISE ex_Error;
    END IF;

IF p_location_id is NULL THEN
   RAISE ex_Error;
    END IF;

   INSERT INTO VM_PERSON(
    person_id,
    person_email,
    person_given_name,
    person_surname,
    person_phone
    )
    VALUES (
    p_person_id,
    p_person_email,
    P_person_given_name,
    p_person_surname,
    p_person_phone
    
);

    INSERT INTO VM_LOCATION (
    location_id,
    location_country,
    LOCATION_POSTAL_CODE,
    LOCATION_STREET_1,
    location_street_2,
    location_city,
    location_administrative_region) 
    
    VALUES (
    p_location_id,
    p_location_country,
    p_LOCATION_POSTAL_CODE,
    p_location_street1,
    p_location_street2,
    p_location_city,
    p_location_administrative_region
    
);

   INSERT INTO VM_MEMBER(
    person_id,
    member_password,
    location_id
    )
    
    VALUES (
    p_person_id,
    p_member_password,
    p_location_id
);

EXCEPTION
 WHEN ex_Error THEN
    DBMS_OUTPUT.PUT_LINE (lv_errormsg_txt);
    DBMS_OUTPUT.PUT_LINE('Error text:  "Missing mandatory value for parameter (x)  in context (y).  No member added."');
    DBMS_OUTPUT.PUT_LINE('Error meaning: A mandatory value is missing.  Here, y = "CREATE_MEMBER_SP"');
    DBMS_OUTPUT.PUT_LINE('Error effect: Because a mandatory value is not provided, no data are 
            inserted into the VM_MEMBER table.  The p_person_id value returned 
            is NULL.  ');
    ROLLBACK;
  WHEN ex_Error1 THEN 
    DBMS_OUTPUT.PUT_LINE (lv_errormsg1_txt);
    ROLLBACK;
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Error text:  "Invalid value (x) in context (y). No member created."');
    DBMS_OUTPUT.PUT_LINE('Error meaning:  A value for parameter x is not valid.  Here, y = "CREATE_MEMBER_SP".
        This could arise if the person_id returned by CREATE_PERSON_SP is not valid,
        or the location_id returned by CREATE_LOCATION_SP is not valid. ');
    ROLLBACK;
 WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE ('THE ERROR CODE IS ' || SQLCODE);
    DBMS_OUTPUT.PUT_LINE ('THE ERROR msg IS ' || SQLCODE);
    ROLLBACK;
END;
