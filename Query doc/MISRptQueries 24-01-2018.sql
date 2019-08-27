--24/01/2018

--Industry Wise Premium Summary

SELECT 
P.POR_ORG_CODE, P.PLC_LOC_CODE, P.PDP_DEPT_CODE, 
P.PBC_BUSICLASS_CODE, P.PIY_INSUTYPE, P.PDT_DOCTYPE, 
P.GDH_DOCUMENTNO, P.GDH_RECORD_TYPE, P.GDH_YEAR, 
P.POSTING_DATE, P.AGENT_CODE, P.PDO_DEVOFFCODE, 
P.DOCREFNO, P.PCD_CODE, P.GDH_CNIC_NO, 
P.GDH_NTN_NO, P.BASEDOCUMENTNO, P.GDH_OLDMASTER_REF_NO, 
P.CLIENT_CODE, P.FOLIO_CODE, P.GDH_INDIVIDUAL_CLIENT, 
P.COMMDATE, P.ISSUEDATE, P.EXPDATE, 
P.PED_ENDOTYPE, P.GDH_AS400_DOCUMENTNO, P.POSTTAG, 
P.GDH_BASEDOC_TYPE, P.GAD_AMOUNT, P.GGD_LEADERREFERENCE, 
P.OWN_SHARE_TAG, P.NP100, P.GP100, 
P.GAD_COMMRATE, P.SUMINSURED, P.GROSSPREM, 
P.NETPREM, P.COINSSHARE, P.ADMIN, 
P.CHD, P.FIF, P.SD
FROM HIL.PREMIUM_VIEW P
Where
 --DOCREFNO = '2018/06/GroupFFNOP00124'
 P.FOLIO_CODE IN (
 '3100101177')
AND P.ISSUEDATE BETWEEN '01-JAN-2018' AND '31-DEC-2018'
 ;

--Motor Make wise report Document wise (Summary Report)
SELECT 
--G.GDH_DOC_REFERENCE_NO, 
count(a.pmk_make_Code)
FROM HIL.GI_GU_DH_DOC_HEADER G
left outer join GI_GU_ID_ITEM_DETAIL A 
          ON (    G.por_org_code = a.por_org_code
              AND G.plc_loc_code = a.plc_loc_code
              AND G.pdp_dept_code = a.pdp_dept_code
              AND G.pbc_busiclass_code = a.pbc_busiclass_code
              AND G.piy_insutype = a.piy_insutype
              AND G.pdt_doctype = a.pdt_doctype
              AND G.gdh_documentno = a.gdh_documentno
              AND G.gdh_record_type = a.gdh_record_type
              AND G.gdh_year = a.gdh_year
             )
Where
--G.GDH_YEAR = '2018'
  G.PDT_DOCTYPE in ('P')
 AND G.GDH_ISSUEDATE BETWEEN '01-nov-2017' AND '31-DEC-2018'
 AND G.GDH_RECORD_TYPE = 'O'
 AND G.GDH_POSTING_TAG = 'Y'
 AND G.GDH_CANCELLATION_TAG IS NULL
and g.pdp_dept_Code=13
--AND G.PIY_INSUTYPE IN ('O','D')
and a.pmk_make_Code in  (select pmk_make_Code from PR_GT_MK_MAKE mk where UPPER(PMK_DESC) LIKE 'TOYOTA%' ) 
; 




--Make wise Report Client Wise
SELECT 
--G.GDH_DOC_REFERENCE_NO, 
count(a.pmk_make_Code)
FROM HIL.GI_GU_DH_DOC_HEADER G
left outer join GI_GU_ID_ITEM_DETAIL A 
          ON (    G.por_org_code = a.por_org_code
              AND G.plc_loc_code = a.plc_loc_code
              AND G.pdp_dept_code = a.pdp_dept_code
              AND G.pbc_busiclass_code = a.pbc_busiclass_code
              AND G.piy_insutype = a.piy_insutype
              AND G.pdt_doctype = a.pdt_doctype
              AND G.gdh_documentno = a.gdh_documentno
              AND G.gdh_record_type = a.gdh_record_type
              AND G.gdh_year = a.gdh_year
             )
Where
--G.GDH_YEAR = '2018'
  G.PDT_DOCTYPE in ('P')
 AND G.GDH_ISSUEDATE BETWEEN '01-nov-2017' AND '31-DEC-2018'
 AND G.GDH_RECORD_TYPE = 'O'
 AND G.GDH_POSTING_TAG = 'Y'
 AND G.GDH_CANCELLATION_TAG IS NULL
and g.pdp_dept_Code=13
AND G.PIY_INSUTYPE IN ('O','D')
and PPS_PARTY_CODE in ('1300019811','1300020912','1300020782')
and a.pmk_make_Code in  (select pmk_make_Code from PR_GT_MK_MAKE mk where UPPER(PMK_DESC) LIKE 'TOYOTA%' ) 
; 


--National Bank Data Query with Receipt
SELECT GDH_BASEDOCUMENTNO,GDH_DOC_REFERENCE_NO,PLC_LOCADESC,dh.PPS_PARTY_CODE,PPS_DESC,PDP_DEPTDESC,PBC_DESC,GDH_ISSUEDATE,GDH_EXPIRYDATE,GDH_TOTALSI,GDH_GROSSPREMIUM,GDH_NETPREMIUM,bd.*,VCHDATE,KNOCKOFFAMOUNT,PVT_VCHTTYPE,PFS_ACNTYEAR,LVH_VCHDNO 
FROM GI_GU_BD_BANKDTL BD
left outer join GI_GU_DH_DOC_HEADER dh
on (
bd.POR_ORG_CODE||bd.PLC_LOC_CODE||bd.PDP_DEPT_CODE||bd.PBC_BUSICLASS_CODE||bd.PIY_INSUTYPE||bd.GDH_DOCUMENTNO||bd.GDH_RECORD_TYPE||bd.PDT_DOCTYPE||bd.GDH_YEAR=
dh.POR_ORG_CODE||dh.PLC_LOC_CODE||dh.PDP_DEPT_CODE||dh.PBC_BUSICLASS_CODE||dh.PIY_INSUTYPE||dh.GDH_DOCUMENTNO||dh.GDH_RECORD_TYPE||dh.PDT_DOCTYPE||dh.GDH_YEAR
) 
left outer join COLLECTION_TABLE ct 
on ( GDH_DOC_REFERENCE_NO=docref
)
left outer join PR_GN_LC_LOCATION lc
on (dh.PLC_LOC_CODE=lc.PLC_LOCaCODE

)
left outer join PR_GN_PS_PARTY pp
on (
dh.PPS_PARTY_CODE=pp.PPS_PARTY_CODE
)
left outer join (select distinct PDP_DEPTCODE,PDP_DEPTDESC from PR_GN_DP_DEPARTMENT) dd
on (dd.PDP_DEPTCODE=dh.PDP_DEPT_CODE)

left outer join PR_GG_BC_BUSINESS_CLASS bc
on (
dh.PBC_BUSICLASS_CODE=bc.PBC_BUSICLASS_CODE and dd.PDP_DEPTCODE=bc.PDP_DEPT_CODE
)


WHERE bd.GDH_YEAR=2018 and GDH_ISSUEDATE between '01-apr-2018' and '30-sep-2018' AND bd.GDH_RECORD_TYPE='O'
AND EXISTS 
(
SELECT 
'X' FROM HIL.PR_GN_BN_BANK B
Where
PBN_BNK_DESC LIKE '%Nation%'
 AND PBN_TYPE = 'D' AND BD.PBN_BNK_CODE=B.PBN_BNK_CODE
 );
--Bank Data Query without GL
SELECT GDH_DOC_REFERENCE_NO,GDH_BASEDOCUMENTNO,PLC_LOCADESC,dh.PPS_PARTY_CODE,PPS_DESC,PDP_DEPTDESC,PBC_DESC,GDH_ISSUEDATE,GDH_EXPIRYDATE,GDH_TOTALSI,GDH_GROSSPREMIUM,GDH_NETPREMIUM 
FROM GI_GU_BD_BANKDTL BD
left outer join GI_GU_DH_DOC_HEADER dh
on (
bd.POR_ORG_CODE||bd.PLC_LOC_CODE||bd.PDP_DEPT_CODE||bd.PBC_BUSICLASS_CODE||bd.PIY_INSUTYPE||bd.GDH_DOCUMENTNO||bd.GDH_RECORD_TYPE||bd.PDT_DOCTYPE||bd.GDH_YEAR=
dh.POR_ORG_CODE||dh.PLC_LOC_CODE||dh.PDP_DEPT_CODE||dh.PBC_BUSICLASS_CODE||dh.PIY_INSUTYPE||dh.GDH_DOCUMENTNO||dh.GDH_RECORD_TYPE||dh.PDT_DOCTYPE||dh.GDH_YEAR
) 
left outer join PR_GN_LC_LOCATION lc on (dh.PLC_LOC_CODE=lc.PLC_LOCaCODE)
left outer join PR_GN_PS_PARTY pp on (dh.PPS_PARTY_CODE=pp.PPS_PARTY_CODE)
left outer join (select distinct PDP_DEPTCODE,PDP_DEPTDESC from PR_GN_DP_DEPARTMENT) dd on (dd.PDP_DEPTCODE=dh.PDP_DEPT_CODE)
left outer join PR_GG_BC_BUSINESS_CLASS bc on (dh.PBC_BUSICLASS_CODE=bc.PBC_BUSICLASS_CODE and dd.PDP_DEPTCODE=bc.PDP_DEPT_CODE)
WHERE bd.GDH_YEAR=2017 and GDH_ISSUEDATE between '01-JAN-2017' and '31-DEC-2017' AND bd.GDH_RECORD_TYPE='O'
AND DH.GDH_CANCELLATION_TAG IS NULL AND DH.PDT_DOCTYPE='P'
AND DH.PPS_PARTY_cODE NOT IN ('1300019811','1103000045')
AND EXISTS 
(
SELECT 
'X' FROM HIL.PR_GN_BN_BANK B
Where
upper(PBN_BNK_DESC) LIKE '%BANK AL HABIB%'
 AND PBN_TYPE = 'D' AND BD.PBN_BNK_CODE=B.PBN_BNK_CODE
 )
 
 ;
--Stamp Duty Query

Select 
    H.POR_ORG_CODE  as POR_ORG_CODE ,   
    H.PLC_LOC_CODE  as PLC_LOC_CODE ,    
    H.PDP_DEPT_CODE as PDP_DEPT_CODE ,     
    H.PBC_BUSICLASS_CODE as PBC_BUSICLASS_CODE , 
    H.PIY_INSUTYPE       as PIY_INSUTYPE    , 
    H.PDT_DOCTYPE        as PDT_DOCTYPE    , 
    H.GDH_DOCUMENTNO     as GDH_DOCUMENTNO    , 
    H.GDH_RECORD_TYPE    as GDH_RECORD_TYPE    ,  iap.pii_desc,
    H.GDH_YEAR           as GDH_YEAR    , COALESCE(LHD.PED_ENDOTYPE,'a') as endotype,AGENCY(H.GDH_DOC_REFERENCE_NO,'D')AGENCY,coalesce(gd.ggd_companyshare,100)ggd_compshare,
H.PLC_LOC_CODE AS Location ,L.PLC_DESC AS Branch ,D.PDP_DESC AS Department ,BS.PBC_DESC AS BUSICLASS,COALESCE(h.gdh_as400_documentno,'AA') as old_documentno,gd.GGD_LEADERREFERENCE,ins.pps_desc as insurance_cmp,
--(select por_desc from pr_gn_or_organization where por_org_code=H.POR_ORG_CODE) ORGANIZATION,
--(select distinct PBC_DESC  from PR_GG_BC_BUSINESS_CLASS where PBC_BUSICLASS_CODE ={?Busclassfr})  as  BC_Desc1, 
--(select distinct PBC_DESC from PR_GG_BC_BUSINESS_CLASS where PBC_BUSICLASS_CODE ={?Busclassto}) as  BC_Desc2, 
--( select distinct  PLC_DESC from pr_gn_lc_location where PLC_LOC_CODE={?BranchFrom}) as Branch_From,
p.pps_desc as party,COALESCE( h.gdh_individual_client,'N') as ind_client,
--( select distinct  PPS_DESC from pr_gn_ps_party where pps_party_code={?ClientFrom}) as Client_From,
--( select distinct  PPS_DESC from pr_gn_ps_party where pps_party_code={?ClientTo}) as Client_To,
--( select distinct  PLC_DESC from pr_gn_lc_location where PLC_LOC_CODE={?BranchTo}) as Branch_To,
--(select distinct PBC_DESC from PR_GG_BC_BUSINESS_CLASS where PBC_BUSICLASS_CODE =H.PBC_BUSICLASS_CODE) as  PBC_BUSICLASS_CODE,h.pps_party_code,
 h.GDH_DOC_REFERENCE_NO AS Docrefno,h.gdh_basedoc_type,
case h.pps_folio_code when h.pps_party_code then ' ' else (select pps_desc from pr_gn_ps_party where pps_party_code=h.pps_folio_code) end AS Insured,
case coalesce(h.gdh_individual_client,'N')  when 'N' Then p.pps_desc else h.gdh_individual_client end as  Client,
TO_char(h.GDH_ISSUEDATE, 'DDMMYYYY') AS IssDate ,
(SELECT PIY_DESC FROM PR_GG_IY_INSURANCETYPE WHERE  PIY_INSUTYPE=H.PIY_INSUTYPE) AS Type,
coalesce(
Case  LHD.PED_ENDOTYPE when  'OD' then  
    ((SELECT SUM(GCD_SUMINSURED_DIFF)  
FROM  
    GI_GU_CD_COINSURERDTL CD  
WHERE 
    H.POR_ORG_CODE      = CD.POR_ORG_CODE         AND 
    H.PLC_LOC_CODE      = CD.PLC_LOC_cODE         AND 
    H.PDP_DEPT_CODE     = CD.PDP_DEPT_cODE        AND  
    H.PBC_BUSICLASS_CODE = CD.PBC_BUSICLASS_CODE  AND 
    H.PIY_INSUTYPE      = CD.PIY_INSUTYPE         AND 
    H.PDT_DOCTYPE       = CD.PDT_DOCTYPE          AND  
    H.GDH_DOCUMENTNO    = CD.GDH_DOCUMENTNO       AND 
    H.GDH_RECORD_TYPE   = CD.GDH_RECORD_TYPE      AND 
    H.GDH_YEAR          = CD.GDH_YEAR            AND 
    CD.GCD_LEADERTAG    = 'Y')) else 
        Case H.PIY_INSUTYPE when  'O' then 
        ((SELECT case LHD.PED_ENDOTYPE 
when 'CI' then SUM(GCD_SUMINSURED_DIFF) 
when 'DL' then SUM(GCD_SUMINSURED_DIFF)  

else SUM(GCD_SUMINSURED)   end  

FROM  
    GI_GU_CD_COINSURERDTL CD  
WHERE 
    H.POR_ORG_CODE      = CD.POR_ORG_CODE           AND 
    H.PLC_LOC_CODE      = CD.PLC_LOC_cODE           AND 
    H.PDP_DEPT_CODE     = CD.PDP_DEPT_cODE          AND  
    H.PBC_BUSICLASS_CODE = CD.PBC_BUSICLASS_CODE    AND 
    H.PIY_INSUTYPE      = CD.PIY_INSUTYPE           AND 
    H.PDT_DOCTYPE       = CD.PDT_DOCTYPE            AND  
    H.GDH_DOCUMENTNO    = CD.GDH_DOCUMENTNO      AND 
    H.GDH_RECORD_TYPE   = CD.GDH_RECORD_TYPE       AND 
    H.GDH_YEAR          = CD.GDH_YEAR             AND 
    CD.GCD_LEADERTAG    = 'Y')) else  SUM(H.GDH_TOTALSI) end  
end
,0) AS SumInsured ,

coalesce(
Case  LHD.PED_ENDOTYPE when  'LC' then 0 when  'OD' then  
    ((SELECT SUM(GCD_GROSSPREMIUM_DIFF) 
FROM  
    GI_GU_CD_COINSURERDTL CD  
WHERE 
    H.POR_ORG_CODE      = CD.POR_ORG_CODE         AND 
    H.PLC_LOC_CODE      = CD.PLC_LOC_cODE         AND 
    H.PDP_DEPT_CODE     = CD.PDP_DEPT_cODE        AND  
    H.PBC_BUSICLASS_CODE = CD.PBC_BUSICLASS_CODE  AND 
    H.PIY_INSUTYPE      = CD.PIY_INSUTYPE         AND 
    H.PDT_DOCTYPE       = CD.PDT_DOCTYPE          AND  
    H.GDH_DOCUMENTNO    = CD.GDH_DOCUMENTNO       AND 
    H.GDH_RECORD_TYPE   = CD.GDH_RECORD_TYPE      AND 
    H.GDH_YEAR          = CD.GDH_YEAR            AND 
    CD.GCD_LEADERTAG    = 'Y')) else 
        Case H.PIY_INSUTYPE when  'O' then 
        ((SELECT case LHD.PED_ENDOTYPE 
when 'CI' then SUM(GCD_GROSSPREMIUM_DIFF)  
when 'DL' then SUM(GCD_GROSSPREMIUM_DIFF) 

else SUM(GCD_GROSSPREMIUM)    end  
FROM  
    GI_GU_CD_COINSURERDTL CD  
WHERE 
    H.POR_ORG_CODE      = CD.POR_ORG_CODE           AND 
    H.PLC_LOC_CODE      = CD.PLC_LOC_cODE           AND 
    H.PDP_DEPT_CODE     = CD.PDP_DEPT_cODE          AND  
    H.PBC_BUSICLASS_CODE = CD.PBC_BUSICLASS_CODE    AND 
    H.PIY_INSUTYPE      = CD.PIY_INSUTYPE           AND 
    H.PDT_DOCTYPE       = CD.PDT_DOCTYPE            AND  
    H.GDH_DOCUMENTNO    = CD.GDH_DOCUMENTNO      AND 
    H.GDH_RECORD_TYPE   = CD.GDH_RECORD_TYPE       AND 
    H.GDH_YEAR          = CD.GDH_YEAR             AND 
    CD.GCD_LEADERTAG    = 'Y')) else  SUM(H.GDH_GROSSPREMIUM) end  
end 
,0) AS Grossprem,
coalesce(
Case LHD.PED_ENDOTYPE when 'OD' then  
(COALESCE((SELECT  sum(GCH_AMOUNT_DIFF) ADCH  
FROM       GI_GU_CD_COINSURERDTL CD
INNER JOIN
    GI_GU_CH_COIN_CHARGES CH
ON(
         CD.POR_ORG_CODE  = CH.POR_ORG_CODE  
    AND CD.PLC_LOC_CODE  = CH.PLC_LOC_CODE  
    AND CD.PDP_DEPT_CODE = CH.PDP_DEPT_CODE  
    AND CD.PBC_BUSICLASS_CODE=CH.PBC_BUSICLASS_CODE  
    AND CD.PIY_INSUTYPE  = CH.PIY_INSUTYPE  
    AND CD.PDT_DOCTYPE   = CH.PDT_DOCTYPE  
    AND CD.GDH_DOCUMENTNO= CH.GDH_DOCUMENTNO  
    AND CD.GDH_RECORD_TYPE=CH.GDH_RECORD_TYPE 
    AND CD.GDH_YEAR      = CH.GDH_YEAR  
    AND CD.GCD_SERIALNO  = CH.GCD_SERIALNO  
)
WHERE CH.GCH_ACTION_CODE= 
    (SELECT PYD_VALUE FROM PR_GN_YD_SYSTEMPARADTL WHERE PYD_TYPE='ADCH') 
    AND CD.gcd_leadertag = 'Y' 
         AND CD.POR_ORG_CODE  = H.POR_ORG_CODE  AND CD.PLC_LOC_CODE  = H.PLC_LOC_CODE  
           AND CD.PDP_DEPT_CODE = H.PDP_DEPT_CODE  
    AND CD.PBC_BUSICLASS_CODE=H.PBC_BUSICLASS_CODE  
    AND CD.PIY_INSUTYPE  = H.PIY_INSUTYPE  
    AND CD.PDT_DOCTYPE   = H.PDT_DOCTYPE  
    AND CD.GDH_DOCUMENTNO= H.GDH_DOCUMENTNO  
    AND CD.GDH_RECORD_TYPE=H.GDH_RECORD_TYPE 
    AND CD.GDH_YEAR      = H.GDH_YEAR  
        ),0))else 
Case H.PIY_INSUTYPE when 'O' then  
(COALESCE((SELECT  case LHD.PED_ENDOTYPE 

when 'CI' then SUM(GCH_AMOUNT_DIFF) 
when 'DL' then SUM(GCH_AMOUNT_DIFF)   
when 'LC' then SUM(GCH_AMOUNT_DIFF) 


 else sum(GCH_AMOUNT)   end  ADCH  
FROM      GI_GU_CD_COINSURERDTL CD
INNER JOIN 
    GI_GU_CH_COIN_CHARGES CH
ON(
        CD.POR_ORG_CODE  = CH.POR_ORG_CODE  
    AND CD.PLC_LOC_CODE  = CH.PLC_LOC_CODE  
    AND CD.PDP_DEPT_CODE = CH.PDP_DEPT_CODE  
    AND CD.PBC_BUSICLASS_CODE=CH.PBC_BUSICLASS_CODE  
    AND CD.PIY_INSUTYPE  = CH.PIY_INSUTYPE  
    AND CD.PDT_DOCTYPE   = CH.PDT_DOCTYPE  
    AND CD.GDH_DOCUMENTNO= CH.GDH_DOCUMENTNO  
    AND CD.GDH_RECORD_TYPE=CH.GDH_RECORD_TYPE 
    AND CD.GDH_YEAR      = CH.GDH_YEAR  
    AND CD.GCD_SERIALNO  = CH.GCD_SERIALNO  
)
     
    WHERE CH.GCH_ACTION_CODE= 
    (SELECT PYD_VALUE FROM PR_GN_YD_SYSTEMPARADTL WHERE PYD_TYPE='ADCH') 
    AND CD.gcd_leadertag = 'Y' 
    AND CD.POR_ORG_CODE  = H.POR_ORG_CODE AND CD.PLC_LOC_CODE  = H.PLC_LOC_CODE  
    AND CD.PDP_DEPT_CODE = H.PDP_DEPT_CODE  
    AND CD.PBC_BUSICLASS_CODE=H.PBC_BUSICLASS_CODE  
    AND CD.PIY_INSUTYPE  = H.PIY_INSUTYPE  AND CD.PDT_DOCTYPE   = H.PDT_DOCTYPE  
    AND CD.GDH_DOCUMENTNO= H.GDH_DOCUMENTNO  
    AND CD.GDH_RECORD_TYPE=H.GDH_RECORD_TYPE AND CD.GDH_YEAR      = H.GDH_YEAR  
    ),0)) else  
((SELECT sum(ch.GAC_AMOUNT) ADCH FROM  GI_GU_AC_ACTIONDTL CH 
    WHERE CH.GAC_ACTION_CODE=  
    (SELECT YD.PYD_VALUE FROM PR_GN_YD_SYSTEMPARADTL YD WHERE YD.PYD_TYPE='ADCH') 
    AND CH.GIH_ITEMNO    = 99999 
    AND H.POR_ORG_CODE   = CH.POR_ORG_CODE  
    AND H.PLC_LOC_CODE   = CH.PLC_LOC_CODE  
    AND H.PDP_DEPT_CODE  = CH.PDP_DEPT_CODE  
    AND H.PBC_BUSICLASS_CODE=CH.PBC_BUSICLASS_CODE  
    AND H.PIY_INSUTYPE   = CH.PIY_INSUTYPE  
    AND H.PDT_DOCTYPE    = CH.PDT_DOCTYPE  
    AND H.GDH_DOCUMENTNO = CH.GDH_DOCUMENTNO  
    AND H.GDH_RECORD_TYPE= CH.GDH_RECORD_TYPE 
    AND H.GDH_YEAR       = CH.GDH_YEAR ))end  end
,0) AS Admin,

coalesce(
Case LHD.PED_ENDOTYPE when 'OD' then  
(COALESCE((SELECT  sum(GCH_AMOUNT_DIFF) CED 
FROM   
GI_GU_CD_COINSURERDTL CD
INNER JOIN
GI_GU_CH_COIN_CHARGES CH 
ON(
        CD.POR_ORG_CODE      = CH.POR_ORG_CODE  
    AND CD.PLC_LOC_CODE      = CH.PLC_LOC_CODE  
    AND CD.PDP_DEPT_CODE     = CH.PDP_DEPT_CODE  
    AND CD.PBC_BUSICLASS_CODE=CH.PBC_BUSICLASS_CODE  
    AND CD.PIY_INSUTYPE      = CH.PIY_INSUTYPE  
    AND CD.PDT_DOCTYPE       = CH.PDT_DOCTYPE  
    AND CD.GDH_DOCUMENTNO    = CH.GDH_DOCUMENTNO  
    AND CD.GDH_RECORD_TYPE    =CH.GDH_RECORD_TYPE 
    AND CD.GDH_YEAR          = CH.GDH_YEAR  
    AND CD.GCD_SERIALNO      = CH.GCD_SERIALNO  
)

  WHERE CH.GCH_ACTION_CODE= 
    (SELECT PYD_VALUE FROM PR_GN_YD_SYSTEMPARADTL WHERE PYD_TYPE='CED') 
    AND CD.gcd_leadertag = 'Y' 
 
           AND CD.POR_ORG_CODE  = H.POR_ORG_CODE  AND CD.PLC_LOC_CODE  = H.PLC_LOC_CODE  
           AND CD.PDP_DEPT_CODE = H.PDP_DEPT_CODE  
    AND CD.PBC_BUSICLASS_CODE=H.PBC_BUSICLASS_CODE  
    AND CD.PIY_INSUTYPE  = H.PIY_INSUTYPE  
    AND CD.PDT_DOCTYPE   = H.PDT_DOCTYPE  
    AND CD.GDH_DOCUMENTNO= H.GDH_DOCUMENTNO  
    AND CD.GDH_RECORD_TYPE=H.GDH_RECORD_TYPE 
    AND CD.GDH_YEAR      = H.GDH_YEAR  
    
    ),0))else 
Case H.PIY_INSUTYPE when 'O' then  
(COALESCE((SELECT  case 
LHD.PED_ENDOTYPE

when 'CI' then SUM(GCH_AMOUNT_DIFF)  
when 'DL' then SUM(GCH_AMOUNT_DIFF)   
when 'LC' then SUM(GCH_AMOUNT_DIFF)  

else sum(GCH_AMOUNT)   end  CED
 
FROM      
GI_GU_CD_COINSURERDTL CD
INNER JOIN
GI_GU_CH_COIN_CHARGES CH 
ON(
        CD.POR_ORG_CODE  = CH.POR_ORG_CODE  
    AND CD.PLC_LOC_CODE  = CH.PLC_LOC_CODE  
    AND CD.PDP_DEPT_CODE = CH.PDP_DEPT_CODE  
    AND CD.PBC_BUSICLASS_CODE=CH.PBC_BUSICLASS_CODE  
    AND CD.PIY_INSUTYPE  = CH.PIY_INSUTYPE  
    AND CD.PDT_DOCTYPE   = CH.PDT_DOCTYPE  
    AND CD.GDH_DOCUMENTNO= CH.GDH_DOCUMENTNO  
    AND CD.GDH_RECORD_TYPE=CH.GDH_RECORD_TYPE 
    AND CD.GDH_YEAR      = CH.GDH_YEAR  
    AND CD.GCD_SERIALNO  = CH.GCD_SERIALNO  
)
   WHERE CH.GCH_ACTION_CODE= 
    (SELECT PYD_VALUE FROM PR_GN_YD_SYSTEMPARADTL WHERE PYD_TYPE='CED') 
    AND CD.gcd_leadertag = 'Y' 
 
    AND CD.POR_ORG_CODE  = H.POR_ORG_CODE AND CD.PLC_LOC_CODE  = H.PLC_LOC_CODE  
    AND CD.PDP_DEPT_CODE = H.PDP_DEPT_CODE  
    AND CD.PBC_BUSICLASS_CODE=H.PBC_BUSICLASS_CODE  
    AND CD.PIY_INSUTYPE  = H.PIY_INSUTYPE  AND CD.PDT_DOCTYPE   = H.PDT_DOCTYPE  
    AND CD.GDH_DOCUMENTNO= H.GDH_DOCUMENTNO  
    AND CD.GDH_RECORD_TYPE=H.GDH_RECORD_TYPE AND CD.GDH_YEAR      = H.GDH_YEAR  
    
    ),0)) else  
((SELECT sum(ch.GAC_AMOUNT) ADCH FROM  GI_GU_AC_ACTIONDTL CH 
    WHERE CH.GAC_ACTION_CODE=  
    (SELECT YD.PYD_VALUE FROM PR_GN_YD_SYSTEMPARADTL YD WHERE YD.PYD_TYPE='CED') 
 
    AND CH.GIH_ITEMNO    = 99999 
    AND H.POR_ORG_CODE   = CH.POR_ORG_CODE  
    AND H.PLC_LOC_CODE   = CH.PLC_LOC_CODE  
    AND H.PDP_DEPT_CODE  = CH.PDP_DEPT_CODE  
    AND H.PBC_BUSICLASS_CODE=CH.PBC_BUSICLASS_CODE  
    AND H.PIY_INSUTYPE   = CH.PIY_INSUTYPE  
    AND H.PDT_DOCTYPE    = CH.PDT_DOCTYPE  
    AND H.GDH_DOCUMENTNO = CH.GDH_DOCUMENTNO  
    AND H.GDH_RECORD_TYPE= CH.GDH_RECORD_TYPE 
    AND H.GDH_YEAR       = CH.GDH_YEAR ))end  end 
,0)AS CHD ,

coalesce(
Case LHD.PED_ENDOTYPE when 'OD' then  
(COALESCE((SELECT  sum(GCH_AMOUNT_DIFF) FIF 
FROM   
GI_GU_CD_COINSURERDTL CD 
INNER JOIN
GI_GU_CH_COIN_CHARGES CH 
ON(
        CD.POR_ORG_CODE  = CH.POR_ORG_CODE  
    AND CD.PLC_LOC_CODE  = CH.PLC_LOC_CODE  
    AND CD.PDP_DEPT_CODE = CH.PDP_DEPT_CODE  
    AND CD.PBC_BUSICLASS_CODE=CH.PBC_BUSICLASS_CODE  
    AND CD.PIY_INSUTYPE  = CH.PIY_INSUTYPE  
    AND CD.PDT_DOCTYPE   = CH.PDT_DOCTYPE  
    AND CD.GDH_DOCUMENTNO= CH.GDH_DOCUMENTNO  
    AND CD.GDH_RECORD_TYPE=CH.GDH_RECORD_TYPE 
    AND CD.GDH_YEAR      = CH.GDH_YEAR  
    AND CD.GCD_SERIALNO  = CH.GCD_SERIALNO  
)
      WHERE CH.GCH_ACTION_CODE= 
    (SELECT PYD_VALUE FROM PR_GN_YD_SYSTEMPARADTL WHERE PYD_TYPE='FIF') 
    AND CD.gcd_leadertag = 'Y' 
        AND CD.POR_ORG_CODE  = H.POR_ORG_CODE  AND CD.PLC_LOC_CODE  = H.PLC_LOC_CODE  
        AND CD.PDP_DEPT_CODE = H.PDP_DEPT_CODE  
    AND CD.PBC_BUSICLASS_CODE=H.PBC_BUSICLASS_CODE  
    AND CD.PIY_INSUTYPE  = H.PIY_INSUTYPE  
    AND CD.PDT_DOCTYPE   = H.PDT_DOCTYPE  
    AND CD.GDH_DOCUMENTNO= H.GDH_DOCUMENTNO  
    AND CD.GDH_RECORD_TYPE=H.GDH_RECORD_TYPE 
    AND CD.GDH_YEAR      = H.GDH_YEAR  
    
    ),0))else 
Case H.PIY_INSUTYPE when 'O' then  
(COALESCE((SELECT  case LHD.PED_ENDOTYPE 

when 'CI' then SUM(GCH_AMOUNT_DIFF)  
when 'DL' then SUM(GCH_AMOUNT_DIFF)   
when 'LC' then SUM(GCH_AMOUNT_DIFF)  


else sum(GCH_AMOUNT)   end  FIF 
FROM      
GI_GU_CD_COINSURERDTL CD 
INNER JOIN
GI_GU_CH_COIN_CHARGES CH 
ON(
    CD.POR_ORG_CODE      = CH.POR_ORG_CODE  
    AND CD.PLC_LOC_CODE  = CH.PLC_LOC_CODE  
    AND CD.PDP_DEPT_CODE = CH.PDP_DEPT_CODE  
    AND CD.PBC_BUSICLASS_CODE=CH.PBC_BUSICLASS_CODE  
    AND CD.PIY_INSUTYPE  = CH.PIY_INSUTYPE  
    AND CD.PDT_DOCTYPE   = CH.PDT_DOCTYPE  
    AND CD.GDH_DOCUMENTNO= CH.GDH_DOCUMENTNO  
    AND CD.GDH_RECORD_TYPE=CH.GDH_RECORD_TYPE 
    AND CD.GDH_YEAR      = CH.GDH_YEAR  
    AND CD.GCD_SERIALNO  = CH.GCD_SERIALNO  
)
      WHERE CH.GCH_ACTION_CODE= 
    (SELECT PYD_VALUE FROM PR_GN_YD_SYSTEMPARADTL WHERE PYD_TYPE='FIF') 
    AND CD.gcd_leadertag = 'Y' 
    AND CD.POR_ORG_CODE  = H.POR_ORG_CODE AND CD.PLC_LOC_CODE  = H.PLC_LOC_CODE  
    AND CD.PDP_DEPT_CODE = H.PDP_DEPT_CODE  
    AND CD.PBC_BUSICLASS_CODE=H.PBC_BUSICLASS_CODE  
    AND CD.PIY_INSUTYPE  = H.PIY_INSUTYPE  AND CD.PDT_DOCTYPE   = H.PDT_DOCTYPE  
    AND CD.GDH_DOCUMENTNO= H.GDH_DOCUMENTNO  
    AND CD.GDH_RECORD_TYPE=H.GDH_RECORD_TYPE AND CD.GDH_YEAR      = H.GDH_YEAR  
    
    ),0)) else  
((SELECT sum(ch.GAC_AMOUNT) ADCH FROM  GI_GU_AC_ACTIONDTL CH 
    WHERE CH.GAC_ACTION_CODE=  
    (SELECT YD.PYD_VALUE FROM PR_GN_YD_SYSTEMPARADTL YD WHERE YD.PYD_TYPE='FIF') 
    AND CH.GIH_ITEMNO    = 99999 
    AND H.POR_ORG_CODE   = CH.POR_ORG_CODE  
    AND H.PLC_LOC_CODE   = CH.PLC_LOC_CODE  
    AND H.PDP_DEPT_CODE  = CH.PDP_DEPT_CODE  
    AND H.PBC_BUSICLASS_CODE=CH.PBC_BUSICLASS_CODE  
    AND H.PIY_INSUTYPE   = CH.PIY_INSUTYPE  
    AND H.PDT_DOCTYPE    = CH.PDT_DOCTYPE  
    AND H.GDH_DOCUMENTNO = CH.GDH_DOCUMENTNO  
    AND H.GDH_RECORD_TYPE= CH.GDH_RECORD_TYPE 
    AND H.GDH_YEAR       = CH.GDH_YEAR )) end  end
,0) AS FIF ,
coalesce(
Case LHD.PED_ENDOTYPE when 'OD' then  
(COALESCE((SELECT  sum(GCH_AMOUNT_DIFF) STMP 
FROM   
GI_GU_CD_COINSURERDTL CD
INNER JOIN
GI_GU_CH_COIN_CHARGES CH 
ON(
        CD.POR_ORG_CODE  = CH.POR_ORG_CODE  
    AND CD.PLC_LOC_CODE  = CH.PLC_LOC_CODE  
    AND CD.PDP_DEPT_CODE = CH.PDP_DEPT_CODE  
    AND CD.PBC_BUSICLASS_CODE=CH.PBC_BUSICLASS_CODE  
    AND CD.PIY_INSUTYPE  = CH.PIY_INSUTYPE  
    AND CD.PDT_DOCTYPE   = CH.PDT_DOCTYPE  
    AND CD.GDH_DOCUMENTNO= CH.GDH_DOCUMENTNO  
    AND CD.GDH_RECORD_TYPE=CH.GDH_RECORD_TYPE 
    AND CD.GDH_YEAR      = CH.GDH_YEAR  
    AND CD.GCD_SERIALNO  = CH.GCD_SERIALNO  
)
      WHERE CH.GCH_ACTION_CODE= 
    (SELECT PYD_VALUE FROM PR_GN_YD_SYSTEMPARADTL WHERE PYD_TYPE='STMP') 
    AND CD.gcd_leadertag = 'Y' 
 
       AND CD.POR_ORG_CODE  = H.POR_ORG_CODE  AND CD.PLC_LOC_CODE  = H.PLC_LOC_CODE  
       AND CD.PDP_DEPT_CODE = H.PDP_DEPT_CODE  
    AND CD.PBC_BUSICLASS_CODE=H.PBC_BUSICLASS_CODE  
    AND CD.PIY_INSUTYPE  = H.PIY_INSUTYPE  
    AND CD.PDT_DOCTYPE   = H.PDT_DOCTYPE  
    AND CD.GDH_DOCUMENTNO= H.GDH_DOCUMENTNO  
    AND CD.GDH_RECORD_TYPE=H.GDH_RECORD_TYPE 
    AND CD.GDH_YEAR      = H.GDH_YEAR  
    
    ),0))else 
Case H.PIY_INSUTYPE when 'O' then  
(COALESCE((SELECT  case LHD.PED_ENDOTYPE 

when 'CI' then SUM(GCH_AMOUNT_DIFF)  
when 'DL' then SUM(GCH_AMOUNT_DIFF)   
when 'LC' then SUM(GCH_AMOUNT_DIFF)  


else sum(GCH_AMOUNT)   end  STMP 
FROM      
GI_GU_CH_COIN_CHARGES CH 
INNER JOIN
GI_GU_CD_COINSURERDTL CD 
ON(
        CD.POR_ORG_CODE  = CH.POR_ORG_CODE  
    AND CD.PLC_LOC_CODE  = CH.PLC_LOC_CODE  
    AND CD.PDP_DEPT_CODE = CH.PDP_DEPT_CODE  
    AND CD.PBC_BUSICLASS_CODE=CH.PBC_BUSICLASS_CODE  
    AND CD.PIY_INSUTYPE  = CH.PIY_INSUTYPE  
    AND CD.PDT_DOCTYPE   = CH.PDT_DOCTYPE  
    AND CD.GDH_DOCUMENTNO= CH.GDH_DOCUMENTNO  
    AND CD.GDH_RECORD_TYPE=CH.GDH_RECORD_TYPE 
    AND CD.GDH_YEAR      = CH.GDH_YEAR  
    AND CD.GCD_SERIALNO  = CH.GCD_SERIALNO  
)
      WHERE CH.GCH_ACTION_CODE= 
    (SELECT PYD_VALUE FROM PR_GN_YD_SYSTEMPARADTL WHERE PYD_TYPE='STMP') 
    AND CD.gcd_leadertag = 'Y' 
 
    AND CD.POR_ORG_CODE  = H.POR_ORG_CODE AND CD.PLC_LOC_CODE  = H.PLC_LOC_CODE  
    AND CD.PDP_DEPT_CODE = H.PDP_DEPT_CODE  
    AND CD.PBC_BUSICLASS_CODE=H.PBC_BUSICLASS_CODE  
    AND CD.PIY_INSUTYPE  = H.PIY_INSUTYPE  AND CD.PDT_DOCTYPE   = H.PDT_DOCTYPE  
    AND CD.GDH_DOCUMENTNO= H.GDH_DOCUMENTNO  
    AND CD.GDH_RECORD_TYPE=H.GDH_RECORD_TYPE AND CD.GDH_YEAR      = H.GDH_YEAR  
    
    ),0)) else  
((SELECT sum(ch.GAC_AMOUNT) ADCH FROM  GI_GU_AC_ACTIONDTL CH 
    WHERE CH.GAC_ACTION_CODE=  
    (SELECT YD.PYD_VALUE FROM PR_GN_YD_SYSTEMPARADTL YD WHERE YD.PYD_TYPE='STMP') 
 
    AND CH.GIH_ITEMNO    = 99999 
    AND H.POR_ORG_CODE   = CH.POR_ORG_CODE  
    AND H.PLC_LOC_CODE   = CH.PLC_LOC_CODE  
    AND H.PDP_DEPT_CODE  = CH.PDP_DEPT_CODE  
    AND H.PBC_BUSICLASS_CODE=CH.PBC_BUSICLASS_CODE  
    AND H.PIY_INSUTYPE   = CH.PIY_INSUTYPE  
    AND H.PDT_DOCTYPE    = CH.PDT_DOCTYPE  
    AND H.GDH_DOCUMENTNO = CH.GDH_DOCUMENTNO  
    AND H.GDH_RECORD_TYPE= CH.GDH_RECORD_TYPE 
    AND H.GDH_YEAR       = CH.GDH_YEAR ))end  end 
,0)AS SD,
coalesce((SELECT sum(ch.GAC_rate) ADCH FROM  GI_GU_AC_ACTIONDTL CH 
    WHERE CH.GAC_ACTION_CODE=  
    (SELECT YD.PYD_VALUE FROM PR_GN_YD_SYSTEMPARADTL YD WHERE YD.PYD_TYPE='STMP') 
 
    AND CH.GIH_ITEMNO    = 99999 
    AND H.POR_ORG_CODE   = CH.POR_ORG_CODE  
    AND H.PLC_LOC_CODE   = CH.PLC_LOC_CODE  
    AND H.PDP_DEPT_CODE  = CH.PDP_DEPT_CODE  
    AND H.PBC_BUSICLASS_CODE=CH.PBC_BUSICLASS_CODE  
    AND H.PIY_INSUTYPE   = CH.PIY_INSUTYPE  
    AND H.PDT_DOCTYPE    = CH.PDT_DOCTYPE  
    AND H.GDH_DOCUMENTNO = CH.GDH_DOCUMENTNO  
    AND H.GDH_RECORD_TYPE= CH.GDH_RECORD_TYPE 
    AND H.GDH_YEAR       = CH.GDH_YEAR )
,0)AS SDrate,
coalesce(
Case  LHD.PED_ENDOTYPE when  'OD' then  
    ((SELECT SUM(GCD_NETPREMIUM_DIFF) 
FROM  
    GI_GU_CD_COINSURERDTL CD  
WHERE 
    H.POR_ORG_CODE      = CD.POR_ORG_CODE         AND 
    H.PLC_LOC_CODE      = CD.PLC_LOC_cODE         AND 
    H.PDP_DEPT_CODE     = CD.PDP_DEPT_cODE        AND  
    H.PBC_BUSICLASS_CODE = CD.PBC_BUSICLASS_CODE  AND 
    H.PIY_INSUTYPE      = CD.PIY_INSUTYPE         AND 
    H.PDT_DOCTYPE       = CD.PDT_DOCTYPE          AND  
    H.GDH_DOCUMENTNO    = CD.GDH_DOCUMENTNO       AND 
    H.GDH_RECORD_TYPE   = CD.GDH_RECORD_TYPE      AND 
    H.GDH_YEAR          = CD.GDH_YEAR            AND 
    CD.GCD_LEADERTAG    = 'Y')) else 
        Case H.PIY_INSUTYPE when  'O' then 
        ((SELECT case LHD.PED_ENDOTYPE 

when 'CI' then SUM(GCD_NETPREMIUM_DIFF)  
when 'DL' then SUM(GCD_NETPREMIUM_DIFF) 
when 'LC' then SUM(GCD_NETPREMIUM_DIFF)  


else SUM(GCD_NETPREMIUM)   end  
FROM  
    GI_GU_CD_COINSURERDTL CD  
WHERE 
    H.POR_ORG_CODE      = CD.POR_ORG_CODE           AND 
    H.PLC_LOC_CODE      = CD.PLC_LOC_cODE           AND 
    H.PDP_DEPT_CODE     = CD.PDP_DEPT_cODE          AND  
    H.PBC_BUSICLASS_CODE = CD.PBC_BUSICLASS_CODE    AND 
    H.PIY_INSUTYPE      = CD.PIY_INSUTYPE           AND 
    H.PDT_DOCTYPE       = CD.PDT_DOCTYPE            AND  
    H.GDH_DOCUMENTNO    = CD.GDH_DOCUMENTNO      AND 
    H.GDH_RECORD_TYPE   = CD.GDH_RECORD_TYPE       AND 
    H.GDH_YEAR          = CD.GDH_YEAR             AND 
    CD.GCD_LEADERTAG    = 'Y')) else  SUM(H.GDH_NETPREMIUM)  end  
end  
,0) AS Netprem, 

coalesce(
Case  LHD.PED_ENDOTYPE when  'OD' then 
    ((SELECT SUM(GCD_NETPREMIUM_DIFF) 
 FROM 
    GI_GU_CD_COINSURERDTL CD 
 WHERE 
    H.POR_ORG_CODE      = CD.POR_ORG_CODE         AND 
    H.PLC_LOC_CODE      = CD.PLC_LOC_cODE         AND 
    H.PDP_DEPT_CODE     = CD.PDP_DEPT_cODE        AND 
    H.PBC_BUSICLASS_CODE = CD.PBC_BUSICLASS_CODE  AND 
    H.PIY_INSUTYPE      = CD.PIY_INSUTYPE         AND 
    H.PDT_DOCTYPE       = CD.PDT_DOCTYPE          AND 
    H.GDH_DOCUMENTNO    = CD.GDH_DOCUMENTNO       AND 
    H.GDH_RECORD_TYPE   = CD.GDH_RECORD_TYPE      AND 
    H.GDH_YEAR          = CD.GDH_YEAR             AND 
    CD.PIY_INSUTYPE ='O'  AND 
    CD.GCD_LEADERTAG    = 'N')) 
                    when 'CI' then 
 ((SELECT SUM(GCD_NETPREMIUM_DIFF) 
 FROM 
    GI_GU_CD_COINSURERDTL CD 
 WHERE 
    H.POR_ORG_CODE      = CD.POR_ORG_CODE         AND 
    H.PLC_LOC_CODE      = CD.PLC_LOC_cODE         AND 
    H.PDP_DEPT_CODE     = CD.PDP_DEPT_cODE        AND 
    H.PBC_BUSICLASS_CODE = CD.PBC_BUSICLASS_CODE  AND 
    H.PIY_INSUTYPE      = CD.PIY_INSUTYPE         AND 
    H.PDT_DOCTYPE       = CD.PDT_DOCTYPE          AND 
    H.GDH_DOCUMENTNO    = CD.GDH_DOCUMENTNO       AND 
    H.GDH_RECORD_TYPE   = CD.GDH_RECORD_TYPE      AND 
    H.GDH_YEAR          = CD.GDH_YEAR             AND 
    CD.PIY_INSUTYPE ='O'  AND 
    CD.GCD_LEADERTAG    = 'N')) 
when 'DL' then 
 ((SELECT SUM(GCD_NETPREMIUM_DIFF) 
 FROM 
    GI_GU_CD_COINSURERDTL CD 
 WHERE 
    H.POR_ORG_CODE      = CD.POR_ORG_CODE         AND 
    H.PLC_LOC_CODE      = CD.PLC_LOC_cODE         AND 
    H.PDP_DEPT_CODE     = CD.PDP_DEPT_cODE        AND 
    H.PBC_BUSICLASS_CODE = CD.PBC_BUSICLASS_CODE  AND 
    H.PIY_INSUTYPE      = CD.PIY_INSUTYPE         AND 
    H.PDT_DOCTYPE       = CD.PDT_DOCTYPE          AND 
    H.GDH_DOCUMENTNO    = CD.GDH_DOCUMENTNO       AND 
    H.GDH_RECORD_TYPE   = CD.GDH_RECORD_TYPE      AND 
    H.GDH_YEAR          = CD.GDH_YEAR             AND 
    CD.PIY_INSUTYPE ='O'  AND 
    CD.GCD_LEADERTAG    = 'N')) 
when 'LC' then 
 ((SELECT SUM(GCD_NETPREMIUM_DIFF) 
 FROM 
    GI_GU_CD_COINSURERDTL CD 
 WHERE 
    H.POR_ORG_CODE      = CD.POR_ORG_CODE         AND 
    H.PLC_LOC_CODE      = CD.PLC_LOC_cODE         AND 
    H.PDP_DEPT_CODE     = CD.PDP_DEPT_cODE        AND 
    H.PBC_BUSICLASS_CODE = CD.PBC_BUSICLASS_CODE  AND 
    H.PIY_INSUTYPE      = CD.PIY_INSUTYPE         AND 
    H.PDT_DOCTYPE       = CD.PDT_DOCTYPE          AND 
    H.GDH_DOCUMENTNO    = CD.GDH_DOCUMENTNO       AND 
    H.GDH_RECORD_TYPE   = CD.GDH_RECORD_TYPE      AND 
    H.GDH_YEAR          = CD.GDH_YEAR             AND 
    CD.PIY_INSUTYPE ='O'  AND 
    CD.GCD_LEADERTAG    = 'N')) 
else 
 ((SELECT SUM(GCD_NETPREMIUM) 
 FROM 
    GI_GU_CD_COINSURERDTL CD 
 WHERE 
    H.POR_ORG_CODE      = CD.POR_ORG_CODE         AND 
    H.PLC_LOC_CODE      = CD.PLC_LOC_cODE         AND 
    H.PDP_DEPT_CODE     = CD.PDP_DEPT_cODE        AND 
    H.PBC_BUSICLASS_CODE = CD.PBC_BUSICLASS_CODE  AND 
    H.PIY_INSUTYPE      = CD.PIY_INSUTYPE         AND 
    H.PDT_DOCTYPE       = CD.PDT_DOCTYPE          AND 
    H.GDH_DOCUMENTNO    = CD.GDH_DOCUMENTNO       AND 
    H.GDH_RECORD_TYPE   = CD.GDH_RECORD_TYPE      AND 
    H.GDH_YEAR          = CD.GDH_YEAR             AND 
    CD.PIY_INSUTYPE ='O'  AND 
    CD.GCD_LEADERTAG    = 'N')) end
,0) AS CoInsShare,
coalesce(H.GDH_POSTING_TAG,'N') GDH_POSTING_TAG, 
h.GDH_BASEDOCUMENTNO AS BaseDocNo ,
P.PPS_DESC AS Client ,
--h.GDH_COMMDATE AS CommDate ,
--h.GDH_ISSUEDATE AS commDate ,
TO_char(h.GDH_ISSUEDATE, 'DD/MM/YYYY') AS commDate ,
BS.PBC_SHORT_CODE AS Class , case H.GDH_POSTING_TAG when 'Y' then 'Yes' when Null then 'No' else 'No' end AS Posttag ,

h.GDH_EXPIRYDATE AS ExpDate,coalesce(h.gdh_basedoc_type,'a') as Bas_doctype ,

coalesce(
(SELECT sum(ch.GAC_Rate) ADCH FROM  GI_GU_AC_ACTIONDTL CH 
    WHERE 
    --CH.GIH_ITEMNO    = 99999
    --and  
    PCY_ACTIONTYPE = 'PR'
    AND GAC_ACTION_CODE = '0027'
    AND H.POR_ORG_CODE   = CH.POR_ORG_CODE  
    AND H.PLC_LOC_CODE   = CH.PLC_LOC_CODE  
    AND H.PDP_DEPT_CODE  = CH.PDP_DEPT_CODE  
    AND H.PBC_BUSICLASS_CODE=CH.PBC_BUSICLASS_CODE  
    AND H.PIY_INSUTYPE   = CH.PIY_INSUTYPE  
    AND H.PDT_DOCTYPE    = CH.PDT_DOCTYPE  
    AND H.GDH_DOCUMENTNO = CH.GDH_DOCUMENTNO  
    AND H.GDH_RECORD_TYPE= CH.GDH_RECORD_TYPE 
    AND H.GDH_YEAR       = CH.GDH_YEAR)  
,0)AS MarineRate,

coalesce(
(SELECT sum(ch.GAC_AMOUNT) ADCH FROM  GI_GU_AC_ACTIONDTL CH 
    WHERE 
    --CH.GIH_ITEMNO    = 99999
    --and  
    PCY_ACTIONTYPE = 'PR'
    AND GAC_ACTION_CODE = '0027'
    AND H.POR_ORG_CODE   = CH.POR_ORG_CODE  
    AND H.PLC_LOC_CODE   = CH.PLC_LOC_CODE  
    AND H.PDP_DEPT_CODE  = CH.PDP_DEPT_CODE  
    AND H.PBC_BUSICLASS_CODE=CH.PBC_BUSICLASS_CODE  
    AND H.PIY_INSUTYPE   = CH.PIY_INSUTYPE  
    AND H.PDT_DOCTYPE    = CH.PDT_DOCTYPE  
    AND H.GDH_DOCUMENTNO = CH.GDH_DOCUMENTNO  
    AND H.GDH_RECORD_TYPE= CH.GDH_RECORD_TYPE 
    AND H.GDH_YEAR       = CH.GDH_YEAR)  
,0)AS MarineAmt,H.PPS_PARTY_CODE
--,h.GDH_ISSUEDATE AS IssueDate

 
FROM   
PR_GN_LC_LOCATION L
INNER JOIN
GI_GU_DH_DOC_HEADER H
ON(
H.POR_ORG_CODE     = L.POR_ORG_CODE                AND 
H.PLC_LOC_CODE     = L.PLC_LOC_CODE  
)INNER JOIN
PR_GN_DP_DEPARTMENT D
ON(
H.POR_ORG_CODE     = D.POR_ORG_CODE     AND 
H.PLC_LOC_CODE     = D.PLC_LOC_CODE     AND 
H.PDP_DEPT_CODE     = D.PDP_DEPT_CODE             
)    
LEFT OUTER JOIN
gi_gu_gd_generaldtl gd
on
(
h.por_org_code=gd.por_org_code and
h.plc_loc_code=gd.plc_loc_code and
h.pdp_dept_code=gd.pdp_dept_code and
h.pbc_busiclass_code=gd.pbc_busiclass_code and
h.piy_insutype=gd.piy_insutype and
h.pdt_doctype=gd.pdt_doctype and
h.gdh_documentno=gd.gdh_documentno and
h.gdh_record_type=gd.gdh_record_type and
h.gdh_year=gd.gdh_year
)
left outer JOIN
PR_GN_PS_PARTY P
ON(
H.PPS_PARTY_CODE     = P.PPS_PARTY_CODE 
)
INNER JOIN
PR_GG_IY_INSURANCETYPE PIY
ON
(
H.PIY_INSUTYPE=PIY.PIY_INSUTYPE
)
left outer join pr_gn_ps_party ins on (gd.pps_insu_code=ins.pps_party_code)
INNER JOIN
PR_GG_BC_BUSINESS_CLASS BS
ON(
H.PBC_BUSICLASS_CODE    =    BS.PBC_BUSICLASS_CODE
AND H.PDP_DEPT_CODE = BS.PDP_DEPT_CODE
)   
LEFT OUTER JOIN
GI_GU_EL_ENDORSE_LOGBOOKHD LHD
ON(
 
H.POR_ORG_CODE           = LHD.POR_ORG_CODE                  AND 
H.PLC_LOC_CODE           = LHD.PLC_LOC_cODE                  AND 
H.PDP_DEPT_CODE          = LHD.PDP_DEPT_cODE                 AND  
H.PBC_BUSICLASS_CODE     = LHD.PBC_BUSICLASS_CODE            AND 
H.PIY_INSUTYPE           = LHD.PIY_INSUTYPE                  AND 
H.PDT_DOCTYPE            = LHD.PDT_DOCTYPE                   AND  
H.GDH_DOCUMENTNO         = LHD.GDH_DOCUMENTNO                AND 
H.GDH_RECORD_TYPE        = LHD.GDH_RECORD_TYPE               AND 
H.GDH_YEAR               = LHD.GDH_YEAR      ) 
left outer join PR_GF_II_IAP_INDUSTRY iap on (gd.pii_code=iap.pii_code and gd.pdp_dept_code=iap.pdp_dept_code)


WHERE  
H.PLC_LOC_CODE  between '10101' and '50101'  AND 
H.pdp_dept_Code  = '12'        AND 
H.pdt_doctype IN  ('P','E','C','O')                  AND     

coalesce(GDH_POSTING_TAG,'N') =
case 'Y' when 'Y' then 'Y' when 'N' then 'N' else coalesce(GDH_POSTING_TAG,'N') END
--and {?CODETAIL}={?CODETAIL}
and coalesce(H.GDH_OLDMASTER_REF_NO,'N')<>'net off pb cases' and 

--CASE {?INSURANCETYPEFROM} WHEN 'All' then 1 else  CHARINDEX (H.PIY_INSUTYPE,{?INSURANCETYPEFROM}) end >0 

--AND 
H.GDH_ISSUEDATE BETWEEN '01-dec-2018' AND '31-dec-2018'  and
--COALESCE(gd.pii_code,'N')  between CASE {?IAP Industry From} WHEN 'All'  THEN COALESCE(gd.pii_code,'N') ELSE {?IAP Industry From} END  and 
--CASE {?IAP Industry To} WHEN 'All'  THEN COALESCE(gd.pii_code,'N') ELSE {?IAP Industry To}  END  
--and COALESCE(gd.Pcd_CODE,'N')  between CASE {?Industry From} WHEN 'All' THEN  COALESCE(gd.Pcd_CODE,'N') ELSE {?Industry From} END AND CASE{?Industry To} WHEN 'All' THEN COALESCE(gd.Pcd_CODE,'N')  ELSE {?Industry To}  END  
--AND        {?SLINE}    ={?SLINE}       and                                                                                    
H.GDH_CANCELLATION_TAG       IS NULL            AND    
H.GDH_RECORD_TYPE         =  'O' AND
h.pdt_doctype='E'                
--AND   
--H.PBC_BUSICLASS_CODE BETWEEN {?Busclassfr}  and  {?Busclassto}    AND 
--h.pdt_doctype between {?DOCTYPEFROM} AND {?DOCTYPETO} AND 
--coalesce(h.pps_party_code,'0000') between CASE {?ClientFrom} WHEN 'All' then coalesce(h.pps_party_code,'0000') else {?ClientFrom} end and case {?ClientTo} when 'All' then coalesce(h.pps_party_code,'0000') else {?ClientTo} end and
--COALESCE(H.PDO_DEVOFFCODE,'00001') BETWEEN case {?DEVOFFICERFROM} when 'All' then COALESCE(H.PDO_DEVOFFCODE,'00001') else {?DEVOFFICERFROM} end AND case {?DEVOFFICERTO} when 'All' then COALESCE(H.PDO_DEVOFFCODE,'00001') else {?DEVOFFICERTO} end AND
--COALESCE(H.GDH_NETPREMIUM,0) <= CASE {?PREMIUMTYPE} when 'Y' then -1 else COALESCE(H.GDH_NETPREMIUM,0) 
--end  
GROUP BY  Case H.PDT_DOCTYPE  when 'P' then   1  when 'M' then  2   when 'O'  then 3  when  'C' then 4  when 'E' then 5   end  , 
L.PLC_DESC             , D.PDP_DESC ,BS.PBC_DESC, h.pps_folio_code              ,  
h.GDH_BASEDOCUMENTNO   , h.GDH_DOC_REFERENCE_NO  , coalesce(h.GDH_BASEDOC_TYPE,'z'),
h.GDH_ISSUEDATE       , h.GDH_COMMDATE   , 
h.GDH_EXPIRYDATE      , BS.PBC_SHORT_CODE       , 
H.PIY_INSUTYPE        , H.POR_ORG_CODE          ,  gd.ggd_companyshare,
H.PLC_LOC_CODE          , H.PDP_DEPT_CODE         ,  
H.PBC_BUSICLASS_CODE     , H.PIY_INSUTYPE       ,  
H.PDT_DOCTYPE           , H.GDH_DOCUMENTNO        ,  iap.pii_desc,
H.GDH_RECORD_TYPE     , H.GDH_YEAR             ,
P.PPS_PARTY_CODE, h.pps_folio_code,h.pps_party_code ,P.PPS_DESC    , LHD.PED_ENDOTYPE  ,H.GDH_POSTING_TAG ,h.gdh_individual_client,p.pps_pargpcode,h.gdh_as400_documentno ,h.gdh_basedoc_type,gd.GGD_LEADERREFERENCE,ins.pps_desc
  ORDER BY  h.plc_loc_code , Case H.PDT_DOCTYPE  when 'P' then   1  when 'M' then  2  when 'O'  then 3  when  'C' then 4 when 'E' then 5 end   ,H.GDH_YEAR ,h.gdh_documentno
 

 --pRODUCER WISE Summary Branch & Client Wise with Admin
select branch,INITCAP(prod),sum(gp) from (
select a.plc_loc_code,lc.plc_desc branch,a.client_code,pp.pps_desc client, a.PDO_DEVOFFCODE,d.PDO_DEVOFFDESC developer,PRODUCER,
case when producer is null then PDO_DEVOFFDESC else producer end prod, sum(coalesce(a.grossprem,0)) gp
from premium_view a 
left outer join pr_gn_lc_location lc on (a.plc_loc_code=lc.plc_loc_code)
left outer join pr_gn_ps_party pp on (a.client_code=pp.pps_party_code)
left outer join PR_GG_DO_DEVOFFICER d on (d.PDO_DEVOFFCODE=a.PDO_DEVOFFCODE)
left outer join HICL_PRODUCERMAPING pm on (pm.PPS_PARTY_CODE=a.client_code)
where year(a.issuedate) ='2018' 
AND month(a.issuedate) between '01' and '12'
and A.PDP_DEPT_CODE between '11' and '19' 
and A.PLC_LOC_CODE between '10101' and '50101' 
AND 'A'='A' and a.client_code between case 'All' when 'All' then a.client_code else 'All' end and case 'All' when 'All' then a.client_code else'All' end 
and a.pdt_doctype IN ('E','P')
group by a.plc_loc_code,lc.plc_desc,a.client_code,pp.pps_desc,a.PDO_DEVOFFCODE,d.PDO_DEVOFFDESC,PRODUCER
order by a.plc_loc_code,lc.plc_desc,a.client_code,pp.pps_desc,a.PDO_DEVOFFCODE,d.PDO_DEVOFFDESC,PRODUCER
)
group by branch,INITCAP(prod)
order by branch,INITCAP(prod)
;


--BEFORE 24-01-2019
--Renewed Yes 

SELECT 
--COUNT(G.GDH_DOCUMENTNO) DOCCOUNT,
--   SUM(G.GDH_TOTALSI) SI, 
--   SUM(G.GDH_GROSSPREMIUM) GP
pps_desc,pps_desc,PLC_LOCADESC,PDP_DEPTDESC,
COUNT(G.GDH_DOCUMENTNO) DOCCOUNT,
   SUM(G.GDH_TOTALSI) SI, 
   SUM(G.GDH_GROSSPREMIUM) GP

FROM HIL.GI_GU_DH_DOC_HEADER G
left outer join pr_gn_lc_location lc on (G.plc_loc_code=lc.plc_loc_code)
left outer join pr_gn_dp_department dp on (dp.pdp_dept_code=G.pdp_dept_code and dp.plc_loc_code=G.plc_loc_code)
left outer join pr_gn_ps_party pp on (g.PPS_PARTY_CODE=pp.pps_party_code)
Where
GDH_RENEWAL_TAG = 'Y'
 --AND GDH_YEAR = '2018'
 AND PDT_DOCTYPE     in ('P','O')
 AND GDH_RECORD_TYPE    = 'O'
 AND GDH_CANCELLATION_TAG   is null
 AND gdh_expirydate between '01-jan-2018' and '31-dec-2018'
 group by pps_desc,PLC_LOCADESC,PDP_DEPTDESC;
--ORDER BY g.POR_ORG_CODE, g.PLC_LOC_CODE, g.PDP_DEPT_CODE, g.PBC_BUSICLASS_CODE, g.PIY_INSUTYPE, g.PDT_DOCTYPE, g.GDH_DOCUMENTNO, g.GDH_RECORD_TYPE, g.GDH_YEAR

;

--Expired but not Renewal 

SELECT 
pps_desc,PLC_LOCADESC,PDP_DEPTDESC,
COUNT(G.GDH_DOCUMENTNO) DOCCOUNT,
   SUM(G.GDH_TOTALSI) SI, 
   SUM(G.GDH_GROSSPREMIUM) GP
FROM HIL.GI_GU_DH_DOC_HEADER G
left outer join pr_gn_lc_location lc on (G.plc_loc_code=lc.plc_loc_code)
left outer join pr_gn_dp_department dp on (dp.pdp_dept_code=G.pdp_dept_code and dp.plc_loc_code=G.plc_loc_code)
left outer join pr_gn_ps_party pp on (g.PPS_PARTY_CODE=pp.pps_party_code)
Where
g.GDH_RENEWAL_TAG is null
and g.PDP_DEPT_CODE not in ('12')
 --AND GDH_YEAR = '2018'
 AND g.PDT_DOCTYPE     in ('P')
 AND g.GDH_RECORD_TYPE    = 'O'
 AND g.GDH_CANCELLATION_TAG   is null
 AND g.gdh_expirydate between '01-jan-2018' and '31-dec-2018'
 group by pps_desc,PLC_LOCADESC,PDP_DEPTDESC;

--ORDER BY POR_ORG_CODE, PLC_LOC_CODE, PDP_DEPT_CODE, PBC_BUSICLASS_CODE, PIY_INSUTYPE, PDT_DOCTYPE, GDH_DOCUMENTNO, GDH_RECORD_TYPE, GDH_YEAR

--Total policy client for the period
select distinct count(distinct CLIENT_CODE) clientcount,count(docrefno)doccount,sum(coalesce(a.grossprem,0))gp,sum(coalesce(a.grossprem,0))+sum(coalesce(a.admin,0)) gpadmin
FROM  premium_view a
where a.issuedate  BETWEEN '01-JAN-2018' AND '31-DEC-2018'
and A.PDP_DEPT_CODE between '01' and '99' 
and A.PLC_LOC_CODE between '00001' and '99999' 
and a.pdt_doctype IN ('P')

;

-- new client Total policy client for the period
select distinct count(distinct CLIENT_CODE) clientcount,count(docrefno)doccount,sum(coalesce(a.grossprem,0))gp,sum(coalesce(a.grossprem,0))+sum(coalesce(a.admin,0)) gpadmin
FROM  premium_view a
left outer join pr_gn_ps_party pp on (a.client_code=pp.pps_party_code)
where a.issuedate  BETWEEN '01-JAN-2018' AND '31-DEC-2018'
and A.PDP_DEPT_CODE between '01' and '99' 
and A.PLC_LOC_CODE between '00001' and '99999' 
and a.pdt_doctype IN ('P')
and pp.CREATE_DATE BETWEEN '01-JAN-2018' AND '31-DEC-2018'
;

--Unposted Documents 

SELECT 
*
FROM HIL.GI_GU_DH_DOC_HEADER G
Where
--GDH_RENEWAL_TAG = 'Y'
 --AND GDH_YEAR = '2018'
 PDT_DOCTYPE     in ('P','O','E','T')
AND  GDH_RECORD_TYPE    = 'O'
 AND GDH_CANCELLATION_TAG   is null
 and GDH_POSTING_TAG IS NULL
 AND GDH_ISSUEDATE between '01-jan-2018' and '31-dec-2018'
ORDER BY POR_ORG_CODE, PLC_LOC_CODE, PDP_DEPT_CODE, PBC_BUSICLASS_CODE, PIY_INSUTYPE, PDT_DOCTYPE, GDH_DOCUMENTNO, GDH_RECORD_TYPE, GDH_YEAR

;


-- COVERNOTE UTILIZED & UNUTILIZED

SELECT SUM(NOCOVERNOTE)NC,SUM(POLICYCONV)PC FROM(
SELECT (CASE WHEN POLICY='NO' THEN 1 ELSE 0 END ) NOCOVERNOTE, (CASE WHEN POLICY<>'NO' THEN 1 ELSE 0 END ) POLICYCONV   FROM(
select DH.gdh_doc_reference_no covernote,coalesce(PDH.gdh_doc_reference_no, 'NO') POLICY , 
dh.pdp_dept_code as dept,dh.plc_loc_code as location,lc.plc_locadesc as branchdesc,DP.PDP_DESC AS DEPTDESC,PDH.GDH_ISSUEDATE AS ISSUE_POLICY,
PDH.GDH_TOTALSI AS SI_POLICY,PDH.GDH_GROSSPREMIUM AS GROSS_POLICY,PDH.GDH_NETPREMIUM AS NP_POLICY,
 DH.gdh_issuedate,DH.gdh_commdate,DH.gdh_expirydate,(select pbc_desc from pr_gg_bc_business_class where pbc_busiclass_code= dh.pbc_busiclass_code) class,
 (select pps_desc from pr_gn_ps_party where pps_party_code=dh.pps_party_code) insured, (select pps_desc from pr_gn_ps_party where pps_party_code=agdtl.pps_party_code) agency,
agdtl.pps_party_code as agent_code,
dh.pdo_devoffcode as dev_code,
do.pdo_devoffdesc as devoff_desc,
iy.piy_desc as insu_desc,pg.pps_desc as agent_desc,
dh.piy_insutype,DH.gdh_totalsi,DH.gdh_grosspremium,DH.gdh_netpremium 
from gi_gu_dh_doc_header dh 
 left outer join gi_gu_dh_doc_header pdh ON 
( pdh.GDH_BASEDOCUMENTNO=DH.GDH_DOC_REFERENCE_NO
and PDH.Gdh_record_type='O' AND PDH.PDT_DOCTYPE='P'  AND PDH.GDH_CANCELLATION_TAG IS  NULL AND PDH.GDH_BASEDOC_TYPE='B' 
and coalesce(pdh.gdh_posting_tag,'N')=case 'Y' when 'Y' then 'Y' when 'N' then 'N' else coalesce(pdh.gdh_posting_tag,'N') end 
)
left outer join 
GI_GU_AD_AGENCYDTL AGDTL on
(
                    DH.POR_ORG_CODE              = AGDTL.POR_ORG_CODE        AND 
                    DH.PLC_LOC_CODE              = AGDTL.PLC_LOC_cODE        AND 
                    DH.PDP_DEPT_CODE             = AGDTL.PDP_DEPT_cODE       AND  
                    DH.PBC_BUSICLASS_CODE        = AGDTL.PBC_BUSICLASS_CODE  AND 
                    DH.PIY_INSUTYPE              = AGDTL.PIY_INSUTYPE        AND 
                    DH.PDT_DOCTYPE               = AGDTL.PDT_DOCTYPE         AND  
                    DH.GDH_DOCUMENTNO            = AGDTL.GDH_DOCUMENTNO      AND 
                    DH.GDH_RECORD_TYPE           = AGDTL.GDH_RECORD_TYPE     AND 
                    DH.GDH_YEAR                  = AGDTL.GDH_YEAR            
)
left outer join
pr_gg_iy_insurancetype iy
on
(
dh.piy_insutype=iy.piy_insutype
) 
left outer join
pr_gn_ps_party pg
on
(
agdtl.pps_party_code=pg.pps_party_code
)
left outer join
pr_gg_do_devofficer do
on
(
dh.pdo_devoffcode=do.pdo_devoffcode 
)
left outer join
pr_gn_lc_location lc
on
(
dh.plc_loc_code=lc.plc_loc_code
)
LEFT OUTER JOIN
PR_GN_DP_DEPARTMENT DP
ON
(
DH.PLC_LOC_CODE=DP.PLC_LOC_CODE AND
DH.PDP_DEPT_CODE=DP.PDP_DEPT_CODE
)
left outer join
(

select ho.gdh_doc_reference_no as polno,ho.gdh_expirydate as pol_expiry,ho.Gdh_RECORD_TYPE,
coalesce(ho.gdh_totalsi,0) pol_totalsi 


from gi_gu_dh_doc_header ho 
inner join
gi_gu_dh_doc_header hc on (
ho.POR_ORG_CODE          =  hc.POR_ORG_CODE 
AND     ho.PLC_LOC_CODE      = hc.PLC_LOC_CODE 
AND     ho.PDP_DEPT_CODE     =  hc.PDP_DEPT_CODE
AND     ho.PBC_BUSICLASS_CODE   = hc.PBC_BUSICLASS_CODE 
AND     ho.PIY_INSUTYPE         =  hc.PIY_INSUTYPE
AND     ho.PDT_DOCTYPE          =  hc.PDT_DOCTYPE 
AND     ho.Gdh_DOCUMENTNO      =  hc.Gdh_DOCUMENTNO
AND     hc.Gdh_RECORD_TYPE='C'
AND     ho.Gdh_YEAR             =  hc.Gdh_YEAR)
where ho.pdt_doctype ='T' and ho.Gdh_RECORD_TYPE='C'
) N
on
(
dh.gdh_doc_reference_no=n.polno )


where dh.pdt_doctype='T' AND dh.gdh_record_type=case when coalesce(N.gdh_record_type,'O') ='C'  then 'C' else 'O' end  AND 'Y'='Y'
--and DH.PLC_LOC_CODE between {?BRANCHFROM} and {?BRANCHTO} 
--and DH.PDP_DEPT_CODE between {?DEPARTMENTFROM} and {?DEPARTMENTTO} 

--and CASE {?EXPIREDBASIS} WHEN 'Y' 
--    THEN dh.GDH_RENEWALDATE  ELSE 
--    CASE {?DATEFILTER} WHEN 'C' THEN DH.gdh_commdate WHEN 'P' THEN DH.gdh_ISSUEDATE ELSE DH.gdh_commdate END
AND DH.gdh_commdate between '01-jan-2018' and '31-DEC-2018' 
--and COALESCE(AGDTL.PPS_PARTY_CODE,'N') between CASE {?AgentFrom} WHEN 'All' then COALESCE(AGDTL.PPS_PARTY_CODE,'N') else {?AgentFrom} end and case {?AgentTo} when 'All' then COALESCE(AGDTL.PPS_PARTY_CODE,'N') else {?AgentTo} end 
--AND DH.PPS_PARTY_CODE BETWEEN CASE {?CLIENTFROM} when 'All' then  DH.PPS_PARTY_CODE else {?CLIENTFROM} end and case {?CLIENTTO} when 'All' then  DH.PPS_PARTY_CODE  else {?CLIENTTO} end
and COALESCE(DH.GDH_CANCELLATION_TAG,'N') <> 'Y' 
and coalesce(dh.gdh_posting_tag,'N')='Y' 


AND NOT EXISTS
(
SELECT     GEL_BASEDOCUMENTNO 
FROM         GI_GU_EL_ENDORSE_LOGBOOKHD EL INNER JOIN gi_gu_dh_doc_header EDH ON
(
                    EDH.POR_ORG_CODE              = EL.POR_ORG_CODE        AND 
                    EDH.PLC_LOC_CODE              = EL.PLC_LOC_cODE        AND 
                    EDH.PDP_DEPT_CODE             = EL.PDP_DEPT_cODE       AND  
                    EDH.PBC_BUSICLASS_CODE        = EL.PBC_BUSICLASS_CODE  AND 
                    EDH.PIY_INSUTYPE              = EL.PIY_INSUTYPE        AND 
                    EDH.PDT_DOCTYPE               = EL.PDT_DOCTYPE         AND  
                    EDH.GDH_DOCUMENTNO            = EL.GDH_DOCUMENTNO      AND 
                    EDH.GDH_RECORD_TYPE           = EL.GDH_RECORD_TYPE     AND 
                    EDH.GDH_YEAR                  = EL.GDH_YEAR            
)
WHERE 
    PED_ENDOTYPE IN ('DC') AND 
GEL_BASEDOCUMENTNO = dh.Gdh_DOC_REFERENCE_NO AND EDH.GDH_CANCELLATION_TAG IS NULL 
and coalesce(edh.gdh_posting_tag,'N')=case 'Y' when 'Y' then 'Y' when 'N' then 'N' else coalesce(edh.gdh_posting_tag,'N') end 
)
order by dh.gdh_doc_reference_no)
--WHERE POLICY='NO'
)

;
--Bank wise Data

SELECT GDH_BASEDOCUMENTNO,GDH_DOC_REFERENCE_NO,PLC_LOCADESC,dh.PPS_PARTY_CODE,PPS_DESC,PDP_DEPTDESC,PBC_DESC,GDH_ISSUEDATE,GDH_EXPIRYDATE,GDH_TOTALSI,GDH_GROSSPREMIUM,GDH_NETPREMIUM,bd.*,VCHDATE,KNOCKOFFAMOUNT,PVT_VCHTTYPE,PFS_ACNTYEAR,LVH_VCHDNO 
FROM GI_GU_BD_BANKDTL BD
left outer join GI_GU_DH_DOC_HEADER dh
on (
bd.POR_ORG_CODE||bd.PLC_LOC_CODE||bd.PDP_DEPT_CODE||bd.PBC_BUSICLASS_CODE||bd.PIY_INSUTYPE||bd.GDH_DOCUMENTNO||bd.GDH_RECORD_TYPE||bd.PDT_DOCTYPE||bd.GDH_YEAR=
dh.POR_ORG_CODE||dh.PLC_LOC_CODE||dh.PDP_DEPT_CODE||dh.PBC_BUSICLASS_CODE||dh.PIY_INSUTYPE||dh.GDH_DOCUMENTNO||dh.GDH_RECORD_TYPE||dh.PDT_DOCTYPE||dh.GDH_YEAR
) 
left outer join COLLECTION_TABLE ct 
on ( GDH_DOC_REFERENCE_NO=docref
)
left outer join PR_GN_LC_LOCATION lc
on (dh.PLC_LOC_CODE=lc.PLC_LOCaCODE

)
left outer join PR_GN_PS_PARTY pp
on (
dh.PPS_PARTY_CODE=pp.PPS_PARTY_CODE
)
left outer join (select distinct PDP_DEPTCODE,PDP_DEPTDESC from PR_GN_DP_DEPARTMENT) dd
on (dd.PDP_DEPTCODE=dh.PDP_DEPT_CODE)

left outer join PR_GG_BC_BUSINESS_CLASS bc
on (
dh.PBC_BUSICLASS_CODE=bc.PBC_BUSICLASS_CODE and dd.PDP_DEPTCODE=bc.PDP_DEPT_CODE
)


WHERE bd.GDH_YEAR=2018 and GDH_ISSUEDATE between '01-apr-2018' and '30-sep-2018' AND bd.GDH_RECORD_TYPE='O'
AND EXISTS 
(
SELECT 
'X' FROM HIL.PR_GN_BN_BANK B
Where
PBN_BNK_DESC LIKE '%Nation%'
 AND PBN_TYPE = 'D' AND BD.PBN_BNK_CODE=B.PBN_BNK_CODE
 );

SELECT GDH_DOC_REFERENCE_NO,GDH_BASEDOCUMENTNO,PLC_LOCADESC,dh.PPS_PARTY_CODE,PPS_DESC,PDP_DEPTDESC,PBC_DESC,GDH_ISSUEDATE,GDH_EXPIRYDATE,GDH_TOTALSI,GDH_GROSSPREMIUM,GDH_NETPREMIUM 
FROM GI_GU_BD_BANKDTL BD
left outer join GI_GU_DH_DOC_HEADER dh
on (
bd.POR_ORG_CODE||bd.PLC_LOC_CODE||bd.PDP_DEPT_CODE||bd.PBC_BUSICLASS_CODE||bd.PIY_INSUTYPE||bd.GDH_DOCUMENTNO||bd.GDH_RECORD_TYPE||bd.PDT_DOCTYPE||bd.GDH_YEAR=
dh.POR_ORG_CODE||dh.PLC_LOC_CODE||dh.PDP_DEPT_CODE||dh.PBC_BUSICLASS_CODE||dh.PIY_INSUTYPE||dh.GDH_DOCUMENTNO||dh.GDH_RECORD_TYPE||dh.PDT_DOCTYPE||dh.GDH_YEAR
) 
left outer join PR_GN_LC_LOCATION lc on (dh.PLC_LOC_CODE=lc.PLC_LOCaCODE)
left outer join PR_GN_PS_PARTY pp on (dh.PPS_PARTY_CODE=pp.PPS_PARTY_CODE)
left outer join (select distinct PDP_DEPTCODE,PDP_DEPTDESC from PR_GN_DP_DEPARTMENT) dd on (dd.PDP_DEPTCODE=dh.PDP_DEPT_CODE)
left outer join PR_GG_BC_BUSINESS_CLASS bc on (dh.PBC_BUSICLASS_CODE=bc.PBC_BUSICLASS_CODE and dd.PDP_DEPTCODE=bc.PDP_DEPT_CODE)
WHERE bd.GDH_YEAR=2017 and GDH_ISSUEDATE between '01-JAN-2017' and '31-DEC-2017' AND bd.GDH_RECORD_TYPE='O'
AND DH.GDH_CANCELLATION_TAG IS NULL AND DH.PDT_DOCTYPE='P'
AND DH.PPS_PARTY_cODE NOT IN ('1300019811','1103000045')
AND EXISTS 
(
SELECT 
'X' FROM HIL.PR_GN_BN_BANK B
Where
upper(PBN_BNK_DESC) LIKE '%BANK AL HABIB%'
 AND PBN_TYPE = 'D' AND BD.PBN_BNK_CODE=B.PBN_BNK_CODE
 )
 
 ;
SELECT GDH_DOC_REFERENCE_NO,GDH_BASEDOCUMENTNO,PLC_LOCADESC,dh.PPS_PARTY_CODE,PPS_DESC,PDP_DEPTDESC,PBC_DESC,GDH_ISSUEDATE,GDH_EXPIRYDATE,GDH_TOTALSI,GDH_GROSSPREMIUM,GDH_NETPREMIUM 
FROM GI_GU_BD_BANKDTL BD
left outer join GI_GU_DH_DOC_HEADER dh
on (
bd.POR_ORG_CODE||bd.PLC_LOC_CODE||bd.PDP_DEPT_CODE||bd.PBC_BUSICLASS_CODE||bd.PIY_INSUTYPE||bd.GDH_DOCUMENTNO||bd.GDH_RECORD_TYPE||bd.PDT_DOCTYPE||bd.GDH_YEAR=
dh.POR_ORG_CODE||dh.PLC_LOC_CODE||dh.PDP_DEPT_CODE||dh.PBC_BUSICLASS_CODE||dh.PIY_INSUTYPE||dh.GDH_DOCUMENTNO||dh.GDH_RECORD_TYPE||dh.PDT_DOCTYPE||dh.GDH_YEAR
) 
left outer join PR_GN_LC_LOCATION lc on (dh.PLC_LOC_CODE=lc.PLC_LOCaCODE)
left outer join PR_GN_PS_PARTY pp on (dh.PPS_PARTY_CODE=pp.PPS_PARTY_CODE)
left outer join (select distinct PDP_DEPTCODE,PDP_DEPTDESC from PR_GN_DP_DEPARTMENT) dd on (dd.PDP_DEPTCODE=dh.PDP_DEPT_CODE)
left outer join PR_GG_BC_BUSINESS_CLASS bc on (dh.PBC_BUSICLASS_CODE=bc.PBC_BUSICLASS_CODE and dd.PDP_DEPTCODE=bc.PDP_DEPT_CODE)
WHERE bd.GDH_YEAR=2017 and GDH_ISSUEDATE between '01-JAN-2017' and '31-DEC-2017' AND bd.GDH_RECORD_TYPE='O'
AND DH.GDH_CANCELLATION_TAG IS NULL AND DH.PDT_DOCTYPE='P'
--AND DH.PPS_PARTY_cODE NOT IN ('1300019811','1103000045')
AND EXISTS 
(
SELECT 
'X' FROM HIL.PR_GN_BN_BANK B
Where
PBN_BNK_DESC LIKE '%Nation%'
 AND PBN_TYPE = 'D' AND BD.PBN_BNK_CODE=B.PBN_BNK_CODE
 )
 
 ;


--Make Modal Motor Document wise
SELECT 
--G.GDH_DOC_REFERENCE_NO, 
count(a.pmk_make_Code)
FROM HIL.GI_GU_DH_DOC_HEADER G
left outer join GI_GU_ID_ITEM_DETAIL A 
          ON (    G.por_org_code = a.por_org_code
              AND G.plc_loc_code = a.plc_loc_code
              AND G.pdp_dept_code = a.pdp_dept_code
              AND G.pbc_busiclass_code = a.pbc_busiclass_code
              AND G.piy_insutype = a.piy_insutype
              AND G.pdt_doctype = a.pdt_doctype
              AND G.gdh_documentno = a.gdh_documentno
              AND G.gdh_record_type = a.gdh_record_type
              AND G.gdh_year = a.gdh_year
             )
Where
--G.GDH_YEAR = '2018'
  G.PDT_DOCTYPE in ('P')
 AND G.GDH_ISSUEDATE BETWEEN '01-nov-2017' AND '31-DEC-2018'
 AND G.GDH_RECORD_TYPE = 'O'
 AND G.GDH_POSTING_TAG = 'Y'
 AND G.GDH_CANCELLATION_TAG IS NULL
and g.pdp_dept_Code=13
--AND G.PIY_INSUTYPE IN ('O','D')
and a.pmk_make_Code in  (select pmk_make_Code from PR_GT_MK_MAKE mk where UPPER(PMK_DESC) LIKE 'TOYOTA%' ) 
; 

3026 direct
 579 other lead
3605 total
 
 
 --AND G.PIY_INSUTYPE IN ('O','D')
 --and GDH_DOC_REFERENCE_NO='2018/01/CBDVPCDP00011'
-- group by G.GDH_DOC_REFERENCE_NO
 ;



--Make Modal Motor Client Wise
SELECT 
--G.GDH_DOC_REFERENCE_NO, 
count(a.pmk_make_Code)
FROM HIL.GI_GU_DH_DOC_HEADER G
left outer join GI_GU_ID_ITEM_DETAIL A 
          ON (    G.por_org_code = a.por_org_code
              AND G.plc_loc_code = a.plc_loc_code
              AND G.pdp_dept_code = a.pdp_dept_code
              AND G.pbc_busiclass_code = a.pbc_busiclass_code
              AND G.piy_insutype = a.piy_insutype
              AND G.pdt_doctype = a.pdt_doctype
              AND G.gdh_documentno = a.gdh_documentno
              AND G.gdh_record_type = a.gdh_record_type
              AND G.gdh_year = a.gdh_year
             )
Where
--G.GDH_YEAR = '2018'
  G.PDT_DOCTYPE in ('P')
 AND G.GDH_ISSUEDATE BETWEEN '01-nov-2017' AND '31-DEC-2018'
 AND G.GDH_RECORD_TYPE = 'O'
 AND G.GDH_POSTING_TAG = 'Y'
 AND G.GDH_CANCELLATION_TAG IS NULL
and g.pdp_dept_Code=13
AND G.PIY_INSUTYPE IN ('O','D')
and PPS_PARTY_CODE in ('1300019811','1300020912','1300020782')
and a.pmk_make_Code in  (select pmk_make_Code from PR_GT_MK_MAKE mk where UPPER(PMK_DESC) LIKE 'TOYOTA%' ) 
; 


--Unposted intimation
SELECT 
   ROWID, G.POR_ORG_CODE, G.PLC_LOC_CODE, G.PDP_DEPT_CODE, 
   G.PDT_DOCTYPE, G.GIH_DOCUMENTNO, G.GIH_INTI_ENTRYNO, 
   G.GIH_YEAR, G.PBC_BUSICLASS_CODE, G.POC_LOSSCODE, 
   G.PIY_INSUTYPE, G.GIH_INTIMATIONDATE, G.GIH_DATEOFLOSS, 
   G.PPS_PARTY_CODE, G.GIH_LOSSCLAIMED, G.GIH_CLAIMPAID, 
   G.GIH_SURVEYFEEPAID, G.GIH_SALVAGE, G.GIH_THEIRREFNO, 
   G.GIH_SETTELMENTTAG, G.GIH_POSTINGTAG, G.GIH_CANCELLATIONTAG, 
   G.GIH_CLAIMREVISE, G.GIH_DOC_REF_NO, G.GIH_NOCLAIM_TAG, 
   G.GIH_CLAIMREJ_TAG, G.GIH_FULLFINAL_TAG, G.GIH_REMARKS, 
   G.GIH_BALANCE, G.GIH_AS400_CLAIMNO, G.GIH_REVISIONDATE, 
   G.PNL_LOSSNATURE_CODE, G.GIH_LOSSASSESSED, G.GIH_LOSSADJUSTED, 
   G.GIH_POLICESTATION, G.GIH_FIRNO, G.GIH_PLACEOFTHEFT, 
   G.PRR_CODE, G.PDL_CODE, G.PHO_CODE, 
   G.PCE_CODE, G.GIH_CLAIM_ONOPENPOLICY, G.GIH_ADMISSION_DATE, 
   G.GIH_DISCHARGE_DATE, G.PDG_CODE, G.GIH_OPENPOLICY_NO, 
   G.GIH_OPENPOLICY_CLAIMAMT, G.PPS_INSU_CODE, G.GIH_CREATEUSER, 
   G.GIH_CREATEDATE, G.GIH_OLDCLAIM_NO, G.GIH_POLICYNO, 
   G.GIH_MEMBER_CODE, G.GIH_MEMBER_NAME, G.GIH_PATIENT_ITEMNO, 
   G.GIH_PATIENT_NAME, G.GIH_MEMBER_DOCREF_NO, G.PPL_CODE, 
   G.GIH_GENDER, G.GIH_AGE, G.GIH_DOB, 
   G.PRL_CODE, G.GIH_HEALTHCARD_NO, G.PCV_CODE, 
   G.GIH_COVER_TYPE, G.GIH_PANEL_LIMIT, G.GIH_NONPANEL_LIMIT, 
   G.GIH_OPT_COVERLIMIT, G.GIH_OPT_LIMITACTIVATED, G.GIH_LIMIT_UTILIZED, 
   G.GIH_PANEL_AVAILLIMIT, G.GIH_NONPANEL_AVAILLIMIT, G.GIH_PANELNONPANEL_CLAIM, 
   G.GIH_CLAIM_FROM, G.GIH_EXGRATIA_CLAIM, G.GIH_CURRENTVISIT_NO, 
   G.PDR_CODE, G.GIH_DOCTOR_NAME, G.PDR_CLINIC, 
   G.GIH_SELF_ITEMNO, G.GIH_SELF_DOCREFNO, G.PCP_CODE, 
   G.PCL_CODE, G.PRE_CODE, G.GIH_HOSP_ROOMRATE, 
   G.GIH_NOOFDAYS_ADMIT, G.GIH_ROOMBILL_AMOUNT, G.GIH_ROOMBILL_PAIDAMOUNT, 
   G.GIH_ROOMBILL_EXCESSAMOUNT, G.GIH_ROOMBILL_SPECIALFAVOR, G.GIH_SPEC_FIRSTVISITFEES, 
   G.GIH_SPEC_FOLLOWUPVISITFEES, G.GIH_PCP_FREEVISITREMAIN, G.GIH_SPEC_FREEVISITREMAIN, 
   G.GIH_THIRDPARTY_TAG, G.GIH_CORPORATEPOOL_LIMIT, G.GIH_RECOVERY_RATE, 
   G.GIH_RECOVERY_AMOUNT, G.GIH_CORPPOOLLIMIT_UTILIZED, G.GIH_CORPPOOLLIMIT_AVAILABLE, 
   G.GIH_CORPPOOL_CODE, G.GIH_LIMIT_TYPE, G.GIH_REIMBURSED_CLAIM, 
   G.GIH_OURSHARE_RATE, G.GIH_FACRECOVERY_AMOUNT, G.GIH_CORPORATEPOOL_SUBLIMIT, 
   G.GIH_CORPPOOLSUBLIMIT_UTILIZED, G.GIH_CORPPOOLSUBLIMIT_AVAILABLE, G.PBN_CODE, 
   G.POJ_CODE, G.GIH_OBJECTION_REMARKS, G.PCV_SUBLIM_PRIMCOVER, 
   G.GIH_COVER_SUBLIMIT, G.GIH_COVERSUBLIMIT_UTILIZED, G.GIH_COVERSUBLIMIT_AVAILABLE, 
   G.GIH_MAL_AMOUNT, G.GIH_MAL_UTILIZED, G.GIH_MAL_AVAILABLE, 
   G.GIH_PATIENT_EFFECDATE, G.PCO_CTRY_CODE, G.PCO_CITY_CODE, 
   G.GIH_PATIENTEXPIRY_DATE, G.GIH_OBJ_NAME, G.GIH_OBJ_AMOUNT, 
   G.GIH_POOLRELLIMIT, G.GIH_POOLRELLIMIT_UTILIZED, G.GIH_POOLRELLIMIT_AVAILABLE, 
   G.GIH_POOLFAMSUBLIMIT, G.GIH_POOLFAMSUBLIMIT_UTILIZED, G.GIH_POOLFAMSUBLIMIT_AVAILABLE, 
   G.GIH_POOLSUBLIMITCOVERTYPE, G.GIH_POOLCOVERSUBLIMIT, G.GIH_POOLCOVERSUBLIMIT_UTIL, 
   G.GIH_POOLCOVERSUBLIMIT_LEFT, G.GIH_OD_REMARKS, G.GIH_POLICY_COMMDATE, 
   G.PWC_CODE, G.PPS_PARTY_CODE_OLD, G.POC_LOSSCODE_OLD, 
   G.GIH_CLAIMANT_INFO, G.GIH_LOSS_OURSHARE, G.GIH_SURV_OURSHARE, 
   G.GIH_ADVOCATE_OURSHARE, G.GIH_MANUAL_DIST, G.GIH_MANUAL_PRCLSHARE, 
   G.GIH_MANUAL_COMPNETSHARE, G.GIH_MANUAL_EXCESSSHARE, G.GIH_POST_USER, 
   G.GIH_POST_DATE, G.GCR_CODE, G.GIH_DELAY_REMARKS, 
   G.PCR_CODE, G.GIH_FC_EXCHRATE, G.PCR_CODE_CLAIMED, 
   G.GIH_FC_EXCHRATE_CLAIMED, G.GIH_CHECK_FIELD, G.GIH_STATUS_DATE, 
   G.GIH_STATUS_REASON, G.GIH_XOL_NET, G.GIH_XOLTREATY_AMT, 
   G.GIH_XOL_EXCESS, G.GIH_XOL_DEDUCTIBLE, G.GIH_DEDUCTIBLE_YEAR, 
   G.GIH_DEDUCTIBLE_TREATY, G.GIH_ASSESSMENT_DATE, G.GIH_APPROVAL_DATE, 
   G.GIH_POOLSLOTAMOUNT, G.GIH_POOL_NO_OF_CLAIMS, G.GIH_POOL_NO_OF_CLAIMS_UTIL, 
   G.GIH_COVER_SUBLIMIT_SUB, G.GIH_COVERSUBLIMIT_UTILIZED_SUB, G.GIH_COVERSUBLMT_AVAILABLE_SUB, 
   G.GIH_DEDUCTABLE_PERCENTAGE, G.GIH_DEDUCTABLE_AMOUNT, G.GIH_RESERVE_TYPE, 
   G.PCV_SUBLIM_SUB_PRIMCOVER, G.GIH_CANCEL_USER, G.GIH_CANCEL_DATE, 
   G.GIH_LATECLAIM, G.GIH_ADDITIONAL_REMARKS, G.PRJ_CODE, 
   G.GIH_CALLER_NAME, G.GIH_CALLER_NO, G.OLD_PARTY_CODE, 
   G.NETOFF_DATE, G.GIH_CALL_CENTER_ID, G.PPR_PRODCODE, 
   G.GIH_REJECTED_TAG, G.GIH_SALVAGE_OURSHARE, G.GIH_PCR_CODE_TYPE, 
   G.PHT_CODE, G.GIH_DEDUCTION_TAG, G.PCM_CODE
FROM HIL.GI_GC_IH_INTIMATIONHD G
Where
GIH_INTIMATIONDATE BETWEEN '01-jan-2018' AND '31-dec-2018'
 AND GIH_POSTINGTAG IS NULL 
ORDER BY POR_ORG_CODE, PLC_LOC_CODE, PDP_DEPT_CODE, PDT_DOCTYPE, GIH_DOCUMENTNO, GIH_INTI_ENTRYNO, GIH_YEAR

;

--Unposted Settlement

SELECT 
   ROWID, G.POR_ORG_CODE, G.PLC_LOC_CODE, G.PDP_DEPT_CODE, 
   G.PDT_DOCTYPE, G.GIH_DOCUMENTNO, G.GIH_INTI_ENTRYNO, 
   G.GIH_YEAR, G.GSH_ENTRYNO, G.PPS_PARTY_CODE, 
   G.GSH_LOSSCLAIMED, G.GSH_SETTLEMENTDATE, G.GSH_LOSSASSESSED, 
   G.GSH_LOSSPAID, G.GSH_SURVEYFEE, G.GSH_OTHERCHARGES, 
   G.GSH_SALVAGE, G.GSH_POSTINGTAG, G.GSH_CANCELLATION, 
   G.GSH_DOC_REF_NO, G.GSH_PAYEE, G.GSH_FULLFINAL_TAG, 
   G.GSH_REMARKS, G.GSH_INSURED_LOSS, G.GSH_THIRDPARTY_LOSS, 
   G.GSH_LOSSESTIMATED, G.GSH_LOSSADJUSTED, G.GSH_CREATEUSER, 
   G.GSH_CREATEDATE, G.GSH_OLDCLAIM_NO, G.GSH_FACRECOVERY_AMOUNT, 
   G.GSH_LOSS_OURSHARE, G.GSH_SURV_OURSHARE, G.GSH_ADVOCATE_OURSHARE, 
   G.PCR_CODE, G.GSH_FC_EXCHRATE, G.PCR_CODE_CLAIMED, 
   G.GSH_FC_EXCHRATE_CLAIMED, G.GSH_XOL_NET, G.GSH_XOLTREATY_AMT, 
   G.GSH_XOL_EXCESS, G.GSH_XOL_DEDUCTIBLE, G.GSH_DEDUCTIBLE_YEAR, 
   G.GSH_DEDUCTIBLE_TREATY, G.OLD_PARTY_CODE, G.GSH_REASONFORSETTLEMENT, 
   G.GSH_POST_USER, G.GSH_POSTING_DATE, G.GSH_REASON_FOR_SETTLEMENT, 
   G.GSH_BY_ACCOUNT, G.GSH_CHECK_FIELD, G.GSH_SALVAGE_OURSHARE, 
   G.GSH_AUTO_KNOCKOFFTAG, G.GSH_PROCESS_TAG, G.PBN_CODE
FROM HIL.GI_GC_SH_SETTELMENTHD G
Where
GSH_SETTLEMENTDATE between '01-jan-2018' AND '31-dec-2018'
 AND GSH_POSTINGTAG IS NULL 
ORDER BY POR_ORG_CODE, PLC_LOC_CODE, PDP_DEPT_CODE, PDT_DOCTYPE, GIH_DOCUMENTNO, GIH_INTI_ENTRYNO, GIH_YEAR, GSH_ENTRYNO

-- unposted accounts 

SELECT 
    A.POR_ORGACODE, A.PLC_LOCACODE,PLC_LOCADESC, A.PVT_VCHTTYPE, 
   A.PFS_ACNTYEAR, A.LVH_VCHDNO, 
--   A.PAG_AGVCAGEVALCOMB, 
--   A.PPT_PTYPCODE, 
--   A.PCR_CURRCODE, 
   A.LVH_VCHDDATE, 
   A.LVH_VCHDTOTAL, 
--   A.PSY_SYSTCODE, 
   A.LVH_VCHDNARRATION, 
   A.LVH_VCHDAUTOMANUAL,
--   , A.LVH_VCHDREVERSAL, A.LVH_VCHDKNOCKOFF, 
--   A.LVH_VCHTKNOCKOFFAMTFC, A.LVH_VCHTKNOCKOFFAMTBC, A.LVH_VCHDCREATUSR, 
--   A.LVH_VCHDCREATDAT, A.LVH_VCHDVERIFYUSR, A.LVH_VCHDVERIFYDAT, 
--   A.LVH_VCHDCANCELUSR, A.LVH_VCHDCANCELDAT, A.LVH_VCHDPOSTUSR, 
--   A.LVH_VCHDPOSTDAT, A.PAC_AGCTCODE, A.LVH_VCHDSTAUTS, 
--   A.LVH_VCHDVALUEDAT, A.PFM_FMODCODE, A.LVH_VCHDFREQVALUE, 
--   A.LVH_VCHDRECURRDAT, A.LVH_VCHDREVERSALDATE, A.LVH_VCHDDEFAULT,
    
   A.LVH_VCHDSTATUS
--   , A.PDT_DOTYCODE, A.LVH_DOCREFNO, 
--   A.LVH_VCHDADVICEREF, A.LVH_VCHDVOUCHERREF, A.ADT_CREATEUSER, 
--   A.ADT_CREATEDATE, A.ADT_MODIFIEDUSER, A.ADT_MODIFIEDDATE, 
--   A.ADT_ROUTINGSTATUS, A.ADT_LASTROUTINGUSER, A.ADT_LASTROUTINGDATE, 
--   A.LVH_VCHDPAYEE, A.LVH_VCHDDEPOSITDAT, A.LVH_VCHDCPRNO, 
--   A.LVH_VCHDBANK, A.LVH_VCHDBRANCH, A.LVH_VCHDTRANSTATUS, 
--   A.LVH_OLDREFNO
FROM HIL.AC_GL_VH_VOUCHER A,
PR_GN_LC_LOCATION l

Where
PFS_ACNTYEAR = '20182018'
 AND LVH_VCHDSTATUS NOT IN ('P','C')
 and A.LVH_VCHDDATE between '01-jan-2018' and '31-dec-2018'
 and a.plc_locacode=l.plc_locacode
 --AND SUBSTR(LVH_VCHDNO,1,2) NOT IN ('10')
ORDER BY POR_ORGACODE, PLC_LOCACODE, PVT_VCHTTYPE, PFS_ACNTYEAR, LVH_VCHDNO