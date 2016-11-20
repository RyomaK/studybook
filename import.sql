create table scores(
    user_id integer,
  	grade integer,
    test text,
    semester integer,
    japanese integer,
    math integer,
    english integer,
    science integer,
    social integer
);

create table users(
	user_id integer primary key,
	user_name text,
	user_pass text,
	school_name text
);