

Select l.PLC_LOC_CODE AS Br ,

l.PLC_DESC AS Br_desc ,

h.PDP_DEPT_CODE AS Dept ,

d.PDP_DESC AS Dept_Desc ,h.GDH_DOC_REFERENCE_NO AS PolicyNo,

--COALESCE(H.GDH_RENEWAL_REF_NO,'N')GDH_RENEWAL_REF_NO,

--P2.PPS_DESC AS INSUREDBR,

--maxe.expiry as maxexpiry,

--h.pdo_devoffcode as devcode,

--coalesce(l.plc_branch_type,'N')takaful_branch,

coalesce(gdh_renewal_tag,'N') as Renew,COALESCE(maxe.expiry,H.GDH_EXPIRYDATE) expirydate,

--case when COALESCE (GDH_SUBDOCUMENTNO, 0)=0 then COALESCE(case coalesce(cn.pdt_doctype,'L') when 'N' then coalesce(cn.gdh_basedocumentno,'-') else case cOalesce( GDH_BASEDOC_TYPE,'no') when 'no' then '- ' when 'T' THEN '- ' else  coalesce(h.GDH_BASEDOCUMENTNO,'-') end end,'-') else COALESCE(H.GDH_RENEWAL_REF_NO,'-') end AS BaseDocNo,

--case when coalesce(l.plc_branch_type,'N')='T' then iy.piy_desc_tf else iy.piy_desc end piy_desc,

--case when coalesce(l.plc_branch_type,'N')='T' then org.por_orgadesc_tf else org.por_desc end cmpname,

--h.piy_insutype,COALESCE(H.GDH_AS400_DOCUMENTNO,'-')GDH_AS400_DOCUMENTNO,

--h.pps_folio_code,BC.PBC_DESC,

--COALESCE(IT.GID_CHASISNO,'-') AS CHASISNO,COALESCE(IT.GID_ENGINENO,'-') AS ENGINENO,coalesce(it.gid_registration,'- ')gid_registration,

--coalesce(mk.pmk_desc,'-')pmk_desc,coalesce(it.gid_yearofmfg,'-')gid_yearofmfg,

--case COALESCE (GDH_SUBDOCUMENTNO, 0) when 0 then 0 else GDH_SUBDOCUMENTNO  END AS SubDocNo,

--h.GDH_EXPIRYDATE AS Expiry ,

--,AGT.PPS_DESC AS Agency ,agt.pps_party_code as agency_code,

 

COALESCE(case COALESCE (GDH_SUBDOCUMENTNO, 0) when 0 then

case when coalesce(h.gdh_individual_client,'X')='X' then  p.PPS_DESC else  coalesce(h.gdh_individual_client,'X') end

else

case when coalesce(h.gdh_individual_client,'X')='X' then  p.PPS_DESC else  coalesce(h.gdh_individual_client,'X') end

 end,'-') AS Party ,

COALESCE(DH.SI,0) AS SumInsured ,COALESCE(DH.GP,0) AS GrossPrem,COALESCE(DH.NP,0) AS NetPrem ,coalesce(THD.FAC,0) as Facult

FROM 

GI_GU_DH_DOC_HEADER h

 

INNER JOIN (SELECT POR_ORG_CODE , PLC_LOC_CODE,PDP_DEPT_CODE,PBC_BUSICLASS_CODE,PIY_INSUTYPE,PDT_DOCTYPE,GDH_DOCUMENTNO ,GDH_RECORD_TYPE,GDH_YEAR, MAX(PPS_PARTY_CODE)PPS_PARTY_CODE  FROM  GI_GU_AD_AGENCYDTL

GROUP BY POR_ORG_CODE , PLC_LOC_CODE,PDP_DEPT_CODE,PBC_BUSICLASS_CODE,PIY_INSUTYPE,PDT_DOCTYPE,GDH_DOCUMENTNO ,GDH_RECORD_TYPE,GDH_YEAR)ag

ON

(

h.POR_ORG_CODE   = ag.POR_ORG_CODE    and         

h.PLC_LOC_CODE      = ag.PLC_LOC_CODE       and  

h.PDP_DEPT_CODE   = ag.PDP_DEPT_CODE      and   

h.PBC_BUSICLASS_CODE = ag.PBC_BUSICLASS_CODE    and

h.PIY_INSUTYPE        = ag.PIY_INSUTYPE       and 

h.PDT_DOCTYPE       = ag.PDT_DOCTYPE        and 

h.GDH_DOCUMENTNO = ag.GDH_DOCUMENTNO    and     

h.GDH_RECORD_TYPE = ag.GDH_RECORD_TYPE  and     

h.GDH_YEAR               = ag.GDH_YEAR

)

left outer join

gi_gu_id_item_detail IT

ON

(

h.POR_ORG_CODE            = IT.POR_ORG_CODE    and         

h.PLC_LOC_CODE             = IT.PLC_LOC_CODE       and  

h.PDP_DEPT_CODE           = IT.PDP_DEPT_CODE      and   

h.PBC_BUSICLASS_CODE  = IT.PBC_BUSICLASS_CODE    and

h.PIY_INSUTYPE               = IT.PIY_INSUTYPE       and 

h.PDT_DOCTYPE              = IT.PDT_DOCTYPE        and 

h.GDH_DOCUMENTNO      = IT.GDH_DOCUMENTNO    and     

h.GDH_RECORD_TYPE      = IT.GDH_RECORD_TYPE and

h.GDH_YEAR                   = IT.GDH_YEAR  and     

IT.gih_itemno=1

and IT.gdh_record_type='O'

)     LEFT OUTER JOIN PR_GT_MK_MAKE MK ON (

 

IT.PMK_MAKE_CODE= MK.PMK_MAKE_CODE   

)

inner join

PR_GN_PS_PARTY AGT

on

(

AG.PPS_PARTY_cODE = AGT.PPS_PARTY_cODE

)

left outer join

(select ELHD.GDH_BASEDOCUMENTNO POLREF,max(gdh_doc_reference_no)  docref, GDH_EXPIRYDATE AS EXPIRY  from gi_gu_dh_doc_header ELHD

inner join

 

GI_GU_EL_ENDORSE_LOGBOOKHD EL

ON 

(

ELHD.POR_ORG_CODE               = EL.POR_ORG_CODE            AND 

ELHD.PLC_LOC_CODE               = EL.PLC_LOC_CODE            AND 

ELHD.PDP_DEPT_CODE              = EL.PDP_DEPT_CODE           AND 

ELHD.PDT_DOCTYPE                = EL.PDT_DOCTYPE             AND 

ELHD.GDH_DOCUMENTNO       = EL.GDH_DOCUMENTNO      AND     

ELHD.GDH_RECORD_TYPE       = EL.GDH_RECORD_TYPE     AND 

ELHD.GDH_YEAR                       = EL.GDH_YEAR 

)

where  ELHD.pdt_doctype ='E'   AND COALESCE(ELHD.GDH_POSTING_TAG,'N')='Y' and elhd.GDH_CANCELLATION_TAG   is null

and EL.PED_ENDOTYPE IN ('DC','PC','PE','PR') 

--and elhd.plc_loc_code between {?Branch From} and {?Branch To} and elhd.pdp_dept_code between {?Department From} and {?Department To}

group by ELHD.GDH_BASEDOCUMENTNO,GDH_EXPIRYDATE

) MAXE

ON

(

MAXE.POLREF=H.Gdh_DOC_REFERENCE_NO

)

INNER JOIN

PR_GN_DP_DEPARTMENT d

ON

(

h.por_org_code         = d.por_org_Code     and

h.plc_loc_code         = d.plc_loc_Code     and

h.pdp_dept_code        = d.pdp_dept_code    

)

INNER JOIN

(SELECT DOCREF,SUM(COALESCE(SI,0)) AS SI,SUM(COALESCE(GP,0)) AS GP,SUM(COALESCE(NP,0)) AS NP FROM

(SELECT  gdh_doc_reference_no AS DOCREF, GDH_TOTALSI AS SI,GDH_GROSSPREMIUM AS GP,GDH_NETPREMIUM AS NP 

 

FROM         GI_GU_DH_DOC_HEADER 

 

where pdt_doctype IN ('P','C')

AND GDH_RECORD_TYPE='O' 

--AND PLC_LOC_CODE BETWEEN {?Branch From} AND {?Branch To}

--AND PDP_DEPT_CODE BETWEEN {?Department From} AND {?Department To} AND charindex(piy_insutype,{?INSUTYPE})>0

UNION  all

SELECT  gdh_basedocumentno, GDH_TOTALSI,GDH_GROSSPREMIUM,GDH_NETPREMIUM  FROM         GI_GU_DH_DOC_HEADER 

where pdt_doctype IN ('E')  AND COALESCE(GDH_POSTING_TAG,'N')='Y' and GDH_CANCELLATION_TAG   is null

AND GDH_RECORD_TYPE='O' 

--AND PLC_LOC_CODE BETWEEN {?Branch From} AND {?Branch To} AND PDP_DEPT_CODE BETWEEN {?Department From} AND {?Department To} AND charindex(piy_insutype,{?INSUTYPE})>0

) DOC

GROUP BY DOCREF

)  DH

ON (h.GDH_DOC_REFERENCE_NO=DH.DOCREF )

inner join PR_GN_LC_LOCATION l

on

(

h.por_org_code          = l.por_org_Code     and

h.plc_loc_code              = l.plc_loc_Code )

 

left outer join pr_gn_or_organization org on org.por_org_code=h.por_org_code

inner join PR_GN_PS_PARTY p on (

h.por_org_code         = p.por_org_Code     and

h.pps_party_code        = p.pps_party_Code)

LEFT OUTER JOIN PR_GN_PS_PARTY p2 ON (H.PPS_FOLIO_CODE=P2.PPS_PARTY_CODE

)

inner join PR_GG_IY_INSURANCETYPE iy on (iy.piy_insutype=h.piy_insutype)

 

INNER JOIN PR_GG_BC_BUSINESS_CLASS BC ON (H.PBC_BUSICLASS_CODE=BC.PBC_BUSICLASS_CODE

)

left outer join

(SELECT  GSI_DOC_REFERENCE_NO ,SUM(COALESCE(GSI_FACULTPREM,0))+SUM(COALESCE(GSI_FOREIGN_FACULTPREM,0))  FAC

FROM

GI_GR_SI_TREATYFACULTHD

WHERE ( COALESCE(GSI_FACULTPREM,0) >0 OR COALESCE(GSI_FOREIGN_FACULTPREM,0) >0 )

--and plc_loc_code between {?Branch From} and {?Branch To} and pdp_dept_code between {?Department From} and {?Department To}

GROUP BY GSI_DOC_REFERENCE_NO) THD

on

(

H.GDH_DOC_REFERENCE_NO = THD.GSI_DOC_REFERENCE_NO

) 

 

left outer join (select pdt_doctype, gdh_doc_reference_no, gdh_basedocumentno from gi_gu_dh_doc_header  where

gdh_record_type='O' and pdt_doctype ='N'

--and plc_loc_code between {?Branch From} and {?Branch To} and pdp_dept_code between {?Department From} and {?Department To}

)cn on h.gdh_basedocumentno=cn.gdh_doc_reference_no

 

where

--h.GDH_CANCELLATION_TAG   is null    and {?PARAMETER}={?PARAMETER}

--AND {?SLINE}={?SLINE} and

--COALESCE(ag.pps_party_code,'N') between case {?AGENTFROM} when 'All' then COALESCE(ag.pps_party_code,'N') else {?AGENTFROM} end and case {?AGENTTO} when 'All' then COALESCE(ag.pps_party_code,'N') else {?AGENTTO} end and

--h.PPS_folio_CODE BETWEEN CASE {?INSUREDFROM} WHEN 'All' then h.PPS_folio_CODE else {?INSUREDFROM} end AND  case {?INSUREDTO} when 'All' then  h.PPS_folio_CODE else {?INSUREDTO} end  AND 

--h.plc_loc_code between {?Branch From} and {?Branch To} and   {?Date From}={?Date From} and {?Date To}={?Date To} and

h.pdp_dept_code in ('11','13','14','15')

 

--h.pdp_dept_code between {?Department From}    and {?Department To} AND

and COALESCE(maxe.expiry,H.GDH_EXPIRYDATE) BETWEEN '01-JAN-2019' AND '30-APR-2019'

and h.piy_insutype in ('O','D')

AND coalesce(gdh_renewal_tag,'N')='N'

--AND charindex(h.piy_insutype,{?INSUTYPE})>0

--and coalesce(h.pdo_devoffcode,'00001') between case {?DEVFROM} when 'All' then coalesce(h.pdo_devoffcode,'00001')  else {?DEVFROM} end and case {?DEVTO} when 'All' then coalesce(h.pdo_devoffcode,'00001')  else {?DEVTO} end

AND

(

h.PDT_DOCTYPE =CASE 'Y' WHEN 'Y'  THEN 'P'  WHEN 'N' THEN 'P' ELSE 'P' END

OR

h.PDT_DOCTYPE =CASE 'Y' WHEN 'Y'  THEN 'O' WHEN 'N' THEN 'P' ELSE 'P' END

) AND

 

h.GDH_RECORD_TYPE    = 'O'

--and coalesce(gdh_renewal_tag,'N')= CASE {?Renewal} WHEN  'Y' Then 'Y' when 'N' Then 'N' else coalesce(gdh_renewal_tag,'N') end    

ORDER BY  h.pdt_doctype,h.gdh_documentno

 

;

 

 

--SUMMARY rEPORT

SELECT  Br_desc,DEPT_DESC,COUNT(POLICYNO),SUM(SUMINSURED),SUM(GROSSPREM),SUM(NETPREM),SUM(FACULT) FROM(

Select l.PLC_LOC_CODE AS Br ,

l.PLC_DESC AS Br_desc ,

h.PDP_DEPT_CODE AS Dept ,

d.PDP_DESC AS Dept_Desc ,h.GDH_DOC_REFERENCE_NO AS PolicyNo,

--COALESCE(H.GDH_RENEWAL_REF_NO,'N')GDH_RENEWAL_REF_NO,

--P2.PPS_DESC AS INSUREDBR,

--maxe.expiry as maxexpiry,

--h.pdo_devoffcode as devcode,

--coalesce(l.plc_branch_type,'N')takaful_branch,

coalesce(gdh_renewal_tag,'N') as Renew,COALESCE(maxe.expiry,H.GDH_EXPIRYDATE) expirydate,

--case when COALESCE (GDH_SUBDOCUMENTNO, 0)=0 then COALESCE(case coalesce(cn.pdt_doctype,'L') when 'N' then coalesce(cn.gdh_basedocumentno,'-') else case cOalesce( GDH_BASEDOC_TYPE,'no') when 'no' then '- ' when 'T' THEN '- ' else  coalesce(h.GDH_BASEDOCUMENTNO,'-') end end,'-') else COALESCE(H.GDH_RENEWAL_REF_NO,'-') end AS BaseDocNo,

--case when coalesce(l.plc_branch_type,'N')='T' then iy.piy_desc_tf else iy.piy_desc end piy_desc,

--case when coalesce(l.plc_branch_type,'N')='T' then org.por_orgadesc_tf else org.por_desc end cmpname,

--h.piy_insutype,COALESCE(H.GDH_AS400_DOCUMENTNO,'-')GDH_AS400_DOCUMENTNO,

--h.pps_folio_code,BC.PBC_DESC,

--COALESCE(IT.GID_CHASISNO,'-') AS CHASISNO,COALESCE(IT.GID_ENGINENO,'-') AS ENGINENO,coalesce(it.gid_registration,'- ')gid_registration,

--coalesce(mk.pmk_desc,'-')pmk_desc,coalesce(it.gid_yearofmfg,'-')gid_yearofmfg,

--case COALESCE (GDH_SUBDOCUMENTNO, 0) when 0 then 0 else GDH_SUBDOCUMENTNO  END AS SubDocNo,

--h.GDH_EXPIRYDATE AS Expiry ,

--,AGT.PPS_DESC AS Agency ,agt.pps_party_code as agency_code,

 

COALESCE(case COALESCE (GDH_SUBDOCUMENTNO, 0) when 0 then

case when coalesce(h.gdh_individual_client,'X')='X' then  p.PPS_DESC else  coalesce(h.gdh_individual_client,'X') end

else

case when coalesce(h.gdh_individual_client,'X')='X' then  p.PPS_DESC else  coalesce(h.gdh_individual_client,'X') end

 end,'-') AS Party ,

COALESCE(DH.SI,0) AS SumInsured ,COALESCE(DH.GP,0) AS GrossPrem,COALESCE(DH.NP,0) AS NetPrem ,coalesce(THD.FAC,0) as Facult

FROM 

GI_GU_DH_DOC_HEADER h

 

INNER JOIN (SELECT POR_ORG_CODE , PLC_LOC_CODE,PDP_DEPT_CODE,PBC_BUSICLASS_CODE,PIY_INSUTYPE,PDT_DOCTYPE,GDH_DOCUMENTNO ,GDH_RECORD_TYPE,GDH_YEAR, MAX(PPS_PARTY_CODE)PPS_PARTY_CODE  FROM  GI_GU_AD_AGENCYDTL

GROUP BY POR_ORG_CODE , PLC_LOC_CODE,PDP_DEPT_CODE,PBC_BUSICLASS_CODE,PIY_INSUTYPE,PDT_DOCTYPE,GDH_DOCUMENTNO ,GDH_RECORD_TYPE,GDH_YEAR)ag

ON

(

h.POR_ORG_CODE   = ag.POR_ORG_CODE    and         

h.PLC_LOC_CODE      = ag.PLC_LOC_CODE       and  

h.PDP_DEPT_CODE   = ag.PDP_DEPT_CODE      and   

h.PBC_BUSICLASS_CODE = ag.PBC_BUSICLASS_CODE    and

h.PIY_INSUTYPE        = ag.PIY_INSUTYPE       and 

h.PDT_DOCTYPE       = ag.PDT_DOCTYPE        and 

h.GDH_DOCUMENTNO = ag.GDH_DOCUMENTNO    and     

h.GDH_RECORD_TYPE = ag.GDH_RECORD_TYPE  and     

h.GDH_YEAR               = ag.GDH_YEAR

)

left outer join

gi_gu_id_item_detail IT

ON

(

h.POR_ORG_CODE            = IT.POR_ORG_CODE    and         

h.PLC_LOC_CODE             = IT.PLC_LOC_CODE       and  

h.PDP_DEPT_CODE           = IT.PDP_DEPT_CODE      and   

h.PBC_BUSICLASS_CODE  = IT.PBC_BUSICLASS_CODE    and

h.PIY_INSUTYPE               = IT.PIY_INSUTYPE       and 

h.PDT_DOCTYPE              = IT.PDT_DOCTYPE        and 

h.GDH_DOCUMENTNO      = IT.GDH_DOCUMENTNO    and     

h.GDH_RECORD_TYPE      = IT.GDH_RECORD_TYPE and

h.GDH_YEAR                   = IT.GDH_YEAR  and     

IT.gih_itemno=1

and IT.gdh_record_type='O'

)     LEFT OUTER JOIN PR_GT_MK_MAKE MK ON (

 

IT.PMK_MAKE_CODE= MK.PMK_MAKE_CODE   

)

inner join

PR_GN_PS_PARTY AGT

on

(

AG.PPS_PARTY_cODE = AGT.PPS_PARTY_cODE

)

left outer join

(select ELHD.GDH_BASEDOCUMENTNO POLREF,max(gdh_doc_reference_no)  docref, GDH_EXPIRYDATE AS EXPIRY  from gi_gu_dh_doc_header ELHD

inner join

 

GI_GU_EL_ENDORSE_LOGBOOKHD EL

ON 

(

ELHD.POR_ORG_CODE               = EL.POR_ORG_CODE            AND 

ELHD.PLC_LOC_CODE               = EL.PLC_LOC_CODE            AND 

ELHD.PDP_DEPT_CODE              = EL.PDP_DEPT_CODE           AND 

ELHD.PDT_DOCTYPE                = EL.PDT_DOCTYPE             AND 

ELHD.GDH_DOCUMENTNO       = EL.GDH_DOCUMENTNO      AND     

ELHD.GDH_RECORD_TYPE       = EL.GDH_RECORD_TYPE     AND 

ELHD.GDH_YEAR                       = EL.GDH_YEAR 

)

where  ELHD.pdt_doctype ='E'   AND COALESCE(ELHD.GDH_POSTING_TAG,'N')='Y' and elhd.GDH_CANCELLATION_TAG   is null

and EL.PED_ENDOTYPE IN ('DC','PC','PE','PR') 

--and elhd.plc_loc_code between {?Branch From} and {?Branch To} and elhd.pdp_dept_code between {?Department From} and {?Department To}

group by ELHD.GDH_BASEDOCUMENTNO,GDH_EXPIRYDATE

) MAXE

ON

(

MAXE.POLREF=H.Gdh_DOC_REFERENCE_NO

)

INNER JOIN

PR_GN_DP_DEPARTMENT d

ON

(

h.por_org_code         = d.por_org_Code     and

h.plc_loc_code         = d.plc_loc_Code     and

h.pdp_dept_code        = d.pdp_dept_code    

)

INNER JOIN

(SELECT DOCREF,SUM(COALESCE(SI,0)) AS SI,SUM(COALESCE(GP,0)) AS GP,SUM(COALESCE(NP,0)) AS NP FROM

(SELECT  gdh_doc_reference_no AS DOCREF, GDH_TOTALSI AS SI,GDH_GROSSPREMIUM AS GP,GDH_NETPREMIUM AS NP 

 

FROM         GI_GU_DH_DOC_HEADER 

 

where pdt_doctype IN ('P','C')

AND GDH_RECORD_TYPE='O' 

--AND PLC_LOC_CODE BETWEEN {?Branch From} AND {?Branch To}

--AND PDP_DEPT_CODE BETWEEN {?Department From} AND {?Department To} AND charindex(piy_insutype,{?INSUTYPE})>0

UNION  all

SELECT  gdh_basedocumentno, GDH_TOTALSI,GDH_GROSSPREMIUM,GDH_NETPREMIUM  FROM         GI_GU_DH_DOC_HEADER 

where pdt_doctype IN ('E')  AND COALESCE(GDH_POSTING_TAG,'N')='Y' and GDH_CANCELLATION_TAG   is null

AND GDH_RECORD_TYPE='O' 

--AND PLC_LOC_CODE BETWEEN {?Branch From} AND {?Branch To} AND PDP_DEPT_CODE BETWEEN {?Department From} AND {?Department To} AND charindex(piy_insutype,{?INSUTYPE})>0

) DOC

GROUP BY DOCREF

)  DH

ON (h.GDH_DOC_REFERENCE_NO=DH.DOCREF )

inner join PR_GN_LC_LOCATION l

on

(

h.por_org_code          = l.por_org_Code     and

h.plc_loc_code              = l.plc_loc_Code )

 

left outer join pr_gn_or_organization org on org.por_org_code=h.por_org_code

inner join PR_GN_PS_PARTY p on (

h.por_org_code         = p.por_org_Code     and

h.pps_party_code        = p.pps_party_Code)

LEFT OUTER JOIN PR_GN_PS_PARTY p2 ON (H.PPS_FOLIO_CODE=P2.PPS_PARTY_CODE

)

inner join PR_GG_IY_INSURANCETYPE iy on (iy.piy_insutype=h.piy_insutype)

 

INNER JOIN PR_GG_BC_BUSINESS_CLASS BC ON (H.PBC_BUSICLASS_CODE=BC.PBC_BUSICLASS_CODE

)

left outer join

(SELECT  GSI_DOC_REFERENCE_NO ,SUM(COALESCE(GSI_FACULTPREM,0))+SUM(COALESCE(GSI_FOREIGN_FACULTPREM,0))  FAC

FROM

GI_GR_SI_TREATYFACULTHD

WHERE ( COALESCE(GSI_FACULTPREM,0) >0 OR COALESCE(GSI_FOREIGN_FACULTPREM,0) >0 )

--and plc_loc_code between {?Branch From} and {?Branch To} and pdp_dept_code between {?Department From} and {?Department To}

GROUP BY GSI_DOC_REFERENCE_NO) THD

on

(

H.GDH_DOC_REFERENCE_NO = THD.GSI_DOC_REFERENCE_NO

) 

 

left outer join (select pdt_doctype, gdh_doc_reference_no, gdh_basedocumentno from gi_gu_dh_doc_header  where

gdh_record_type='O' and pdt_doctype ='N'

--and plc_loc_code between {?Branch From} and {?Branch To} and pdp_dept_code between {?Department From} and {?Department To}

)cn on h.gdh_basedocumentno=cn.gdh_doc_reference_no

 

where

--h.GDH_CANCELLATION_TAG   is null    and {?PARAMETER}={?PARAMETER}

--AND {?SLINE}={?SLINE} and

--COALESCE(ag.pps_party_code,'N') between case {?AGENTFROM} when 'All' then COALESCE(ag.pps_party_code,'N') else {?AGENTFROM} end and case {?AGENTTO} when 'All' then COALESCE(ag.pps_party_code,'N') else {?AGENTTO} end and

--h.PPS_folio_CODE BETWEEN CASE {?INSUREDFROM} WHEN 'All' then h.PPS_folio_CODE else {?INSUREDFROM} end AND  case {?INSUREDTO} when 'All' then  h.PPS_folio_CODE else {?INSUREDTO} end  AND 

--h.plc_loc_code between {?Branch From} and {?Branch To} and   {?Date From}={?Date From} and {?Date To}={?Date To} and

h.pdp_dept_code in ('11','13','14','15')

 

--h.pdp_dept_code between {?Department From}    and {?Department To} AND

and COALESCE(maxe.expiry,H.GDH_EXPIRYDATE) BETWEEN '01-JAN-2019' AND '30-APR-2019'

and h.piy_insutype in ('O','D')

AND coalesce(gdh_renewal_tag,'N')='N'

--AND charindex(h.piy_insutype,{?INSUTYPE})>0

--and coalesce(h.pdo_devoffcode,'00001') between case {?DEVFROM} when 'All' then coalesce(h.pdo_devoffcode,'00001')  else {?DEVFROM} end and case {?DEVTO} when 'All' then coalesce(h.pdo_devoffcode,'00001')  else {?DEVTO} end

AND

(

h.PDT_DOCTYPE =CASE 'Y' WHEN 'Y'  THEN 'P'  WHEN 'N' THEN 'P' ELSE 'P' END

OR

h.PDT_DOCTYPE =CASE 'Y' WHEN 'Y'  THEN 'O' WHEN 'N' THEN 'P' ELSE 'P' END

) AND

 

h.GDH_RECORD_TYPE    = 'O'

--and coalesce(gdh_renewal_tag,'N')= CASE {?Renewal} WHEN  'Y' Then 'Y' when 'N' Then 'N' else coalesce(gdh_renewal_tag,'N') end    

ORDER BY  h.pdt_doctype,h.gdh_documentno

)

GROUP BY Br_desc,DEPT_DESC

ORDER BY Br_desc,DEPT_DESC

 

;