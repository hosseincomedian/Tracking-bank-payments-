
create procedure  after_trns @voucher_id2 varchar(10)
	as
	begin
		declare @X int;
		declare @Y int;
		declare @tr_date date;
		declare @tr_time varchar(6);
		declare @r_t int;
		declare @after_trn_date date;
		declare @after_trn_time varchar(6);
		declare @amount bigint;
		declare @type_trn varchar(50);
		declare @voucher_id varchar(10);
		declare @fasele int;
		set @voucher_id=@voucher_id2;
		set @after_trn_time ='+00000'   --in time camtar az time vojoodi ast baraye in tarif shode ke agar traconeshe bardasht az y dar haman rooze taraconesh bood tarif va estefade shavad

		insert into temp_Trn_Src_Des
			select *,fasele=0 , shomare_masir=1
			from Trn_Src_Des
			where VoucherId=@voucher_id
		while((select count(VoucherId) from temp_Trn_Src_Des) >0)
		begin
			(select  top 1 @X=SourceDep ,@Y=isnull(DesDep,-1),@tr_date= TrnDate , @tr_time=TrnTime ,@amount = Amount , @voucher_id=VoucherId ,@fasele=fasele
			from temp_Trn_Src_Des
			);
					
			
			if @y in (select Dep_id from Deposit) 
				begin
					set @type_trn='masir';
					set @after_trn_date=(select min(trndate)
									from Trn_Src_Des
									where @Y=SourceDep and (TrnDate>@tr_date or(TrnDate=@tr_date and TrnTime>@tr_time)))
					if (@tr_date = @after_trn_date)
						begin
						  set @after_trn_time = @tr_time 
						end;
					insert into temp_Trn_Src_Des
						select  VoucherId,TrnDate,TrnTime,Amount,SourceDep,DesDep,Branch_ID,Trn_Desc,fasele=@fasele+1,shomare_masir=@voucher_id
						from 
						(
							select *
							from 
							(
	
								select *
								from(
											select *  , sum(Amount) over(order by TrnDate  ,TrnTime ,DesDep Rows between  unbounded preceding and current Row ) as total
											from trn_src_des 
											where SourceDep=@Y and ((TrnDate=@after_trn_date and TrnTime > @after_trn_time) or (TrnDate>@after_trn_date))and amount <>@amount
									) AS a
							) as b
							where total <= @amount+(@amount*0.1)
						) as c
						where VoucherId not in(	select VoucherId
							from trn_src_des
							where SourceDep=@y and TrnDate=@after_trn_date and TrnTime > @after_trn_time )
					
					insert into temp_Trn_Src_Des
						select *,fasele=@fasele+1,shomare_masir=@voucher_id
						from trn_src_des
						where SourceDep=@y and TrnDate=@after_trn_date and TrnTime > @after_trn_time ;
							(select * 
							from temp_Trn_Src_Des);
					if (select count(*) 
						from trn_src_des
						where SourceDep=@y and TrnDate=@after_trn_date and TrnTime > @after_trn_time ) = 0
						begin
							set @type_trn='raket'
						end


				end
			else 
				begin
					if @y =-1
				
						begin
							set @type_trn='b naghd';
						end
					else 
						begin
							set @type_trn='v bank digar';
						end
				end
			if @voucher_id = @voucher_id2 and(select count(*) from temp_Trn_Src_Des)<>1
				begin
					set @type_trn='main'
				end
			insert into final_Trn_Src_Des
				select * , (@type_trn) as tozih
				from temp_Trn_Src_Des
				where VoucherId=@voucher_id
			DELETE 
				FROM   temp_Trn_Src_Des
				where VoucherId = @voucher_id
			set @after_trn_time ='+00000'
	
		end
	end;

