from django.shortcuts import render
import pyodbc
def main_view(request):
    if request.method=="POST":
        server='DESKTOP-SOPQU5S\HOSSEIN;'
        db_name='project;'
        conn = pyodbc.connect('Driver={SQL Server};'
                        'Server='+server+
                        'Database='+db_name+
                        'Trusted_Connection=yes;')
        voucherid=request.POST['voucher_id']
        cursor = conn.cursor()
        cursor = conn.cursor()
        cursor.execute("EXEC before_trns @voucher_id2="+voucherid+';')
        cursor.execute(" select * ,'0' as flash, (select isnull(max(fasele),0) from final_Trn_Src_Des) as maxi ,(select isnull(max(fasele),0) from final_Trn_Src_Des) -fasele as p_fasele  from final_Trn_Src_Des  order by fasele,shomare_masir ")
        
        before=cursor.fetchall()   
        cursor.close()
        #before
        for i in range(0,len(before)):
            before[i].p_fasele='a'*before[i].p_fasele
            before[i].maxi='a'*before[i].maxi
            if before[i].tozih == "p bank digar":
                before[i].tozih = "کارت به کارت از بانک دیگر"
            elif before[i].tozih == "p naghdi":
                before[i].tozih ='واریز نقدی'
                before[i].SourceDep= "-"
            elif before[i].tozih == 'main':
                before[i].tozih = 'تراکنش اصلی'
            else :
                before[i].tozih = '<---->'


        for i in range(0,len(before)):
            if before[i].tozih =="تراکنش اصلی":
                a=before[i]
                a.flash=8595
                del before[i]
                before.append(a)
                break
        if (len(before)==1):
            before[0].flash=8595;
        # print(before[0].fasele, before[0].max,type(before[0].fasele),type(before[0].max))
        for i in range(0,len(before)-1):
    # b 8593   p 8595
            if before[i].fasele-1 == 0:
                before[i].flash=8595;
                continue
            else: 
                before[i].flash=8593;
                continue
            # else:
            #     if before[i].fasele == before[i-1].fasele:
            #         if before[i].DesDep != before[i-1].DesDep:
            #             before[i].flash=8595;
            #             continue
            #         else:
            #             before[i].flash=before[i-1].flash
            #             continue
            # if before[i].fasele < len(before[i].maxi)-1:
            #     before[i].flash=8595;
            #     continue
            # elif before[i].fasele > len(before[i].maxi)-1:
            #     if before[i].DesDep == before[i-1].SourceDep:
            #         before[i].flash=8593;
            #         continue
            # else:
            #     before[i].flash=8595;
            #     continue

            
        #end_before
        conn = pyodbc.connect('Driver={SQL Server};'
                        'Server='+server+
                        'Database='+db_name+
                        'Trusted_Connection=yes;')
        cursor = conn.cursor()
        cursor = conn.cursor()
        cursor.execute("EXEC after_trns @voucher_id2="+voucherid+';')
        cursor.execute(" select * ,'0' as flash, (select isnull(max(fasele),0) from final_Trn_Src_Des) as maxi ,(select isnull(max(fasele),0) from final_Trn_Src_Des) -fasele as p_fasele  from final_Trn_Src_Des  order by fasele, shomare_masir ")
        after=cursor.fetchall()   
        cursor.close()
        #after
        for i in range(0,len(after)):
            after[i].p_fasele='a'*after[i].fasele
            after[i].maxi='a'*after[i].maxi
            if after[i].tozih == "v bank digar":
                after[i].tozih = "پایا به بانک دیگر"
            elif after[i].tozih == "b naghd":
                after[i].tozih ='برداشت نقدی'
                after[i].SourceDep= "-"
            elif after[i].tozih == 'main':
                after[i].tozih = 'تراکنش اصلی'
            elif after[i].tozih == 'raket':
                after[i].tozih = 'مانده'
            else :
                after[i].tozih = '<---->'


        
        if (len(after)==1):
            after[0].flash=8595;
        # print(before[0].fasele, before[0].max,type(before[0].fasele),type(before[0].max))
        for i in range(0,len(after)):
    # b 8593   p 8595
            if after[i].tozih=="مانده" or after[i].tozih=="برداشت نقدی" or after[i].tozih=="پایا به بانک دیگر":
                after[i].flash=88;
            
            else: 
                after[i].flash=8595;
                continue

        for i in range(0,len(after)):
            if after[i].tozih =="تراکنش اصلی":
                a=after[i]
                del after[i]
                after.insert(0,a)
                break

            after[0].flash =8595
        print(len(after))
        #end after
        return render(request,'index.html',{'sql':before , 'sql2':after , 'maxx': before[0].maxi*4 })
    else:   
        
        return render(request,'index2.html')  
