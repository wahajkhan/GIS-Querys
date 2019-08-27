Select 

 cast (90 as number) SLABEND1 ,  cast (180 as number)  SLABEND2 ,  cast (270 as number)  SLABEND3 ,  cast (360 as number)  SLABEND4 ,  cast (450 as number)  SLABEND5, 
              0 SLABSTART1 , 90 +1 SLABSTART2 , 180 +1 SLABSTART3 , 270 +1 SLABSTART4 , 360 +1 SLABSTART5, 

(SELECT DISTINCT POR_DESC FROM PR_GN_OR_ORGANIZATION WHERE POR_ORG_CODE='001001') CMPNAME,
(select distinct pdp_desc from pr_gn_dp_department  )dep, 
(SELECT DISTINCT PLC_DESC FROM PR_GN_LC_LOCATION ) as Br_desc1,
(SELECT DISTINCT PLC_DESC FROM PR_GN_LC_LOCATION ) as Br_desc2,
(select distinct pps_desc from pr_gn_ps_party )cl1,

h.GIS_REGISTRATION_NO,   H.PDP_DEPT_CODE,
h.GIS_ENGINE_NO,h.GIS_CHASSIS_NO,coalesce(H.coinsurere,'x') coinsurere,
H.PLC_LOC_CODE AS BR_CODE,h.zonecode,h.zonedesc,
H.BRANCH AS BR_DESC,h.piy_desc,
H.PDP_DEPT_CODE AS PDP_CODE,H.PDP_DEPT_CODE,
H.DEPARTMENT AS PDP_DESC,H.GIH_OLDCLAIM_NO,
h.gih_doc_ref_no,h.gih_documentno, h.gih_year,
H.INTIMATIONNO AS INTIMATIONNO,
H.GIH_DATEOFLOSS AS DATEOFLOSS,
H.POC_LOSSDESC AS LOSSDESC,
H.GID_BASEDOCUMENTNO AS BASEDOCNO,
H.CLIENT_CODE,H.INSURED AS INSURED,H.REMARKS,H.PLACE,
H.GID_COMMDATE AS COMMDATE, 
case 'N' when 'G' then coalesce( H.GIS_SUMINSURED,0)*coalesce(h.FC_Rate,1) else coalesce( H.GIS_SUMINSURED,0) end AS SUMINSURED, 
case 'N' when 'G' then coalesce (H.TOTLOSS,0)*coalesce(h.FC_Rate,1) else coalesce (H.TOTLOSS,0) end AS TOTALLOSS, 
case 'N' when 'G' then coalesce (H.TOTLOSS_OS,0)*coalesce(h.FC_Rate,1) else coalesce (H.TOTLOSS_OS,0) end AS TOTALLOSS_OS, 
coalesce (H.LOSSPAY,0) AS LOSSPAY, 
coalesce( H.SURYORPAY,0)  AS SURVPAY, 
 coalesce (H.ADVOCATEPAY,0) AS ADVOCATEPAY,
 coalesce(SALVAGE,0) AS SALVAGE,
 COALESCE(H.TOTALPAID,0)  TOTALPAID,
 COALESCE(H.TOTALPAID_OS,0)  TOTALPAID_OS,
H.GIH_INTIMATIONDATE AS INTIMATIONDATE,h.rev_date,H.GID_EXPIRYDATE AS EXPIRY  ,coalesce(h.gic_share,100)gic_share

from (

select 
IHD.PDP_DEPT_CODE,
IHD.GIH_INTIMATIONDATE,IHD.PLC_LOC_CODE,GIH_OLDCLAIM_NO OLDCLAIMNO,
ISUBDTL.gis_sailing_date,dh.GDH_AS400_DOCUMENTNO,IHD.GIH_OLDCLAIM_NO,
IHD.GIH_DOC_REF_NO,IhD.gih_documentno,IhD.gih_year,ZONE.PLC_LOC_CODE zonecode,
ZONE.PLC_DESC zonedesc,piy.piy_desc,COALESCE(IC.GIC_SHARE,1) AS PSHARE,
IHD.GIH_DATEOFLOSS,IDTL.GID_BASEDOCUMENTNO,COALESCE(CAT.PCE_DESC,'N')PCE_DESC,
IHD.GIH_INTI_ENTRYNO AS IntimationNo,  IHD.GIH_REMARKS AS REMARKS,
IHD.GIH_PLACEOFTHEFT PLACE,ihd.gih_revisiondate rev_date,
LC.POC_LOSSDESC,   
CASE WHEN COALESCE(BRCURR.PLC_LOC_CODE,'N')<>'N' THEN coalesce(Ihd.GIH_FC_EXCHRATE,1) ELSE 1 END FC_Rate,        
IDTL.GID_EXPIRYDATE , coalesce(ic.gic_share,100)gic_share,
  
coalesce(ihD.pps_party_code,'None')Client_code,coalesce(P.PPS_DESC,'None')  AS INSURED, coi.pps_desc coinsurere,
ISUBDTL.GIS_REGISTRATION_NO, ISUBDTL.GIS_ENGINE_NO, ISUBDTL.GIS_CHASSIS_NO,    
DP.PDP_DESC DEPARTMENT,LC1.PLC_LOCADESC AS BRANCH,
case IHD.PDP_DEPT_CODE when '11' then  RS.PRS_DESC when '12' then IDTL.GVC_VOYAGECARD_NO else ISUBDTL.GIS_WORKING_LOCATION end as RiskCode,VC.PVC_DESC,
ISUBDTL.GIS_SUBJECTMATTER,ISUBDTL.GIS_VOYAGE_FROM,ISUBDTL.GIS_VOYAGE_TO,
P.PPS_PARGPCODE  AS GP,IDTL.GID_COMMDATE,


case when 'N'='Y' and coalesce(brcurr.plc_loc_code,'N')<>'N' then
coalesce (ISUBDTL.GIS_SUMINSURED,0)*coalesce(IHD.GIH_FC_EXCHRATE,1) ELSE coalesce (ISUBDTL.GIS_SUMINSURED,0) END  as gis_Suminsured, 

case when 'N'='Y' and coalesce(brcurr.plc_loc_code,'N')<>'N' then (
(

CASE coalesce(ISUBDTL.GIS_LOSSADJUSTED, 0)  WHEN 0 THEN  	CASE coalesce(ISUBDTL.GIS_LOSSASSESSED, 0)  
              WHEN 0 THEN  CASE coalesce(ISUBDTL.GIS_LOSSCLAIMED, 0)  WHEN 0 THEN 0  ELSE coalesce(ISUBDTL.GIS_LOSSCLAIMED, 0)  END  
              ELSE coalesce (ISUBDTL.GIS_LOSSASSESSED, 0)  END  
ELSE coalesce(ISUBDTL.gIS_LOSSADJUSTED, 0)  
END * CASE  WHEN coalesce(IHD.GIH_NOCLAIM_TAG,'V') = 'N' THEN 0 ELSE 1 END 
+ coalesce(ISUBDTL.GIS_SURVEYORAMT, 0) + coalesce(ISUBDTL.GIS_ADVOCATEAMT, 0) - 
CASE Y WHEN 'Y' THEN  coalesce(ISUBDTL.GIS_SALVAGEAMT, 0)  ELSE 0 END)-(coalesce(ISUBDTL.GIS_salestaxamt,0))

 )*coalesce(IHD.GIH_FC_EXCHRATE,1)

ELSE (

CASE coalesce(ISUBDTL.GIS_LOSSADJUSTED, 0)  WHEN 0 THEN  	CASE coalesce(ISUBDTL.GIS_LOSSASSESSED, 0)  
              WHEN 0 THEN  CASE coalesce(ISUBDTL.GIS_LOSSCLAIMED, 0)  WHEN 0 THEN 0  ELSE coalesce(ISUBDTL.GIS_LOSSCLAIMED, 0)  END  
              ELSE coalesce (ISUBDTL.GIS_LOSSASSESSED, 0)  END  
ELSE coalesce(ISUBDTL.gIS_LOSSADJUSTED, 0)  
END * CASE  WHEN coalesce(IHD.GIH_NOCLAIM_TAG,'V') = 'N' THEN 0 ELSE 1 END 
+ coalesce(ISUBDTL.GIS_SURVEYORAMT, 0) + coalesce(ISUBDTL.GIS_ADVOCATEAMT, 0) - 
CASE Y WHEN 'Y' THEN  coalesce(ISUBDTL.GIS_SALVAGEAMT, 0)  ELSE 0 END ) -(coalesce(ISUBDTL.GIS_salestaxamt,0))

END as TOTLOSS,

case when 'N' ='Y' and coalesce(brcurr.plc_loc_code,'N')<>'N' then (
(

CASE coalesce(ISUBDTL.GIS_LOSSADJUSTED, 0)  WHEN 0 THEN  	CASE coalesce(ISUBDTL.GIS_LOSSASSESSED, 0)  
              WHEN 0 THEN  CASE coalesce(ISUBDTL.GIS_LOSSCLAIMED, 0)  WHEN 0 THEN 0  ELSE coalesce(ISUBDTL.GIS_LOSSCLAIMED, 0)  END  
              ELSE coalesce (ISUBDTL.GIS_LOSSASSESSED, 0)  END  
ELSE coalesce(ISUBDTL.gIS_LOSSADJUSTED, 0)  
END * CASE  WHEN coalesce(IHD.GIH_NOCLAIM_TAG,'V') = 'N' THEN 0 ELSE 1 END 
+ coalesce(ISUBDTL.GIS_SURVEYORAMT, 0) + coalesce(ISUBDTL.GIS_ADVOCATEAMT, 0) - 
CASE Y WHEN 'Y' THEN  coalesce(ISUBDTL.GIS_SALVAGEAMT, 0)  ELSE 0 END)

 )

ELSE (

CASE coalesce(ISUBDTL.GIS_LOSSADJUSTED, 0)  WHEN 0 THEN  	CASE coalesce(ISUBDTL.GIS_LOSSASSESSED, 0)  
              WHEN 0 THEN  CASE coalesce(ISUBDTL.GIS_LOSSCLAIMED, 0)  WHEN 0 THEN 0  ELSE coalesce(ISUBDTL.GIS_LOSSCLAIMED, 0)  END  
              ELSE coalesce (ISUBDTL.GIS_LOSSASSESSED, 0)  END  
ELSE coalesce(ISUBDTL.gIS_LOSSADJUSTED, 0)  
END * CASE  WHEN coalesce(IHD.GIH_NOCLAIM_TAG,'V') = 'N' THEN 0 ELSE 1 END 
+ coalesce(ISUBDTL.GIS_SURVEYORAMT, 0) + coalesce(ISUBDTL.GIS_ADVOCATEAMT, 0) - 
CASE Y WHEN 'Y' THEN  coalesce(ISUBDTL.GIS_SALVAGEAMT, 0)  ELSE 0 END )

END as TOTLOSS_OS,

(LOSSPAY * CASE WHEN GIH_NOCLAIM_TAG ='N' THEN 0 ELSE 1 END) AS LOSSPAY,    
(SURYORPAY)   AS SURYORPAY,    
(ADVOCATEPAY) AS ADVOCATEPAY, 
 (CASE Y WHEN 'Y' THEN SALVAGE ELSE 0 END) AS SALVAGE,

case when 'N'='Y' then
COALESCE(LOSSPAID,0) ELSE COALESCE(LOSSPAID,0) END AS GSD_LOSSPAID1,

case when 'N'='Y' then (
LOSSPAY + SURYORPAY  + ADVOCATEPAY + (CASE Y WHEN 'Y' THEN SALVAGE ELSE 0 END))
ELSE (
LOSSPAY + SURYORPAY  + ADVOCATEPAY + (CASE Y WHEN 'Y' THEN SALVAGE ELSE 0 END))  END as TotalPaid,
(LOSSPAY_ForOS + SURYORPAY_OUR  + ADVOCATEPAY_OUR + (CASE Y WHEN 'Y' THEN SALVAGE_OUR ELSE 0 END) ) as TotalPaid_OS  


from 
GI_GC_IH_INTIMATIONHD IHD
inner join  
(select gih_doc_ref_no,max(gih_inti_entryno*1) ENTRYNO 
from 	   
	GI_GC_IH_INTIMATIONHD  
where 
case gih_inti_entryno when '1' then GIH_INTIMATIONDATE 
else GIH_REVISIONDATE end  BETWEEN 
case 'O' when 'P' then GIH_INTIMATIONDATE else '01-01-2000' end  AND '22-04-2019'
--and GIH_INTIMATIONDATE between {?INTIMATIONFR}  AND  {?INTIMATIONTO}
  
group by gih_doc_ref_no) HD 
ON 
( 
HD.gih_doc_ref_no=IHD.gih_doc_ref_no AND 
HD.ENTRYNO = IHD.gih_inti_entryno 
)

left outer join GI_GC_ID_INTIMATIONDTL IDTL 
on 
( 
IHD.POR_ORG_CODE         = IDTL.POR_ORG_CODE     AND 
IHD.PLC_LOC_CODE          = IDTL.PLC_LOC_CODE     AND 
IHD.PDP_DEPT_CODE        = IDTL.PDP_DEPT_CODE    AND 
IHD.PDT_DOCTYPE            = IDTL.PDT_DOCTYPE      AND 
IHD.GIH_DOCUMENTNO     = IDTL.GIH_DOCUMENTNO   AND	 
IHD.GIH_INTI_ENTRYNO    = IDTL.GIH_INTI_ENTRYNO AND 
IHD.GIH_YEAR                  = IDTL.GIH_YEAR 
) 

LEFT OUTER JOIN 
PR_GC_OC_LOSS_CAUSE LC  
ON 
( 
IHD.POR_ORG_CODE                       = LC.POR_ORG_CODE       AND  
IHD.PDP_DEPT_CODE                      = LC.PDP_DEPT_CODE      AND   
IHD.POC_LOSSCODE                       = LC.POC_LOSSCODE     
)
INNER JOIN PR_GN_DP_DEPARTMENT DP ON ( 
IHd.PLC_LOC_CODE  =  DP.PLC_LOC_CODE            AND  
IHd.PDP_DEPT_CODE = DP.PDP_DEPT_CODE)


left outer join
gi_gu_dh_doc_header dh
on
(
IDTL.GID_BASEDOCUMENTNO=dh.gdh_doc_reference_no
and dh.gdh_record_type='O' )


left outer join
PR_GN_PS_PARTY P
ON
(
IHD.PPS_PARTY_CODE=P.PPS_PARTY_CODE
)
INNER join pr_gn_lc_location zone
on(
zone.plc_loc_code=substr(ihd.plc_loc_code,1,(select sum(ppl_width) from PR_GN_PL_PARALEVELS a inner join PR_GN_PC_PARACONTROL b on (
        b.ppc_para_type = a.ppc_para_type
)
where b.ppc_para_type = 'LOC'
and a.PPL_LVL_TYPE <= b.ppc_levels -2  
))
)
left outer join
PR_GN_LC_LOCATION LC1
ON
(
IHD.PLC_LOC_CODE=LC1.PLC_LOC_CODE
)INNER JOIN
PR_GG_IY_INSURANCETYPE PIY
ON
(
iHD.PIY_INSUTYPE=PIY.PIY_INSUTYPE
)
left outer join pr_gn_ps_party coi on (coi.por_org_code=ihd.por_org_code and coi.pps_party_code=ihd.pps_insu_code)
left outer join 

(
select por_org_code,plc_loc_code,pdp_dept_code,pdt_doctype,gih_documentno,gid_ply_serialno,
gih_inti_entryno,gih_year,pco_ctry_code,prs_risk_code,gis_working_location,gis_sailing_date,
GIS_SUBJECTMATTER,PVC_CODE,GIS_VOYAGE_FROM,GIS_VOYAGE_TO,GIS_REGISTRATION_NO,GIS_ENGINE_NO,GIS_CHASSIS_NO, 
sum(coalesce(gis_suminsured,0)) gis_suminsured, 
sum(coalesce(gis_lossclaimed,0)) gis_lossclaimed,
sum(coalesce(gis_lossassessed,0)) gis_lossassessed,
sum(coalesce(gis_lossadjusted,0)) gis_lossadjusted,
sum(coalesce(gis_surveyoramt,0)) gis_surveyoramt,
sum(coalesce(gis_advocateamt,0)) gis_advocateamt , 
sum(coalesce(GIS_EXCESSAMOUNT,0)) GIS_EXCESSAMOUNT , 
sum(coalesce(GIS_SALVAGEAMT,0)) GIS_SALVAGEAMT , 
sum(coalesce(GIS_FACULTAMOUNT,0)) GIS_FACULTAMOUNT , 
sum(coalesce(GIS_FOREIGNFACULT_AMOUNT,0)) GIS_FOREIGNFACULT_AMOUNT, 
sum(coalesce(GIS_CONETAMOUNT,0)) GIS_CONETAMOUNT, 
sum(coalesce(GIS_TREATYAMOUNT,0)) GIS_TREATYAMOUNT,
sum(coalesce(GIS_PICAMOUNT,0))  GIS_PICAMOUNT,
coalesce(sum(GIS_salestaxamt),0)GIS_salestaxamt,
coalesce(sum(GIS_co_salestaxamt),0)GIS_co_salestaxamt


from GI_GC_IS_INTIMATIONSUBDTL  
group by  
por_org_code,plc_loc_code,pdp_dept_code,pdt_doctype,gih_documentno,gid_ply_serialno,
gih_inti_entryno,gih_year,pco_ctry_code,gis_sailing_date,
prs_risk_code,gis_working_location,GIS_SUBJECTMATTER,PVC_CODE,GIS_VOYAGE_FROM,GIS_VOYAGE_TO,GIS_REGISTRATION_NO,GIS_ENGINE_NO,GIS_CHASSIS_NO )

ISUBDTL on (  
IDTL.POR_ORG_CODE         = ISUBDTL.POR_ORG_CODE     AND  
IDTL.PLC_LOC_CODE         = ISUBDTL.PLC_LOC_CODE     AND  
IDTL.PDP_DEPT_CODE        = ISUBDTL.PDP_DEPT_CODE    AND  
IDTL.PDT_DOCTYPE          = ISUBDTL.PDT_DOCTYPE	     AND  
IDTL.GIH_DOCUMENTNO       = ISUBDTL.GIH_DOCUMENTNO   AND  
IDTL.GIH_INTI_ENTRYNO     = ISUBDTL.GIH_INTI_ENTRYNO AND  
IDTL.GIH_YEAR             = ISUBDTL.GIH_YEAR         AND  
IDTL.GID_PLY_SERIALNO     = ISUBDTL.GID_PLY_SERIALNO  
) 

LEFT OUTER JOIN PR_GM_VC_VESSEL_CLASSIFICATION VC ON (
ISUBDTL.PVC_CODE=VC.PVC_CODE)
left outer join 
PR_GG_RS_RISK_LOCATION RS  
on 
( 
ISUBDTL.PRS_RISK_CODE    =   RS.PRS_RISK_CODE and
ISUBDTL.PCO_CTRY_CODE    =   RS.PCO_CTRY_CODE 
)
left outer join GI_GC_UD_SURVEYORDTL svd on (
IHD.POR_ORG_CODE         = svd.POR_ORG_CODE     AND 
IHD.PLC_LOC_CODE          = svd.PLC_LOC_CODE     AND 
IHD.PDP_DEPT_CODE        = svd.PDP_DEPT_CODE    AND 
IHD.PDT_DOCTYPE            = svd.PDT_DOCTYPE      AND 
IHD.GIH_DOCUMENTNO     = svd.GIH_DOCUMENTNO   AND	 
IHD.GIH_INTI_ENTRYNO    = svd.GIH_INTI_ENTRYNO AND 
IHD.GIH_YEAR                  = svd.GIH_YEAR and gud_serialno=1) 
left outer join PR_GG_SR_SURVEYOR sv on (
svd.psr_surv_code=sv.psr_surv_code)
left outer join PR_GG_BRANCHCURRENCY_MAPPING brcurr on (
ihd.plc_loc_code=brcurr.plc_loc_code)

--PAYMENT DETAIL
LEFT OUTER JOIN 
(   
select PD1.POR_ORG_CODE,PD1.PLC_LOC_CODE,PD1.PDP_DEPT_CODE,PD1.PDT_DOCTYPE, pd1.gsh_postingtag,   
PD1.GIH_DOCUMENTNO,PD1.GIH_YEAR,GSD_SERIALNO,
sum(LOSSPAY) as LOSSPAY,
sum(LOSSPAY_ForOS) as LOSSPAY_ForOS,
sum (SURYORPAY_OUR) as SURYORPAY_OUR,
sum (ADVOCATEPAY_OUR) as ADVOCATEPAY_OUR, 
SUM(SALVAGE_OUR) SALVAGE_OUR,
sum (SURYORPAY) as SURYORPAY,
sum (ADVOCATEPAY) as ADVOCATEPAY, 
SUM(SALVAGE) SALVAGE,
sum(treaty) losstreaty,
sum(fac) lossfac,
sum(foreign_fac) lossforeign_fac,  
sum(excess) lossexcess,
sum(GSD_PICAMOUNT) GSD_PICAMOUNT,
SUM(PAID) AS LOSSPAID  
FROM  
  ( 
  
select 
SHD.POR_ORG_CODE,SHD.PLC_LOC_CODE,SHD.PDP_DEPT_CODE,SHD.PDT_DOCTYPE,     
SHD.GIH_DOCUMENTNO,SHD.GIH_INTI_ENTRYNO,SHD.GIH_YEAR,SDTL.GSD_SERIALNO,shd.gsh_postingtag, 

CASE PYY_CODE WHEN '01' THEN 
case when 'N'= 'Y' and coalesce(brcurr.plc_loc_code,'N')<>'N' then  
(coalesce(GSD_LOSSPAID,0)-case when 'O'='O' then coalesce(sdtl.GSD_SALESTAX_AMOUNT,0) else 0 end )*coalesce(sHD.GsH_FC_EXCHRATE,1) else 
coalesce(GSD_LOSSPAID,0)-case when 'O'='O' then coalesce(sdtl.GSD_SALESTAX_AMOUNT,0) else 0 end  END ELSE 0 END as LOSSPAY,  

CASE PYY_CODE WHEN '02' THEN 
case when 'N'= 'Y' and coalesce(brcurr.plc_loc_code,'N')<>'N' then  
(coalesce(GSD_LOSSPAID,0)-coalesce(sdtl.GSD_SALESTAX_AMOUNT,0))*coalesce(sHD.GsH_FC_EXCHRATE,1) else 
coalesce(GSD_LOSSPAID,0)-coalesce(sdtl.GSD_SALESTAX_AMOUNT,0)  END ELSE 0 END as SURYORPAY,

CASE PYY_CODE WHEN '03' THEN 
case when 'N'= 'Y' and coalesce(brcurr.plc_loc_code,'N')<>'N' then  
(coalesce(GSD_LOSSPAID,0)-coalesce(sdtl.GSD_SALESTAX_AMOUNT,0))*coalesce(sHD.GsH_FC_EXCHRATE,1) else 
coalesce(GSD_LOSSPAID,0)-coalesce(sdtl.GSD_SALESTAX_AMOUNT,0)  END ELSE 0 END as ADVOCATEPAY,
   
CASE PYY_CODE WHEN '04' THEN 
case when 'N'= 'Y' and coalesce(brcurr.plc_loc_code,'N')<>'N' then  
((coalesce(GSD_LOSSPAID,0)-coalesce(sdtl.GSD_SALESTAX_AMOUNT,0))*-1)*coalesce(sHD.GsH_FC_EXCHRATE,1) else 
(coalesce(GSD_LOSSPAID,0)-coalesce(sdtl.GSD_SALESTAX_AMOUNT,0))*-1  END ELSE 0 END as SALVAGE,

CASE PYY_CODE WHEN '01' THEN 
case when 'N'= 'Y' and coalesce(brcurr.plc_loc_code,'N')<>'N' then  
(coalesce(GSD_LOSSPAID,0)) else coalesce(GSD_LOSSPAID,0)  END ELSE 0 END as LOSSPAY_ForOS, 
     
CASE PYY_CODE WHEN '02' THEN 
case when 'N'= 'Y' and coalesce(brcurr.plc_loc_code,'N')<>'N' then  
coalesce(GSD_LOSSPAID,0) else 
coalesce(GSD_LOSSPAID,0)  END ELSE 0 END as SURYORPAY_OUR,

CASE PYY_CODE WHEN '03' THEN 
case when 'N'= 'Y' and coalesce(brcurr.plc_loc_code,'N')<>'N' then  
coalesce(GSD_LOSSPAID,0) else 
coalesce(GSD_LOSSPAID,0)  END ELSE 0 END as ADVOCATEPAY_OUR,
   
CASE PYY_CODE WHEN '04' THEN 
case when 'N'= 'Y' and coalesce(brcurr.plc_loc_code,'N')<>'N' then  
(coalesce(GSD_LOSSPAID,0)*-1) else 
coalesce(GSD_LOSSPAID,0)*-1  END ELSE 0 END as SALVAGE_OUR, 
        


coalesce(GSD_TREATYAMOUNT,0) * CASE PYY_CODE WHEN '04' THEN -1 else 1 end treaty,
coalesce(GSD_FACULTAMOUNT,0) * CASE PYY_CODE WHEN '04' THEN -1 else 1 end fac,  
coalesce( GSD_FOREIGNFACULT_AMOUNT,0) * CASE PYY_CODE WHEN '04' THEN -1 else 1 end foreign_fac, 
coalesce( GSD_PICAMOUNT,0) * CASE PYY_CODE WHEN '04' THEN -1 else 1 end GSD_PICAMOUNT, 
coalesce(GSD_EXCESSAMOUNT,0) * CASE PYY_CODE WHEN '04' THEN -1 else 1 end excess ,
GSD_LOSSPAID * CASE PYY_CODE WHEN '04' THEN  -1 else 1 end PAID  
   
from 	      
GI_GC_SH_SETTELMENTHD SHD  
INNER JOIN 
GI_GC_SD_SETTELMENTDTL SDTL 
ON  
(  
SDTL.POR_ORG_CODE     = SHD.POR_ORG_CODE	         AND  
SDTL.PLC_LOC_CODE     = SHD.PLC_LOC_CODE	         AND  
SDTL.PDP_DEPT_CODE    = SHD.PDP_DEPT_CODE	         AND  
SDTL.PDT_DOCTYPE      = SHD.PDT_DOCTYPE	              AND  
SDTL.GIH_DOCUMENTNO   = SHD.GIH_DOCUMENTNO	AND  
SDTL.GIH_INTI_ENTRYNO = SHD.GIH_INTI_ENTRYNO     AND  
SDTL.GIH_YEAR         = SHD.GIH_YEAR                         AND     
SDTL.GSH_ENTRYNO      = SHD.GSH_ENTRYNO    
) left outer join GI_GC_IC_INTIMATION_COINSURER IC ON
(
SDTL.POR_ORG_CODE         = IC.POR_ORG_CODE     AND  
SDTL.PLC_LOC_CODE         = IC.PLC_LOC_CODE     AND  
SDTL.PDP_DEPT_CODE        = IC.PDP_DEPT_CODE    AND  
SDTL.PDT_DOCTYPE          = IC.PDT_DOCTYPE	     AND  
SDTL.GIH_DOCUMENTNO       = IC.GIH_DOCUMENTNO   AND  
SDTL.GIH_INTI_ENTRYNO     = IC.GIH_INTI_ENTRYNO AND  
SDTL.GIH_YEAR             = IC.GIH_YEAR         AND  
SDTL.GSD_BASEDOCNO = IC.GIC_BASEDOCUMENTNO  AND 
IC.GIC_CORETAG='C' AND IC.GIC_LEADERTAG='Y' 
)
left outer join PR_GG_BRANCHCURRENCY_MAPPING brcurr on (
shd.plc_loc_code=brcurr.plc_loc_code)
where  shd.pdp_dept_code  = '13' and 

(

(SHD.GSH_SETTLEMENTDATE between SHD.GSH_SETTLEMENTDATE AND '22-04-2019' AND 'O'<>'P'  )
OR
(SHD.GSH_SETTLEMENTDATE between '01-01-2000' AND '22-04-2019' AND 'O'='P' )

)

AND 
coalesce(SHD.GSH_POSTINGTAG,'N') =case Y when 'Y'  then 'Y' when 'N' then 'N' else coalesce(SHD.GSH_POSTINGTAG,'N') end 

) PD1   
GROUP BY PD1.POR_ORG_CODE,PD1.PLC_LOC_CODE,PD1.PDP_DEPT_CODE,PD1.PDT_DOCTYPE,    
PD1.GIH_DOCUMENTNO,PD1.GIH_YEAR   , GSD_SERIALNO, pd1.gsh_postingtag 
)PD 
on   
(   
PD.POR_ORG_CODE   = IHD.POR_ORG_CODE	AND 
PD.PLC_LOC_CODE   = IHD.PLC_LOC_CODE	AND  
PD.PDP_DEPT_CODE  = IHD.PDP_DEPT_CODE	AND 
PD.PDT_DOCTYPE    = IHD.PDT_DOCTYPE	AND 
PD.GIH_DOCUMENTNO = IHD.GIH_DOCUMENTNO	AND   
PD.GIH_YEAR       = IHD.GIH_YEAR    AND 
PD.GSD_SERIALNO=IDTL.gid_ply_serialno 
) 

left outer join GI_GC_IC_INTIMATION_COINSURER IC ON
(
IDTL.POR_ORG_CODE         = IC.POR_ORG_CODE     AND  
IDTL.PLC_LOC_CODE         = IC.PLC_LOC_CODE     AND  
IDTL.PDP_DEPT_CODE        = IC.PDP_DEPT_CODE    AND  
IDTL.PDT_DOCTYPE          = IC.PDT_DOCTYPE	     AND  
IDTL.GIH_DOCUMENTNO       = IC.GIH_DOCUMENTNO   AND  
IDTL.GIH_INTI_ENTRYNO     = IC.GIH_INTI_ENTRYNO AND  
IDTL.GIH_YEAR             = IC.GIH_YEAR         AND  
IDTL.GID_BASEDOCUMENTNO = IC.GIC_BASEDOCUMENTNO  AND 
IC.GIC_CORETAG='C' AND IC.GIC_LEADERTAG='Y' 
)LEFT OUTER JOIN PR_GC_CE_CATASTROPHIC_EVENTS CAT ON (IHD.PCE_CODE=CAT.PCE_CODE)

where 
--   {?AGING}={?AGING}
--AND IHD.PLC_LOC_CODE between {?BRANCHFROM}  and {?BRANCHTO}  
--and
--CASE {?INSFROM} WHEN 'All' then 1 else  CHARINDEX (iHd.PIY_INSUTYPE,{?INSFROM}) end >0 
--AND ihd.PPS_PARTY_CODE BETWEEN CASE {?CLIENTFROM} WHEN 'All' THEN ihd.PPS_PARTY_CODE ELSE {?CLIENTFROM} END and CASE {?CLIENTTO} WHEN 'All' THEN ihd.PPS_PARTY_CODE ELSE {?CLIENTTO} END
--and {?SLINE}={?SLINE}
--and 
--case 'O' when 'I' then coalesce(IHD.GIH_POSTINGTAG,'N') when 'P' then coalesce(pd.GSH_POSTINGTAG,'N') else coalesce(IHD.GIH_POSTINGTAG,'N') end
--=
--case {?POSTED} when 'Y' then 'Y' when 'N' then 'N' else case 'O' when 'I' then coalesce(IHD.GIH_POSTINGTAG,'N') when 'P' then coalesce(pd.GSH_POSTINGTAG,'N') else coalesce(IHD.GIH_POSTINGTAG,'N') end end 
--and CASE IHD.PDP_DEPT_CODE WHEN '12' THEN {?UWFROMDATE}   ELSE dh.GDH_COMMDATE   END between {?UWFROMDATE} AND {?UWTODATE}  

and  case 'O' when 'P' then 
CASE 'Y' WHEN 'Y' THEN COALESCE(IHD.GIH_CANCELLATIONTAG,'N') ELSE 'N' END   else 

COALESCE(IHD.GIH_CANCELLATIONTAG,'N') end =CASE 'N' WHEN 'Y' THEN COALESCE(IHD.GIH_CANCELLATIONTAG,'N') ELSE 'N' END   
 and NOT EXISTS (SELECT 'x' FROM GI_GC_ih_intimationhd where gih_doc_ref_no=ihD.gih_doc_ref_no and coalesce(OLD_PARTY_CODE,'N')='net off pb cases' and TO_DATE(netoff_date)  <'22-04-2019'
)


) H 

ORDER BY  H.PLC_LOC_CODE ,H.PDP_DEPT_CODE , SUBSTRING (H.INTIMATIONNO,1,4) ,SUBSTRING (H.INTIMATIONNO, LEN (H.INTIMATIONNO)-7,8) ;