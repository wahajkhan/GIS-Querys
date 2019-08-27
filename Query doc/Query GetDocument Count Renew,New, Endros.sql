
select a.PLC_LOCADESC,
a.NewDocCount,a.newPremium,a.newSumInsured,  
b.RenewalDocCount,b.renewPremium,b.renewSumInsured, 
C.EndrosmentDocCount,C.EndrosmentPremium,C.EndrosmentSumInsured 
,
d.CoverNoteDocCount,d.CoverNotePremium,d.CoverNoteSumInsured

from (
select l.PLC_LOCADESC, 
count(h.GDH_DOC_REFERENCE_NO) NewDocCount,sum(pv.GROSSPREM+pv.ADMIN)newPremium,sum(pv.SUMINSURED) newSumInsured 
from GI_GU_DH_DOC_HEADER h
inner join pr_gn_lc_location l on l.PLC_LOC_CODE=h.PLC_LOC_CODE
inner join PREMIUM_VIEW pv on pv.DOCREFNO=h.GDH_DOC_REFERENCE_NO
where h.GDH_year='2018'
and h.GDH_BASEDOCUMENTNO is null
group by l.PLC_LOCADESC
) a

left join ( 
select l.PLC_LOCADESC, 
count(h.GDH_DOC_REFERENCE_NO) RenewalDocCount,sum(pv.GROSSPREM+pv.ADMIN)renewPremium,sum(pv.SUMINSURED) renewSumInsured 
from GI_GU_DH_DOC_HEADER h
inner join pr_gn_lc_location l on l.PLC_LOC_CODE=h.PLC_LOC_CODE
inner join PREMIUM_VIEW pv on pv.DOCREFNO=h.GDH_DOC_REFERENCE_NO
where h.GDH_year='2018'
and h.GDH_BASEDOCUMENTNO is not null
group by l.PLC_LOCADESC
) b on a.PLC_LOCADESC=b.PLC_LOCADESC

left join (select l.PLC_LOCADESC, 
count(h.GDH_DOC_REFERENCE_NO) EndrosmentDocCount ,sum(pv.GROSSPREM+pv.ADMIN)EndrosmentPremium,sum(pv.SUMINSURED) EndrosmentSumInsured 
from GI_GU_DH_DOC_HEADER h
inner join pr_gn_lc_location l on l.PLC_LOC_CODE=h.PLC_LOC_CODE
inner join PREMIUM_VIEW pv on pv.DOCREFNO=h.GDH_DOC_REFERENCE_NO
where h.GDH_year='2018'
and h.GDH_BASEDOCUMENTNO is not null
and h.PDT_DOCTYPE='E'
group by l.PLC_LOCADESC
) c on a.PLC_LOCADESC=C.PLC_LOCADESC
 
 
left join (select l.PLC_LOCADESC, 
count(h.GDH_DOC_REFERENCE_NO) CoverNoteDocCount ,sum(pv.GROSSPREM+pv.ADMIN)CoverNotePremium,sum(pv.SUMINSURED) CoverNoteSumInsured 
from GI_GU_DH_DOC_HEADER h
inner join pr_gn_lc_location l on l.PLC_LOC_CODE=h.PLC_LOC_CODE
inner join PREMIUM_VIEW pv on pv.DOCREFNO=h.GDH_DOC_REFERENCE_NO
where h.GDH_year='2018'
and h.GDH_BASEDOCUMENTNO is not null
and h.PDT_DOCTYPE='T'
group by l.PLC_LOCADESC
) d on a.PLC_LOCADESC=d.PLC_LOCADESC
;





2018
New Policies
Renewals
Endorsements
Cover Notes