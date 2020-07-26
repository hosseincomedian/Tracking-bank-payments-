--first

create table temp_Trn_Src_Des(
	VoucherId	varchar (10),
	TrnDate		date,
	TrnTime		varchar(6),
    Amount      bigint,
    SourceDep   INT,
    DesDep      INT,
    Branch_ID   INT,
    Trn_Desc    varchar(50),
	fasele      int DEFAULT 0, 
	shomare_masir int DEFAULT 0,
	Primary key(VoucherId),
	FOREIGN KEY (Branch_ID) REFERENCES Branch(Branch_ID),
);



create table final_Trn_Src_Des(
	VoucherId	varchar (10),
	TrnDate		date,
	TrnTime		varchar(6),
    Amount      bigint,
    SourceDep   INT,
    DesDep      INT,
    Branch_ID   INT,
    Trn_Desc    varchar(50),
	fasele      int DEFAULT 0, 
	shomare_masir int DEFAULT 0,
	tozih       varchar(50),
	Primary key(VoucherId),
	FOREIGN KEY (Branch_ID) REFERENCES Branch(Branch_ID),
);