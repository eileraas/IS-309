create tablespace TBS64kb
datafile '/u01/app/oracle/oradata/WOLCOTTDB/' SIZE 10M autoextend on
extent management local uniform size 64 K
segment space management auto;

create tablespace TBS512kb
datafile '/u01/app/oracle/oradata/WOLCOTTDB/' SIZE 10M autoextend on
extent management local uniform size 512 K
segment space management auto;

create tablespace TBS1MB
datafile '/u01/app/oracle/oradata/WOLCOTTDB/' SIZE 10M autoextend on
extent management local uniform size 1 M
segment space management auto;

create tablespace TBS16MB
datafile '/u01/app/oracle/oradata/WOLCOTTDB/' SIZE 10M autoextend on
extent management local uniform size 16 M
segment space management auto;

create tablespace TBS32MB
datafile '/u01/app/oracle/oradata/WOLCOTTDB/' SIZE 10M autoextend on
extent management local uniform size 32 M
segment space management auto;