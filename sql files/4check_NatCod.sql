create function my_func(@NatCod varchar(10))
returns varchar(50)
as
begin
	declare @NatCod_int int;
	declare @ok varchar(50);
	declare @sum int;
	
	set @sum=0
	declare @NatCod_int2 int;
	declare @f_number int;
		set @NatCod_int= @NatCod;
		set @NatCod_int2=@NatCod_int/10;
		set @f_number = @NatCod_int%10;
		if (len(@NatCod) < 10)
			begin
			  set @ok= 'it is not true'
			end;
		else  
			begin	
			  declare @i int=2
			  while @i<11
			  begin
				set @sum = @sum+((@NatCod_int2%10)*@i)     
				set @NatCod_int2=@NatCod_int2/10				
				set @i=@i+1
			  end;
			  if @sum%11 <2
				begin
				  if @sum%11 =@f_number
					begin
						set @ok= 'it is true'
					end;
				  else  
					begin
					   set @ok= 'it is not true'
				    end;
				end;
			  else 
				begin
				  if 11-@sum%11=@f_number
					begin
					  set @ok='it is true'
					end;
				  else  
					begin
					   set @ok= 'it is not true'
					end;
				end;
			end;
	return (@ok)
end;

CREATE VIEW check_NatCod AS
select *, dbo.my_func(NatCod) as NatCod_ver
from Customer


