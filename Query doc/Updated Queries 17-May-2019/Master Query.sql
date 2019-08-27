--Intimation Count 16-May-2018 And 15-May-2019
SELECT
    pdp_dept_code,
    COUNT(gih_documentno)
FROM
    hil.gi_gc_ih_intimationhd
WHERE
        gih_intimationdate BETWEEN '16-May-2018' AND '15-MAY-2019'
    AND
        gih_inti_entryno = '1'
    AND
        gih_postingtag = 'Y'
    AND
        gih_cancellationtag IS NULL
GROUP BY
    pdp_dept_code
ORDER BY pdp_dept_code;


-----------------------------------------------------------------------------------




--Claim O/s Query

SELECT
--    br_desc,
        PPS_PARTY_,
    SUM(os)
FROM
    (
        SELECT

PPS_PARTY_CODE,
            insured,
            br_code,
            br_desc,
            pdp_code,
            pdp_desc,
            SUM(os) os
        FROM
            (
                SELECT --DISTINCT PPS_PARTY_CODE,INSURED,BR_CODE,BR_DESC,PDP_CODE,PDP_DESC,sum((TOTALLOSS*GIC_SHARE/100)-(TOTALPAID*GIC_SHARE/100))os

DISTINCT
PPS_PARTY_CODE,
                    insured,
                    br_code,
                    br_desc,
                    pdp_code,
                    pdp_desc,
                    gih_doc_ref_no,
                    gih_documentno,
                    gih_year,
                    coalesce(
                        ( (totalloss * gic_share) / 100),
                        0
                    ) - coalesce(
                        ( (totalpaid * gic_share) / 100),
                        0
                    ) os

--PPS_PARTY_CODE,INSURED,BR_CODE,BR_DESC,PDP_CODE,PDP_DESC,gih_doc_ref_no,gih_documentno,gih_year,TOTALLOSS,TOTALPAID,GIC_SHARE,(TOTALLOSS*GIC_SHARE/100) OSOURSHARE,(TOTALPAID*GIC_SHARE/100)OSPAID,(TOTALLOSS*GIC_SHARE/100)-(TOTALPAID*GIC_SHARE/100)os
                FROM
                    (
                        SELECT DISTINCT

--(SELECT DISTINCT POR_DESC FROM PR_GN_OR_ORGANIZATION WHERE POR_ORG_CODE='001001') CMPNAME,

--(select distinct pdp_desc from pr_gn_dp_department where pdp_dept_code= {?DEPARTMENT} )dep,

--(SELECT DISTINCT PLC_DESC FROM PR_GN_LC_LOCATION WHERE PLC_LOC_CODE= {?BRANCHFROM}) BR1,

--(SELECT DISTINCT PLC_DESC FROM PR_GN_LC_LOCATION WHERE PLC_LOC_CODE= {?BRANCHTO}) BR2,

--(select distinct pps_desc from pr_gn_ps_party)clients where pps_party_code={?CLIENTFROM})cl1,

(select distinct pps_desc from pr_gn_ps_party where pps_party_code='1100100001') cl1,--{?CLIENTTO})cl1,
(select distinct pps_desc from pr_gn_ps_party where pps_party_code='5100100021') cl2,--{?CLIENTTO})cl2,

--(select distinct PSR_SURV_NAME from PR_GG_SR_SURVEYOR where PSR_SURV_code={?SURVEYORFROM})S1,

--(select distinct PSR_SURV_NAME from PR_GG_SR_SURVEYOR where PSR_SURV_code={?SURYEYORTO})S2,
                            h.gis_registration_no,
                            h.gis_engine_no,
                            h.gis_sailing_date,
                            coalesce(
                                h.coinsurere,
                                'x'
                            ) coinsurere,
                            h.gis_chassis_no,

--h.bank,
                            h.plc_loc_code AS br_code,
                            h.branch AS br_desc,
                            h.piy_desc,
                            h.pdp_dept_code AS pdp_code,
                            h.department AS pdp_desc,
                            h.gih_oldclaim_no,
                            h.gih_doc_ref_no,
                            h.gih_documentno,
                            h.gih_year,
                            h.intimationno AS intimationno,
                            h.gih_dateofloss AS dateofloss,
                            h.poc_lossdesc AS lossdesc,
                            h.psr_surv_name,
                            h.gid_basedocumentno AS basedocno,
                            h.insured AS insured,
                            h.remarks,
                            h.place,
                            h.gid_commdate AS commdate,
                            coalesce(
                                h.gis_suminsured,
                                0
                            ) AS suminsured,
                            coalesce(
                                h.totloss,
                                0
                            ) AS totalloss,
                            coalesce(
                                h.losspay,
                                0
                            ) AS losspay,
                            coalesce(
                                h.suryorpay,
                                0
                            ) AS survpay,
                            coalesce(
                                h.advocatepay,
                                0
                            ) AS advocatepay,
                            salvage AS salvage,
                            coalesce(
                                h.totalpaid,
                                0
                            ) totalpaid,
                            h.gih_intimationdate AS intimationdate,
                            h.rev_date,
                            h.gid_expirydate AS expiry,
                            coalesce(
                                h.gic_share,
                                100
                            ) gic_share
                        FROM
                            (
                                ( SELECT 

IH.PPS_PARTY_CODE,
                                    ih.plc_loc_code AS plc_loc_code,
                                    bnk.pbn_bnk_desc bank,
                                    lc.plc_desc AS branch,
                                    dp.pdp_desc AS department,
                                    ih.gih_intimationdate AS gih_intimationdate,
                                    ih.gih_revisiondate rev_date,
                                    ih.pdp_dept_code AS pdp_dept_code,
                                    ih.gih_remarks remarks,
                                    ih.gih_placeoftheft place,
                                    ih.por_org_code AS org,
                                    ih.gih_year,
                                    ih.gih_doc_ref_no,
                                    ih.gih_documentno,
                                    ih.gih_oldclaim_no,
                                    ih.gih_inti_entryno AS intimationno,
                                    id.gid_basedocumentno AS gid_basedocumentno,
                                    ih.gih_dateofloss AS gih_dateofloss,
                                    sv.psr_surv_name,
                                    oc.poc_lossdesc AS poc_lossdesc,
                                    id.gid_commdate AS gid_commdate,
                                    id.gid_expirydate AS gid_expirydate,
                                    coalesce(
                                        ic.gic_share,
                                        100
                                    ) gic_share,
                                    piy.piy_desc,
                                    isubdtl.gis_registration_no,
                                    isubdtl.gis_engine_no,
                                    isubdtl.gis_chassis_no,
                                    isubdtl.gis_sailing_date,
                                    ins.pps_desc AS insured,
                                    coi.pps_desc coinsurere,
                                    SUM(coalesce(
                                        isubdtl.gis_suminsured,
                                        0
                                    ) ) AS gis_suminsured,
                                    SUM(coalesce(
                                        ih.gih_lossclaimed,
                                        0
                                    ) ) AS gsd_lossclaimed,
                                    SUM(coalesce(
                                        isubdtl.gis_surveyoramt,
                                        0
                                    ) ) AS suryoramt,
                                    SUM(coalesce(
                                        isubdtl.gis_advocateamt,
                                        0
                                    ) ) AS advoramt,
                                    SUM(
                                        CASE coalesce(
                                            isubdtl.gis_lossadjusted,
                                            0
                                        )
                                            WHEN 0   THEN
                                                CASE coalesce(
                                                    isubdtl.gis_lossassessed,
                                                    0
                                                )
                                                    WHEN 0   THEN
                                                        CASE coalesce(
                                                            isubdtl.gis_lossclaimed,
                                                            0
                                                        )
                                                            WHEN 0   THEN 0
                                                            ELSE coalesce(
                                                                isubdtl.gis_lossclaimed,
                                                                0
                                                            )
                                                        END
                                                    ELSE coalesce(
                                                        isubdtl.gis_lossassessed,
                                                        0
                                                    )
                                                END
                                            ELSE coalesce(
                                                isubdtl.gis_lossadjusted,
                                                0
                                            )
                                        END
                                    *
                                        CASE
                                            WHEN gih_noclaim_tag = 'N' THEN 0
                                            ELSE 1
                                        END
                                    + coalesce(
                                        isubdtl.gis_surveyoramt,
                                        0
                                    ) + coalesce(
                                        isubdtl.gis_advocateamt,
                                        0
                                    ) -
                                        CASE 'Y'
                                            WHEN 'Y'   THEN coalesce(
                                                isubdtl.gis_salvageamt,
                                                0
                                            )
                                            ELSE 0
                                        END
                                    ) AS totloss,
                                    losspay *
                                        CASE
                                            WHEN gih_noclaim_tag = 'N'  THEN 0
                                            ELSE 1
                                        END
                                    AS losspay,
                                    suryorpay AS suryorpay,
                                    advocatepay AS advocatepay,
                                    (
                                        CASE 'Y'
                                            WHEN 'Y'   THEN salvage
                                            ELSE 0
                                        END
                                    ) AS salvage,
                                    losspay + suryorpay + advocatepay - (
                                        CASE 'Y'
                                            WHEN 'Y'   THEN salvage
                                            ELSE 0
                                        END
                                    ) AS totalpaid
                                FROM
                                    gi_gc_ih_intimationhd ih
                                    LEFT OUTER JOIN gi_gc_id_intimationdtl id ON (
                                            ih.pdp_dept_code = id.pdp_dept_code
                                        AND
                                            ih.por_org_code = id.por_org_code
                                        AND
                                            ih.plc_loc_code = id.plc_loc_code
                                        AND
                                            ih.pdt_doctype = id.pdt_doctype
                                        AND
                                            ih.gih_documentno = id.gih_documentno
                                        AND
                                            ih.gih_inti_entryno = id.gih_inti_entryno
                                        AND
                                            ih.gih_year = id.gih_year
                                    )
                                    LEFT OUTER JOIN gi_gc_is_intimationsubdtl isubdtl ON (
                                            id.por_org_code = isubdtl.por_org_code
                                        AND
                                            id.plc_loc_code = isubdtl.plc_loc_code
                                        AND
                                            id.pdp_dept_code = isubdtl.pdp_dept_code
                                        AND
                                            id.pdt_doctype = isubdtl.pdt_doctype
                                        AND
                                            id.gih_documentno = isubdtl.gih_documentno
                                        AND
                                            id.gih_inti_entryno = isubdtl.gih_inti_entryno
                                        AND
                                            id.gih_year = isubdtl.gih_year
                                        AND
                                            id.gid_ply_serialno = isubdtl.gid_ply_serialno
                                    )
                                    LEFT OUTER JOIN gi_gc_ic_intimation_coinsurer ic ON (
                                            id.por_org_code = ic.por_org_code
                                        AND
                                            id.plc_loc_code = ic.plc_loc_code
                                        AND
                                            id.pdp_dept_code = ic.pdp_dept_code
                                        AND
                                            id.pdt_doctype = ic.pdt_doctype
                                        AND
                                            id.gih_documentno = ic.gih_documentno
                                        AND
                                            id.gih_inti_entryno = ic.gih_inti_entryno
                                        AND
                                            id.gih_year = ic.gih_year
                                        AND
                                            id.gid_basedocumentno = ic.gic_basedocumentno
                                        AND
                                            ic.gic_coretag = 'C'
                                        AND
                                            ic.gic_leadertag = 'Y'
                                    )
                                    LEFT OUTER JOIN pr_gn_ps_party coi ON (
                                            coi.por_org_code = ih.por_org_code
                                        AND
                                            coi.pps_party_code = ih.pps_insu_code
                                    )
                                    INNER JOIN (
                                        SELECT
                                            gih_doc_ref_no,
                                            MAX(gih_inti_entryno * 1) entryno
                                        FROM
                                            gi_gc_ih_intimationhd
                                        WHERE

--pdp_dept_code = '11'  and 
                                                    CASE gih_inti_entryno
                                                        WHEN '1'   THEN TO_DATE(gih_intimationdate)
                                                        ELSE TO_DATE(gih_revisiondate)
                                                    END
                                                BETWEEN '01-jan-2000' AND '31-dec-2018'
                                            AND
                                                TO_DATE(gih_intimationdate) BETWEEN '01-jan-2000' AND '31-dec-2018'
                                        GROUP BY
                                            gih_doc_ref_no
                                    ) hd ON (
                                            hd.gih_doc_ref_no = ih.gih_doc_ref_no
                                        AND
                                            entryno = ih.gih_inti_entryno
                                    )
                                    LEFT OUTER JOIN pr_gc_oc_loss_cause oc ON (
                                            ih.pdp_dept_code = oc.pdp_dept_code
                                        AND
                                            ih.poc_losscode = oc.poc_losscode
                                    )
                                    LEFT OUTER JOIN pr_gn_ps_party ins ON (
                                            ih.por_org_code = ins.por_org_code
                                        AND
                                            ih.pps_party_code = ins.pps_party_code
                                    )
                                    INNER JOIN pr_gn_dp_department dp ON (
                                            ih.plc_loc_code = dp.plc_loc_code
                                        AND
                                            ih.pdp_dept_code = dp.pdp_dept_code
                                    )
                                    LEFT OUTER JOIN gi_gc_ud_surveyordtl svd ON (
                                            ih.por_org_code = svd.por_org_code
                                        AND
                                            ih.plc_loc_code = svd.plc_loc_code
                                        AND
                                            ih.pdp_dept_code = svd.pdp_dept_code
                                        AND
                                            ih.pdt_doctype = svd.pdt_doctype
                                        AND
                                            ih.gih_documentno = svd.gih_documentno
                                        AND
                                            ih.gih_inti_entryno = svd.gih_inti_entryno
                                        AND
                                            ih.gih_year = svd.gih_year
                                        AND
                                            svd.gud_serialno = 1
                                    )
                                    LEFT OUTER JOIN pr_gg_sr_surveyor sv ON (
                                        svd.psr_surv_code = sv.psr_surv_code
                                    )
                                    INNER JOIN pr_gn_lc_location lc ON (
                                            ih.por_org_code = lc.por_org_code
                                        AND
                                            ih.plc_loc_code = lc.plc_loc_code
                                    )
                                    INNER JOIN pr_gg_iy_insurancetype piy ON (
                                        ih.piy_insutype = piy.piy_insutype
                                    )
                                    LEFT OUTER JOIN gi_gr_vc_voyage_card vc ON (
                                            vc.gvc_policyno = id.gid_basedocumentno
                                        AND
                                            vc.gvc_voyagecard_no = id.gvc_voyagecard_no
                                        AND
                                            vc.gvc_itemno = id.gid_itemnos
                                    )
                                    INNER JOIN gi_gu_dh_doc_header dh ON (
                                            id.gid_basedocumentno = dh.gdh_doc_reference_no
                                        AND
                                            dh.gdh_record_type = 'O'
                                    )
                                    LEFT OUTER JOIN (
                                        SELECT
                                            bd.por_org_code,
                                            bd.plc_loc_code,
                                            bd.pdp_dept_code,
                                            bd.pbc_busiclass_code,
                                            bd.piy_insutype,
                                            bd.pdt_doctype,
                                            bd.gdh_documentno,
                                            bd.gdh_record_type,
                                            bd.gdh_year,
                                            bn.pbn_bnk_desc,
                                            bd.pbn_bnk_code
                                        FROM
                                            gi_gu_bd_bankdtl bd
                                            INNER JOIN pr_gn_bn_bank bn ON (
                                                    bd.por_org_code = bn.por_org_code
                                                AND
                                                    bd.pbn_bnk_code = bn.pbn_bnk_code
                                            )

--where BD.PBN_BNK_CODE=case {?BNKFROM} when 'All' then 'All' else {?BNKFROM} end
                                    ) bnk ON (
                                            dh.por_org_code = bnk.por_org_code
                                        AND
                                            dh.plc_loc_code = bnk.plc_loc_code
                                        AND
                                            dh.pdp_dept_code = bnk.pdp_dept_code
                                        AND
                                            dh.pbc_busiclass_code = bnk.pbc_busiclass_code
                                        AND
                                            dh.piy_insutype = bnk.piy_insutype
                                        AND
                                            dh.pdt_doctype = bnk.pdt_doctype
                                        AND
                                            dh.gdh_documentno = bnk.gdh_documentno
                                        AND
                                            dh.gdh_record_type = bnk.gdh_record_type
                                        AND
                                            dh.gdh_year = bnk.gdh_year
                                    )
                                    LEFT OUTER JOIN (
                                        SELECT
                                            pd1.por_org_code,
                                            pd1.plc_loc_code,
                                            pd1.pdp_dept_code,
                                            pd1.pdt_doctype,
                                            pd1.gih_documentno,
                                            pd1.gih_year,
                                            pd1.gsd_serialno,
                                            SUM(losspay) AS losspay,
                                            SUM(suryorpay) AS suryorpay,
                                            SUM(advocatepay) AS advocatepay,
                                            SUM(salvage) AS salvage
                                        FROM
                                            (
                                                SELECT
                                                    shd.por_org_code,
                                                    shd.plc_loc_code,
                                                    shd.pdp_dept_code,
                                                    shd.pdt_doctype,
                                                    shd.gih_documentno,
                                                    shd.gih_inti_entryno,
                                                    shd.gih_year,
                                                    shd.gsh_entryno,
                                                    sdtl.gsd_serialno,
                                                        CASE pyy_code
                                                            WHEN '01'   THEN ( coalesce(
                                                                gsd_losspaid,
                                                                0
                                                            ) )
                                                            ELSE 0
                                                        END
                                                    AS losspay,
                                                        CASE pyy_code
                                                            WHEN '02'   THEN ( coalesce(
                                                                gsd_losspaid,
                                                                0
                                                            ) )
                                                            ELSE 0
                                                        END
                                                    AS suryorpay,
                                                        CASE pyy_code
                                                            WHEN '03'   THEN ( coalesce(
                                                                gsd_losspaid,
                                                                0
                                                            ) )
                                                            ELSE 0
                                                        END
                                                    AS advocatepay,
                                                        CASE pyy_code
                                                            WHEN '04'   THEN ( coalesce(
                                                                gsd_losspaid,
                                                                0
                                                            ) )
                                                            ELSE 0
                                                        END
                                                    AS salvage,
                                                    coalesce(
                                                        gsd_conetamount,
                                                        0
                                                    ) net,
                                                    coalesce(
                                                        gsd_treatyamount,
                                                        0
                                                    ) treaty,
                                                    coalesce(
                                                        gsd_facultamount,
                                                        0
                                                    ) fac,
                                                    coalesce(
                                                        gsd_excessamount,
                                                        0
                                                    ) excess,
                                                    coalesce(
                                                        gsd_losspaid,
                                                        0
                                                    ) paid
                                                FROM
                                                    gi_gc_sh_settelmenthd shd
                                                    INNER JOIN gi_gc_sd_settelmentdtl sdtl ON (
                                                            sdtl.por_org_code = shd.por_org_code
                                                        AND
                                                            sdtl.plc_loc_code = shd.plc_loc_code
                                                        AND
                                                            sdtl.pdp_dept_code = shd.pdp_dept_code
                                                        AND
                                                            sdtl.pdt_doctype = shd.pdt_doctype
                                                        AND
                                                            sdtl.gih_documentno = shd.gih_documentno
                                                        AND
                                                            sdtl.gih_inti_entryno = shd.gih_inti_entryno
                                                        AND
                                                            sdtl.gih_year = shd.gih_year
                                                        AND
                                                            sdtl.gsh_entryno = shd.gsh_entryno
                                                    )
                                                WHERE
                                                        TO_DATE(shd.gsh_settlementdate) BETWEEN TO_DATE(shd.gsh_settlementdate) AND '31-dec-2018'
                                                    AND
                                                        coalesce(
                                                            shd.gsh_postingtag,
                                                            'N'
                                                        ) = 'Y'
                                            ) pd1
                                        GROUP BY
                                            pd1.por_org_code,
                                            pd1.plc_loc_code,
                                            pd1.pdp_dept_code,
                                            pd1.pdt_doctype,
                                            pd1.gih_documentno,
                                            pd1.gih_year,
                                            pd1.gsd_serialno
                                    ) pd ON (
                                            pd.por_org_code = ih.por_org_code
                                        AND
                                            pd.plc_loc_code = ih.plc_loc_code
                                        AND
                                            pd.pdp_dept_code = ih.pdp_dept_code
                                        AND
                                            pd.pdt_doctype = ih.pdt_doctype
                                        AND
                                            pd.gih_documentno = ih.gih_documentno
                                        AND
                                            pd.gih_year = ih.gih_year
                                        AND
                                            pd.gsd_serialno = id.gid_ply_serialno
                                    )
                                WHERE     

--    IH.PLC_LOC_CODE between  {?BRANCHFROM} and {?BRANCHTO}

--and coalesce(bnk.PBN_BNK_CODE,'000000')=case {?BNKFROM} when 'All' then coalesce(bnk.PBN_BNK_CODE,'000000') else {?BNKFROM} end and

--    IH.PDP_DEPT_CODE = {?DEPARTMENT}     AND    {?SLINE}={?SLINE} AND

--    IH.PPS_PARTY_CODE between case {?CLIENTFROM} when 'All' then ih.pps_party_code else {?CLIENTFROM} end and case {?CLIENTTO} when 'All' then ih.pps_party_code else {?CLIENTTO}  end 

--AND IH.PBC_BUSICLASS_CODE BETWEEN {?BUSFROM}  AND {?BUSTO}

--AND IH.POC_LOSSCODE   BETWEEN {?CAUSEFROM} AND {?CAUSETO}

--and

--CASE {?INSFROM} WHEN 'All' then 1 else  CHARINDEX (iH.PIY_INSUTYPE,{?INSFROM}) end >0

--AND

 --CASE iH.PDP_DEPT_CODE WHEN '12' THEN '01-jan-2000'  ELSE TO_DATE(dh.GDH_COMMDATE)   END between '01-jan-2000' AND '31-dec-2018'

 

--AND {?SUMMARY}={?SUMMARY} and ih.gih_doc_ref_no between {?CLAIMNOFROM} AND {?CLAIMNOTO}

--and
                                        coalesce(
                                            ih.gih_cancellationtag,
                                            'N'
                                        ) =
                                            CASE 'N'
                                                WHEN 'Y'   THEN 'Y'
                                                WHEN 'N'   THEN 'N'
                                                ELSE coalesce(
                                                    ih.gih_cancellationtag,
                                                    'N'
                                                )
                                            END 

--AND COALESCE(IH.GIH_POSTINGTAG,'N')=CASE WHEN {?POSTED} ='Y' THEN 'Y' WHEN {?POSTED}='N' THEN 'N' ELSE COALESCE(IH.GIH_POSTINGTAG,'N') END

--AND COALESCE(svd.psr_surv_code,'0000') BETWEEN CASE {?SURVEYORFROM} WHEN 'All' THEN COALESCE(svd.psr_surv_code,'0000') ELSE {?SURVEYORFROM} END AND CASE {?SURYEYORTO} WHEN 'All' THEN COALESCE(svd.psr_surv_code,'0000') ELSE {?SURYEYORTO} END

--AND {?AMOUNTFROM}={?AMOUNTFROM} AND {?AMOUNTTO}={?AMOUNTTO}
                                    AND NOT
                                        EXISTS (
                                            SELECT
                                                'x'
                                            FROM
                                                gi_gc_ih_intimationhd
                                            WHERE
                                                    gih_doc_ref_no = ih.gih_doc_ref_no
                                                AND
                                                    coalesce(
                                                        old_party_code,
                                                        'N'
                                                    ) = 'net off pb cases'
                                                AND
                                                    TO_DATE(netoff_date) < '31-dec-2018'
                                        )
                                GROUP BY
                                    ih.plc_loc_code,
                                    lc.plc_desc,
                                    dp.pdp_desc,
                                    ih.gih_intimationdate,
                                    ih.gih_revisiondate,
                                    piy.piy_desc,
                                    ih.pdp_dept_code,
                                    ih.por_org_code,
                                    ih.gih_inti_entryno,
                                    ih.gih_doc_ref_no,
                                    ih.gih_oldclaim_no,
                                    ih.gih_noclaim_tag,
                                    id.gid_basedocumentno,
                                    ih.gih_dateofloss,
                                    oc.poc_lossdesc,
                                    isubdtl.gis_registration_no,
                                    isubdtl.gis_engine_no,
                                    isubdtl.gis_sailing_date,
                                    coi.pps_desc,
                                    isubdtl.gis_chassis_no,
                                    bnk.pbn_bnk_desc,
                                    id.gid_commdate,
                                    id.gid_expirydate,
                                    ins.pps_desc,
                                    suryorpay,
                                    advocatepay,
                                    salvage,
                                    losspay,
                                    ih.gih_documentno,
                                    ih.gih_year,
                                    ih.gih_remarks,
                                    ih.gih_placeoftheft,
                                    coalesce(
                                        ic.gic_share,
                                        100
                                    ),
                                    sv.psr_surv_name
                                )
                            ) h
                        ORDER BY
                            h.plc_loc_code,
                            h.pdp_dept_code,
                            substring(
                                h.intimationno,
                                1,
                                4
                            ),
                            substring(
                                h.intimationno,
                                len(h.intimationno) - 7,
                                8
                            )
                    )
                WHERE
                    ( totalloss * gic_share / 100 ) - ( totalpaid * gic_share / 100 ) <> 0

--group by PPS_PARTY_CODE,INSURED,BR_CODE,BR_DESC,PDP_CODE,PDP_DESC

--ORDER BY (TOTALLOSS*GIC_SHARE/100)-(TOTALPAID*GIC_SHARE/100)
            )
        GROUP BY

PPS_PARTY_CODE,
            insured,
            br_code,
            br_desc,
            pdp_code,
            pdp_desc
    )
GROUP BY
PPS_PARTY_CODE
--    br_desc
ORDER BY PPS_PARTY_CODE;--br_desc;

-----------------------------------------------------------------------------------


----------Premium Receivable


select plc_desc,client,sum(os) from (

--client

SELECT DISTINCT

--(SELECT DISTINCT por_desc

--                            FROM pr_gn_or_organization

--                           WHERE por_org_code = '001001') AS cmpname,

--                (SELECT DISTINCT pdp_desc

--                            FROM pr_gn_dp_department

--                           WHERE pdp_dept_code ={?DEPARTMENTFROM}) AS dpfrom,

--                (SELECT DISTINCT pdp_desc

--                            FROM pr_gn_dp_department

--                           WHERE pdp_dept_code ={?DEPARTMENTTO}) AS dpto,

--                (SELECT DISTINCT plc_locadesc

--                            FROM pr_gn_lc_location

--                           WHERE plc_loc_code ={?BRANCHFROM}) AS brfrom,

--                (SELECT DISTINCT plc_locadesc

--                            FROM pr_gn_lc_location

--                           WHERE plc_loc_code ={?BRANCHTO}) AS brto,

--                (SELECT DISTINCT pdo_devoffdesc

--                            FROM pr_gg_do_devofficer

--                           WHERE pdo_devoffcode ={?DOFROM}) do1,

--                (SELECT DISTINCT pdo_devoffdesc

--                            FROM pr_gg_do_devofficer

--                           WHERE pdo_devoffcode ={?DOTO}) do2,

--                {?REPORTTYPE} as REPORTTYPE ,

                outstanding.seq AS seq,outstanding.gcd_share,

--                substring(outstanding.client_code,1,CASE '10' WHEN '0' THEN '20' ELSE '10' END)  AS client_code

outstanding.pdt_doctype,

                outstanding.client AS client,

                outstanding.plc_loc_code AS plc_loc_code,

                outstanding.plc_desc AS plc_desc,

                outstanding.pdp_dept_code AS pdp_dept_code,

                outstanding.pdp_desc AS pdp_desc,

                outstanding.gdh_individual_client AS gdh_individual_client,

                outstanding.docrefno AS docrefno,

                outstanding.docref AS docref,

                outstanding.agent_code AS agent_code,

                outstanding.basedocumentno AS basedocumentno,

                outstanding.gdh_as400_documentno AS gdh_as400_documentno,

                outstanding.folio_code AS folio_code,

                outstanding.posttag AS posttag,

                outstanding.commdate AS commdate,

                outstanding.issuedate AS issuedate,

                outstanding.expdate AS expdate,

                COALESCE (outstanding.np1, 0) AS np1,

                COALESCE (outstanding.np, 0) AS np,

                COALESCE (outstanding.gp_our, 0) AS gp_our,

                COALESCE (outstanding.gp100, 0) AS gp100,

                outstanding.ggd_leaderreference AS ggd_leaderreference,

                outstanding.AGENT AS AGENT, outstanding.folio AS folio,

                outstanding.pdo_devoffcode AS pdo_devoffcode,

                outstanding.pdo_devoffdesc AS pdo_devoffdesc,

                COALESCE (outstanding.knockoff, 0) AS knockoff,

                COALESCE (outstanding.opening, 0) AS opening,

                COALESCE (outstanding.advances, 0) AS advances,

                COALESCE (outstanding.np1, 0)-COALESCE (outstanding.knockoff, 0) AS OS

           FROM (SELECT   1 AS seq, 1 gcd_share, op.pps_party_code AS client_code,'A1' pdt_doctype,

                          op.pps_desc AS client, op.loc AS plc_loc_code,

                          br.plc_desc AS plc_desc, NULL AS pdp_dept_code,

                          NULL AS pdp_desc, NULL AS docrefno, NULL AS docref,

                          NULL AS agent_code, NULL AS basedocumentno,

                          NULL AS gdh_as400_documentno, NULL AS folio_code,

                          NULL AS gdh_individual_client, NULL AS posttag,

                          NULL AS commdate, NULL AS issuedate,

                          NULL AS expdate, 0 AS np1, 0 AS np, 0 AS gp_our,

                          0 AS gp100, NULL AS ggd_leaderreference,

                          NULL AS AGENT, NULL AS folio,

                          NULL AS pdo_devoffcode, NULL AS pdo_devoffdesc,

                          0 AS knockoff,

                          SUM (COALESCE (op.open_bal, 0)) AS opening,

                          0 AS advances

 

 

                     FROM

(

SELECT q.pps_party_code, q.pps_desc, q.vchddate vchddate,

          (COALESCE (q.a1, 0) - COALESCE (q.b1, 0)) open_bal, q.org, q.loc

     FROM (SELECT   a.org, a.loc, a.pps_party_code, a.pps_desc, a.vchddate,

                    SUM (CASE a.pad_advtcode

                            WHEN 'ORBA'

                               THEN COALESCE (a.bal, 0)

                            ELSE 0

                         END

                        ) a1,

                    SUM (CASE a.pad_advtcode

                            WHEN 'OPBA'

                               THEN COALESCE (a.bal, 0)

                            ELSE 0

                         END

                        ) b1

               FROM (

              

            SELECT sb.por_orgacode org, sb.plc_locacode loc,

                            sl.psa_sactaccount pps_party_code, pp.pps_desc,

                            sb.lpm_rmstdate vchddate, sl.pad_advtcode,

                              COALESCE (sl.lsl_sldramtbc, 0) --,COALESCE (sl.lsl_sldrknockoffamtbc, 0),

                             - COALESCE ( (

                              select ABS(SUM(COALESCE(VD.LVD_VCDTCRAMTBC,0) - COALESCE(VD.LVD_VCDTDRAMTBC,0) )) from ac_gl_vd_vchdetail vd,ac_gl_vh_voucher v

                              where vd.POR_ORGACODE=v.POR_ORGACODE and

                                    vd.PLC_LOCACODE=v.PLC_LOCACODE and

                                    vd.PVT_VCHTTYPE= v.PVT_VCHTTYPE and

                                    vd.PFS_ACNTYEAR = v.PFS_ACNTYEAR and

                                    vd.LVH_VCHDNO = v.LVH_VCHDNO AND

                                    COALESCE(V.LVH_VCHDSTATUS,'N') <>'C' AND

                                    V.LVH_VCHDDATE <='15-MAY-2019' AND

                                    VD.PLC_LOCACODE=SL.PLC_LOCACODE AND  

                                    VD.LVD_VCDTNARRATION1=SL.PFS_ACNTYEAR||'-'||SL.PAD_ADVTCODE||'-'||SL.LPM_RMSTNO||'-'||SL.LPD_RDTLSRNO ||'-'||SL.LSL_SLDRNO

                                   

                              ),0) BAL

 

             FROM ac_gl_sl_subledger sl INNER JOIN pr_gn_ps_party pp

                            ON (pp.pps_party_code = sl.psa_sactaccount)

                            INNER JOIN ac_gl_pm_rcppymmaster sb

                            ON (    sb.por_orgacode = sl.por_orgacode

                                AND sb.plc_locacode = sl.plc_locacode

                                AND sb.pad_advtcode = sl.pad_advtcode

                                AND sb.pfs_acntyear = sl.pfs_acntyear

                                AND sb.lpm_rmstno = sl.lpm_rmstno

                               )

                      WHERE sl.pad_advtcode IN ('ORBA', 'OPBA')

                      AND COALESCE(SB.LPM_RMSTSTATUS,'N')<>'C' )a

                     

                      group by a.org, a.loc, a.pps_party_code, a.pps_desc, a.vchddate

                    

                      )q

)

 

 

op INNER JOIN pr_gn_lc_location br

                          ON (    op.org = br.por_orgacode

                              AND op.loc = br.plc_locacode

                             )

                          INNER JOIN pr_gn_ps_party p

                          ON (p.pps_party_code = substring(op.pps_party_code,1,CASE '10' WHEN '0' THEN '20' ELSE '10' END))

                    WHERE op.vchddate < = '15-MAY-2019'

                      AND p.pps_nature = 'C'

--                      AND op.loc BETWEEN {?BRANCHFROM} AND {?BRANCHTO}

--                      AND 'Y' = {?WithOpBalance}

--                     AND substring(P.pps_party_code,1,CASE '10' WHEN '0' THEN '20' ELSE '10' END) BETWEEN

--case {?CLIENTFROM} when 'All' then substring(P.pps_party_code,1,CASE '10' WHEN '0' THEN '20' ELSE '10' END)  else {?CLIENTFROM} end AND

--case {?CLIENTTO} when 'All' then substring(P.pps_party_code,1,CASE '10' WHEN '0' THEN '20' ELSE '10' END)  else {?CLIENTTO} end

--and {?PARA_HIDE}={?PARA_HIDE}

               

GROUP BY op.pps_party_code, op.pps_desc, op.loc, br.plc_desc

                   HAVING SUM (COALESCE (op.open_bal, 0)) <> 0

                 UNION

                 SELECT 2 AS seq,

CASE own_share_tag

                           WHEN 'Y'

                              THEN 100

                           ELSE coalesce(cd.gcd_share,100) end gcd_share,

CASE WHEN own_share_tag = 'Y'  AND  h.piy_insutype='I' THEN COALESCE(H.CLIENT_CODE,'N') ELSE  COALESCE(H.FOLIO_CODE,'N') end AS client_code,

h.pdt_doctype,

                        pt.pps_desc client, h.plc_loc_code AS plc_loc_code,

                        lc.plc_desc AS plc_desc,

                        h.pdp_dept_code AS pdp_dept_code,

                        dp.pdp_desc AS pdp_desc, h.docrefno AS docrefno,

                        cl.docref AS docref, h.agent_code AS agent_code,

                        h.basedocumentno AS basedocumentno,

                        h.gdh_as400_documentno AS gdh_as400_documentno,

                        h.folio_code AS folio_code,

                        h.gdh_individual_client AS gdh_individual_client,

                       h.posttag AS posttag, h.commdate AS commdate,

                        h.issuedate AS issuedate, h.expdate AS expdate,

                        CASE own_share_tag

                           WHEN 'Y'

                              THEN COALESCE (h.netprem, 0)

                           ELSE h.np100

                        END AS np1,

                        COALESCE (h.netprem, 0) AS np, h.grossprem AS gp_our,

                        CASE own_share_tag

                           WHEN 'Y'

                              THEN COALESCE (h.grossprem, 0)

                           ELSE h.gp100

                        END AS gp100,

                        h.ggd_leaderreference AS ggd_leaderreference,

                        agt.pps_desc AS AGENT, pft.pps_desc AS folio,

                        COALESCE (h.pdo_devoffcode, '12XX') pdo_devoffcode,

                        COALESCE (DO.pdo_devoffdesc, 'All') AS pdo_devoffdesc,

                        COALESCE (cl.koff, 0) AS knockoff, 0 AS opening,

                        0 AS advances

                   FROM premium_view h

                        LEFT OUTER JOIN

                        (SELECT   docref, policy_no,

                                  COALESCE (SUM (knockoffamount), 0) koff

                             FROM collection_table

                            WHERE vchdate <=

                                         '15-MAY-2019'

--                              AND ppf_prfccode BETWEEN CASE len (ppf_prfccode)

--                                                  WHEN 2

--                                                     THEN {?DEPARTMENTFROM}

--                                                  ELSE ppf_prfccode

--                                               END

--                                                   AND CASE len (ppf_prfccode)

--                                                  WHEN 2

--                                                     THEN {?DEPARTMENTTO}

--                                                  ELSE ppf_prfccode

--                                               END

--                              AND plc_locacode BETWEEN {?BRANCHFROM} AND {?BRANCHTO}

                         GROUP BY docref, policy_no) cl

                        ON (    h.docrefno = cl.docref

                            AND (CASE h.pdt_doctype

                                    WHEN 'E'

                                       THEN h.basedocumentno

                                    ELSE 'n'

                                 END

                                ) =

                                   (CASE h.pdt_doctype

                                       WHEN 'E'

                                          THEN cl.policy_no

                                       ELSE 'n'

                                    END

                                   )

                           )

                        LEFT OUTER JOIN pr_gg_do_devofficer DO

                        ON (    h.pdo_devoffcode = DO.pdo_devoffcode

                         

                           )

                        INNER JOIN pr_gn_dp_department dp

                        ON (    h.plc_loc_code = dp.plc_loc_code

                            AND h.pdp_dept_code = dp.pdp_dept_code

                           ) LEFT OUTER JOIN GI_GU_DH_DOC_HEADER EH

ON (

H.BASEDOCUMENTNO=EH.GDH_DOC_REFERENCE_NO

AND H.GDH_RECORD_TYPE=EH.GDH_RECORD_TYPE

)

                        INNER JOIN pr_gn_lc_location lc

                        ON (h.plc_loc_code = lc.plc_loc_code)

                        LEFT OUTER JOIN pr_gn_ps_party agt

                        ON (h.agent_code = agt.pps_party_code)

                        left outer JOIN pr_gn_ps_party pt

                        ON (CASE own_share_tag  WHEN 'Y'  THEN COALESCE(H.CLIENT_CODE,'N') ELSE  COALESCE(H.FOLIO_CODE,'N') end  = pt.pps_party_code)

                        LEFT OUTER JOIN pr_gn_ps_party pft

                        ON (h.folio_code = pft.pps_party_code)

left outer join PR_GG_BC_BUSINESS_CLASS bc on

                        (h.PBC_BUSICLASS_CODE=bc.PBC_BUSICLASS_CODE  )

left outer join

GI_GU_CD_COINSURERDTL CD  on (

H.POR_ORG_CODE      = CD.POR_ORG_CODE         AND

H.PLC_LOC_CODE      = CD.PLC_LOC_cODE         AND

H.PDP_DEPT_CODE     = CD.PDP_DEPT_cODE        AND 

H.PBC_BUSICLASS_CODE = CD.PBC_BUSICLASS_CODE  AND

H.PIY_INSUTYPE      = CD.PIY_INSUTYPE         AND

H.PDT_DOCTYPE       = CD.PDT_DOCTYPE          AND 

H.GDH_DOCUMENTNO    = CD.GDH_DOCUMENTNO       AND

H.GDH_RECORD_TYPE   = CD.GDH_RECORD_TYPE      AND

H.GDH_YEAR          = CD.GDH_YEAR       AND  CD.GCD_LEADERTAG    = 'Y')

 

                  WHERE COALESCE (h.gdh_oldmaster_ref_no, 'N') <>

                                                            'net off pb cases'

                    AND h.por_org_code = '001001' 

--                    AND h.plc_loc_code BETWEEN  {?BRANCHFROM} AND {?BRANCHTO}

--                    AND h.pdp_dept_code BETWEEN {?DEPARTMENTFROM} AND {?DEPARTMENTTO}

--                    AND h.piy_insutype BETWEEN {?INSUTYPEFROM} AND {?INSUTYPETO}

                     AND h.issuedate BETWEEN '01-JAN-2000'  AND '15-MAY-2019'

AND case PBC_OPENPOLICY_FINANCIALIMPACT when 'Y' THEN 'P' ELSE CASE H.PDT_DOCTYPE WHEN 'E' THEN EH.PDT_DOCTYPE ELSE  H.PDT_DOCTYPE  END END <>'O'

AND CASE own_share_tag WHEN 'Y' THEN 'D' ELSE h.piy_insutype END NOT IN ('I', 'A')

 

--                    AND COALESCE (h.pdo_devoffcode, '12XX')

--                           BETWEEN CASE 'All'

--                           WHEN {?DOFROM}

--                              THEN COALESCE (h.pdo_devoffcode, '12XX')

--                           ELSE 'All'

--                        END

--                               AND CASE 'All'

--                           WHEN {?DOTO}

--                              THEN COALESCE (h.pdo_devoffcode, '12XX')

--                           ELSE 'All'

--                        END

 

 

                     --AND COALESCE(H.POSTTAG,'N')=CASE {?POSTED} WHEN 'Y' THEN 'Y' WHEN 'N' THEN 'N' ELSE COALESCE(H.POSTTAG,'N') END 

 

   

-- and CASE WHEN own_share_tag = 'Y'  AND  h.piy_insutype='I'   THEN COALESCE(H.CLIENT_CODE,'N') ELSE  COALESCE(H.FOLIO_CODE,'N') end

 --between

--case {?CLIENTFROM} when 'All' then CASE WHEN own_share_tag = 'Y'  AND  h.piy_insutype='I'  THEN COALESCE(H.CLIENT_CODE,'N') ELSE  COALESCE(H.FOLIO_CODE,'N') end  else {?CLIENTFROM} end and

--case {?CLIENTTO} when 'All' then CASE WHEN own_share_tag = 'Y'  AND  h.piy_insutype='I'  THEN COALESCE(H.CLIENT_CODE,'N') ELSE  COALESCE(H.FOLIO_CODE,'N') end  else {?CLIENTTO} end

--and {?SLINE}={?SLINE}

and  (CASE own_share_tag WHEN 'Y' THEN COALESCE (h.netprem, 0) ELSE h.np100 END  -   COALESCE (cl.koff, 0) )  <>  0

 

UNION

      

select

 

 

 

    adv.seq as seq ,1 gcd_share,

    adv.client_code as  client_code,adv.pdt_doctype,

    ins.pps_desc as client, 

    adv.plc_locacode as plc_locacode ,

    br.plc_desc as  plc_desc     ,

    NULL AS pdp_dept_code,

                          NULL AS pdp_desc, NULL AS docrefno, NULL AS docref,

                          NULL AS agent_code, NULL AS basedocumentno,

                          NULL AS gdh_as400_documentno, NULL AS folio_code,

                          NULL AS gdh_individual_client, NULL AS posttag,

                          NULL AS commdate, NULL AS issuedate,

                          NULL AS expdate, 0 AS np1, 0 AS np, 0 AS gp_our,

                          0 AS gp100, NULL AS ggd_leaderreference,

                          NULL AS AGENT, NULL AS folio,

                          NULL AS pdo_devoffcode, NULL AS pdo_devoffdesc,

                          0 AS knockoff, 0 AS opening,

    sum(coalesce(adv.advances,0)) as advances

 

 

from

(

select

      3 AS seq,  

      submas.PSA_SACTACCOUNT as client_code, 'A1' pdt_doctype,

      submas.plc_locacode as plc_locacode,  

      coalesce(submas.lsm_smstbalcrbc,0) - coalesce(submas.lsm_smstbaldrbc,0) as advances 

      from AC_GL_SM_SUBMASTER submas

where

--       submas.plc_locacode between {?BRANCHFROM} and {?BRANCHTO}

--and substring(submas.PSA_SACTACCOUNT,1,CASE '10' WHEN '0' THEN '20' ELSE '10' END) BETWEEN

--case {?CLIENTFROM} when 'All' then substring(submas.PSA_SACTACCOUNT,1,CASE '10' WHEN '0' THEN '20' ELSE '10' END)  else {?CLIENTFROM} end AND

--case {?CLIENTTO} when 'All' then substring(submas.PSA_SACTACCOUNT,1,CASE '10' WHEN '0' THEN '20' ELSE '10' END)  else {?CLIENTTO} end

 

/*and   substring(submas.PFS_ACNTYEAR,1,4)  =  to_char(to_date( '15-MAY-2019' ,'DD/MM/YYYY'),'YYYY')  */

--AND

substring(submas.PFS_ACNTYEAR,1,4) =   '2019'  

and submas.pca_glaccode IN (SELECT m_code

                                                FROM gias_prm_mapping

                                               WHERE m_type = 55)

                        

and submas.ppd_perdno = 0  

    

union              

 

                 SELECT  

                        3 AS seq,

                        sd.psa_sactaccount as client_code,'A1' pdt_doctype,

                          sd.plc_locacode as plc_locacode ,  

                          

                          (  SUM (COALESCE (sd.lsb_sdtlcramtbc, 0))

                           - SUM (COALESCE (sd.lsb_sdtldramtbc, 0))

                          ) AS advances

                     FROM ac_gl_vh_voucher vh INNER JOIN ac_gl_vd_vchdetail vd

                          ON (    vh.por_orgacode = vd.por_orgacode

                              AND vh.plc_locacode = vd.plc_locacode

                              AND vh.pvt_vchttype = vd.pvt_vchttype

                              AND vh.pfs_acntyear = vd.pfs_acntyear

                              AND vh.lvh_vchdno = vd.lvh_vchdno

                           )

                          INNER JOIN ac_gl_sb_subdetail sd

                          ON (    vd.por_orgacode = sd.por_orgacode

                              AND vd.plc_locacode = sd.plc_locacode

                              AND vd.pvt_vchttype = sd.pvt_vchttype

                              AND vd.pfs_acntyear = sd.pfs_acntyear

                              AND vd.lvh_vchdno = sd.lvh_vchdno

                              AND vd.lvd_vcdtvouchsr = sd.lvd_vcdtvouchsr

                             )

                            

                             

                          INNER JOIN pr_gn_ps_party p

                          ON (substring(sd.psa_sactaccount,1,CASE '10' WHEN '0' THEN '20' ELSE '10' END) = p.pps_party_code)

                         

                    WHERE vh.lvh_vchdstatus IN ('P', 'V')

                      AND vh.lvh_vchddate <= '15-MAY-2019'

                      --and {?SUMMARY}={?SUMMARY}  AND {?REPORTTYPE}={?REPORTTYPE}

                      AND to_char(vh.lvh_vchddate,'YYYY') =   '2019'  

                      AND COALESCE (vh.lvh_vchdautomanual, 'M') IN ('A', 'M')

                      AND vd.pca_glaccode IN (SELECT m_code

                                                FROM gias_prm_mapping

                                               WHERE m_type = 55)

                      AND p.pps_nature = 'C'

                      

--                      AND sd.plc_locacode BETWEEN {?BRANCHFROM} AND {?BRANCHTO} 

--                     

--and substring(p.pps_party_code,1,CASE '10' WHEN '0' THEN '20' ELSE '10' END) BETWEEN

--case {?CLIENTFROM} when 'All' then substring(p.pps_party_code,1,CASE '10' WHEN '0' THEN '20' ELSE '10' END)  else {?CLIENTFROM} end AND

--case {?CLIENTTO} when 'All' then substring(p.pps_party_code,1,CASE '10' WHEN '0' THEN '20' ELSE '10' END)  else {?CLIENTTO} end

--

 

 

                 GROUP BY sd.psa_sactaccount,

                          p.pps_desc,

                          sd.plc_locacode

                          

                   HAVING (  SUM (COALESCE (sd.lsb_sdtlcramtbc, 0))

                           - SUM (COALESCE (sd.lsb_sdtldramtbc, 0))

                          ) <> 0

                          ) adv

                          

                          inner join pr_gn_ps_party ins on (

                          ins.pps_party_code = substring(adv.client_code,1,CASE '10' WHEN '0' THEN '20' ELSE '10' END)

                          and ins.pps_nature = 'C')

                          

                          inner join pr_gn_lc_location br on (

                              

                          br.plc_locacode = adv.plc_locacode   

                                                    

                                                    )

Group By

    adv.seq ,

    adv.client_code  ,adv.pdt_doctype,

    ins.pps_desc  ,

    adv.plc_locacode ,

    br.plc_desc     

    ) outstanding

Order By outstanding.seq

)

group by plc_desc,client;



-----------------------------------------------------------------------------------


---------Claim Paid Breakup (Motor)



--select PSP_STYPDESC,pd from (

select pdp_desc,PSP_STYPCODE,

--plc_desc,pps_Desc,

sum(paid)pd from(

select plc_Desc,pdp_desc,pps_Desc,PSP_STYPCODE,

case when TLOSS =0 THEN 0 ELSE ((((KNOCKOFF*LOSS)/TLOSS)*GIC_SHARE)/100) end as paid

from (

 

SELECT 

--(select distinct por_desc from pr_gn_or_organization where por_org_code='001001')cmpname,

--(select distinct plc_desc from pr_gn_lc_location where plc_loc_code={?BRFROM})br1,

--(select distinct plc_desc from pr_gn_lc_location where plc_loc_code={?BRTO})br2,

--(select distinct pdp_desc from pr_gn_dp_department where pdp_dept_code={?DEPFROM})dp1,

--(select distinct pdp_desc from pr_gn_dp_department where pdp_dept_code={?DEPTO})dp2,

--(SELECT distinct pps_desc from pr_gn_ps_party where pps_party_code={?CLIENTFROM})pps1,

--(SELECT distinct pps_desc from pr_gn_ps_party where pps_party_code={?CLIENTTO})pps2,

--PLC_LOCADESC,

PSP_STYPCODE,

case when (

(coalesce(SH.GSH_SURV_OURSHARE,'N')='Y' and b.PSP_STYPCODE='0007') or

(coalesce(SH.GSH_ADVOCATE_OURSHARE,'N')='Y' and b.PSP_STYPCODE='0008') or

(coalesce(SH.GSH_LOSS_OURSHARE,'N')='Y' and b.PSP_STYPCODE NOT IN ('0007','0008') )

) then 100 else

coalesce(ic.gic_share,100) end gic_share,

isubdtl.GIS_SAILING_DATE,coalesce(stx.payee_name,'N/A')payeename,coalesce(sv.psr_surv_name,'None')psr_surv_name,

B.VCHDATE,B.CLMREF,ih.gih_inti_entryno,COALESCE(B.KNOCKOFFAMOUNT,0)KNOCKOFF,B.PPF_PRFCCODE,B.PLC_LOCACODE,B.PVT_VCHTTYPE,B.LVH_VCHDNO,ih.GIH_OLDCLAIM_NO,piy.piy_desc,

IH.GIH_INTIMATIONDATE,idtl.gid_basedocumentno policyno,idtl.gid_commdate,idtl.gid_expirydate,idtl.gid_issuedate,

coalesce(isubDtl.GIS_REGISTRATION_NO,'N/A') regno,coalesce(isubdtl.GIS_ENGINE_NO,'N/A')engineno, coalesce(isubdtl.GIS_CHASSIS_NO,'N/A')chassis,

COALESCE(X.TLOSS,0) as TLoss  ,sv.psr_surv_name,

CASE coalesce(ISUBDTL.GIS_LOSSADJUSTED, 0)  WHEN 0 THEN      CASE coalesce(ISUBDTL.GIS_LOSSASSESSED, 0) 

              WHEN 0 THEN  CASE coalesce(ISUBDTL.GIS_LOSSCLAIMED, 0)  WHEN 0 THEN 0  ELSE coalesce(ISUBDTL.GIS_LOSSCLAIMED, 0)  END 

              ELSE coalesce (ISUBDTL.GIS_LOSSASSESSED, 0)  END 

ELSE coalesce(ISUBDTL.gIS_LOSSADJUSTED, 0) 

END * CASE  WHEN coalesce(IH.GIH_NOCLAIM_TAG,'V') = 'N' THEN 0 ELSE 1 END+

coalesce(ISUBDTL.gis_surveyoramt,0) +coalesce(ISUBDTL.gis_advocateamt,0)-coalesce(ISUBDTL.GIS_SALVAGEAMT,0) as Loss,

coalesce(isubdtl.gis_suminsured,0)gis_suminsured,

(coalesce(isubdtl.gis_lossclaimed,0)) gis_lossclaimed,

(coalesce(isubdtl.gis_lossassessed,0)) gis_lossassessed,

(coalesce(isubdtl.gis_lossadjusted,0)) gis_lossadjusted,

(coalesce(isubdtl.gis_surveyoramt,0)) gis_surveyoramt,

(coalesce(isubdtl.gis_advocateamt,0)) gis_advocateamt,

(coalesce(isubdtl.GIS_EXCESSAMOUNT,0)) GIS_EXCESSAMOUNT,

(coalesce(isubdtl.GIS_SALVAGEAMT,0)) GIS_SALVAGEAMT,

(coalesce(isubdtl.GIS_FACULTAMOUNT,0)) GIS_FACULTAMOUNT,

(coalesce(isubdtl.GIS_FOREIGNFACULT_AMOUNT,0)) GIS_FOREIGNFACULT_AMOUNT ,

(coalesce(isubdtl.GIS_CONETAMOUNT,0)) GIS_CONETAMOUNT,

(coalesce(isubdtl.GIS_TREATYAMOUNT,0)) GIS_TREATYAMOUNT ,

coalesce(h.gdh_as400_documentno,'X') old_documentno,

ih.gih_revisiondate,b.check_no,b.check_date,

IH.GIH_DATEOFLOSS,IH.PPS_PARTY_CODE,CL.POC_LOSSDESC,PP.PPS_DESC,DP.PDP_DESC,LC.PLC_DESC,b.sett_no

FROM  GI_GC_IH_INTIMATIONHD IH

inner join GI_GC_ID_INTIMATIONDTL IDTL

on

(

IH.POR_ORG_CODE         = IDTL.POR_ORG_CODE     AND

IH.PLC_LOC_CODE          = IDTL.PLC_LOC_CODE     AND

IH.PDP_DEPT_CODE        = IDTL.PDP_DEPT_CODE    AND

IH.PDT_DOCTYPE            = IDTL.PDT_DOCTYPE      AND

IH.GIH_DOCUMENTNO     = IDTL.GIH_DOCUMENTNO   AND    

IH.GIH_INTI_ENTRYNO    = IDTL.GIH_INTI_ENTRYNO AND

IH.GIH_YEAR                  = IDTL.GIH_YEAR

) INNER JOIN

PR_GG_IY_INSURANCETYPE PIY

ON

(

iH.PIY_INSUTYPE=PIY.PIY_INSUTYPE

)

left outer join

(

select por_org_code,plc_loc_code,pdp_dept_code,pdt_doctype,gih_documentno,gid_ply_serialno,

gih_inti_entryno,gih_year,GIS_SAILING_DATE,GIS_REGISTRATION_NO,GIS_ENGINE_NO,GIS_CHASSIS_NO,

sum(coalesce(gis_suminsured,0)) gis_suminsured,

sum(coalesce(gis_lossclaimed,0)) gis_lossclaimed,

sum(coalesce(gis_lossassessed,0)) gis_lossassessed,

sum(coalesce(gis_lossadjusted,0)) gis_lossadjusted,

sum(coalesce(gis_surveyoramt,0)) gis_surveyoramt,

sum(coalesce(gis_advocateamt,0)) gis_advocateamt,

sum(coalesce(GIS_EXCESSAMOUNT,0)) GIS_EXCESSAMOUNT,

sum(coalesce(GIS_SALVAGEAMT,0)) GIS_SALVAGEAMT,

sum(coalesce(GIS_FACULTAMOUNT,0)) GIS_FACULTAMOUNT,

sum(coalesce(GIS_FOREIGNFACULT_AMOUNT,0)) GIS_FOREIGNFACULT_AMOUNT ,

sum(coalesce(GIS_CONETAMOUNT,0)) GIS_CONETAMOUNT,

sum(coalesce(GIS_TREATYAMOUNT,0)) GIS_TREATYAMOUNT

 

from GI_GC_IS_INTIMATIONSUBDTL

group by 

por_org_code,plc_loc_code,pdp_dept_code,pdt_doctype,gih_documentno,gid_ply_serialno,gih_inti_entryno,gih_year,GIS_SAILING_DATE,GIS_REGISTRATION_NO,GIS_ENGINE_NO,GIS_CHASSIS_NO

)

ISUBDTL

on

( 

IDTL.POR_ORG_CODE         = ISUBDTL.POR_ORG_CODE     AND 

IDTL.PLC_LOC_CODE         = ISUBDTL.PLC_LOC_CODE     AND 

IDTL.PDP_DEPT_CODE        = ISUBDTL.PDP_DEPT_CODE    AND 

IDTL.PDT_DOCTYPE          = ISUBDTL.PDT_DOCTYPE         AND 

IDTL.GIH_DOCUMENTNO       = ISUBDTL.GIH_DOCUMENTNO   AND 

IDTL.GIH_INTI_ENTRYNO     = ISUBDTL.GIH_INTI_ENTRYNO AND 

IDTL.GIH_YEAR             = ISUBDTL.GIH_YEAR         AND 

IDTL.GID_PLY_SERIALNO     = ISUBDTL.GID_PLY_SERIALNO 

) left outer join

(select i.por_org_code,i.plc_loc_code,i.pdp_dept_code,i.pdt_doctype,i.gih_documentno,i.gih_inti_entryno,i.gih_year,

sum(CASE coalesce(ISUBDTL1.GIS_LOSSADJUSTED, 0)  WHEN 0 THEN      CASE coalesce(ISUBDTL1.GIS_LOSSASSESSED, 0) 

              WHEN 0 THEN  CASE coalesce(ISUBDTL1.GIS_LOSSCLAIMED, 0)  WHEN 0 THEN 0  ELSE coalesce(ISUBDTL1.GIS_LOSSCLAIMED, 0)  END 

              ELSE coalesce (ISUBDTL1.GIS_LOSSASSESSED, 0)  END 

ELSE coalesce(ISUBDTL1.gIS_LOSSADJUSTED, 0) 

END * CASE  WHEN coalesce(I.GIH_NOCLAIM_TAG,'V') = 'N' THEN 0 ELSE 1 END+

coalesce(ISUBDTL1.gis_surveyoramt,0) +coalesce(ISUBDTL1.gis_advocateamt,0)-coalesce(ISUBDTL1.GIS_SALVAGEAMT,0) ) as TLoss

from

GI_GC_IH_INTIMATIONHD i

left outer join

(

select por_org_code,plc_loc_code,pdp_dept_code,pdt_doctype,gih_documentno,gid_ply_serialno,

gih_inti_entryno,gih_year,

sum(coalesce(gis_lossclaimed,0)) gis_lossclaimed,sum(coalesce(gis_lossassessed,0)) gis_lossassessed,

sum(coalesce(gis_lossadjusted,0)) gis_lossadjusted,sum(coalesce(gis_surveyoramt,0)) gis_surveyoramt,

sum(coalesce(gis_advocateamt,0)) gis_advocateamt, sum(coalesce(GIS_SALVAGEAMT,0)) GIS_SALVAGEAMT

from GI_GC_IS_INTIMATIONSUBDTL

 

group by por_org_code,plc_loc_code,pdp_dept_code,pdt_doctype,gih_documentno,gid_ply_serialno,

gih_inti_entryno,gih_year

 

)ISUBDTL1 on  

I.POR_ORG_CODE         = ISUBDTL1.POR_ORG_CODE     AND 

I.PLC_LOC_CODE         = ISUBDTL1.PLC_LOC_CODE     AND 

I.PDP_DEPT_CODE        = ISUBDTL1.PDP_DEPT_CODE    AND 

I.PDT_DOCTYPE          = ISUBDTL1.PDT_DOCTYPE         AND 

I.GIH_DOCUMENTNO       = ISUBDTL1.GIH_DOCUMENTNO   AND 

I.GIH_INTI_ENTRYNO     = ISUBDTL1.GIH_INTI_ENTRYNO AND 

I.GIH_YEAR             = ISUBDTL1.GIH_YEAR  

group by

i.por_org_code,i.plc_loc_code,i.pdp_dept_code,i.pdt_doctype,i.gih_documentno,i.gih_inti_entryno,i.gih_year) X on

IH.POR_ORG_CODE         = X.POR_ORG_CODE     AND 

IH.PLC_LOC_CODE         = X.PLC_LOC_CODE     AND 

IH.PDP_DEPT_CODE        = X.PDP_DEPT_CODE    AND 

IH.PDT_DOCTYPE          = X.PDT_DOCTYPE         AND 

IH.GIH_DOCUMENTNO       = X.GIH_DOCUMENTNO   AND 

IH.GIH_INTI_ENTRYNO     = X.GIH_INTI_ENTRYNO AND 

IH.GIH_YEAR             = X.GIH_YEAR  

 

inner join gi_gu_dh_doc_header h on (idtl.gid_basedocumentno=h.gdh_doc_reference_no and h.gdh_record_type='O')

INNER JOIN CLAIM_PAID_TABLE B ON  (IH.GIH_DOC_REF_NO=B.CLMREF AND IH.GIH_INTI_ENTRYNO=B.INT_ENTRY_NO)

 

INNER JOIN GI_GC_SH_SETTELMENTHD SH ON (sh.gsh_doc_ref_no=b.clmref and sh.gih_inti_entryno=b.int_entry_no and sh.gsh_entryno=b.sett_no)

INNER JOIN PR_GN_PS_PARTY PP ON (IH.PPS_PARTY_CODE=PP.PPS_PARTY_CODE)

INNER JOIN PR_GN_DP_DEPARTMENT DP ON (IH.PDP_DEPT_CODE=DP.PDP_DEPT_CODE AND IH.PLC_LOC_CODE=DP.PLC_LOC_CODE)

INNER JOIN PR_GN_LC_LOCATION LC ON (IH.PLC_LOC_CODE=LC.PLC_LOC_CODE)

left outer JOIN  PR_GC_OC_LOSS_CAUSE CL ON ( IH.PDP_DEPT_CODE=CL.PDP_DEPT_CODE AND   IH.POC_LOSSCODE=CL.POC_LOSSCODE )

LEFT OUTER JOIN (SELECT PD.POR_ORG_CODE,PD.PLC_LOC_CODE ,PD.PDP_DEPT_CODE ,PD.PDT_DOCTYPE,  

PD.GIH_DOCUMENTNO ,PD.GIH_YEAR,PD.GSH_ENTRYNO,

Case WHEN PT.PYY_CODE in ('01001','01004') then '0002'

WHEN PT.PYY_CODE in ('02001') then '0007'

WHEN PT.PYY_CODE in ('04001','03001','03002','01006') then '0008'

WHEN PT.PYY_CODE in ('01002','04003') then '0009'

WHEN PT.PYY_CODE in ('01003','02002') then '0005'

WHEN PT.PYY_CODE in ('04001','04002','04003','04004','04005') then '0028'

else '0028' end payee_type,

MAX(Case WHEN PT.PYY_CODE in ('01001','01004') then i.pps_desc

WHEN PT.PYY_CODE in ('02001') then l.psr_surv_name

WHEN PT.PYY_CODE in ('04001','03001','03002','01006') then m.PAV_ADVOCATE_NAME

WHEN PT.PYY_CODE in ('01002','04003') then j.PWC_DESCRIPTION

WHEN PT.PYY_CODE in ('01003','02002') then i.pps_desc

WHEN PT.PYY_CODE in ('04001','04002','04003','04004','04005') then j.PWC_DESCRIPTION

else j.PWC_DESCRIPTION end) payee_name,

sum(PD.GPD_SALESTAX_AMOUNT)GSD_CO_SALESTAXAMOUNT,

sum(pd.gpd_payee_amount*(CASE WHEN PD.GPD_PAYMENT_TYPE='04' THEN -1 ELSE 1 END))GSD_LOSSPAID1

FROM GI_GC_PD_PAYMENT_DETAIL pd

INNER JOIN PR_GC_YY_PAYMENT_TYPE PT ON (

PT.PYY_CODE=PD.GPD_PAYEE_TYPE) 

left outer join PR_GN_PS_PARTY  i  on (i.PPS_PARTY_CODE = PD.GPD_PAYEE_CODE_DESC)

left outer join PR_GC_WS_WORKSHOP j on  (j.PWC_CODE = PD.GPD_PAYEE_CODE_DESC)

left outer join PR_GC_DL_DEALER k on  (k.PDL_CODE = PD.GPD_PAYEE_CODE_DESC)

left outer join PR_GG_SR_SURVEYOR l on  (l.PSR_SURV_CODE = PD.GPD_PAYEE_CODE_DESC)

left outer join PR_GC_AV_ADVOCATE m on  (m.PAV_ADVOCATE_CODE =PD.GPD_PAYEE_CODE_DESC)

group by PD.POR_ORG_CODE,PD.PLC_LOC_CODE ,PD.PDP_DEPT_CODE,PD.PDT_DOCTYPE,PD.GIH_DOCUMENTNO,

PD.GIH_YEAR,PD.GSH_ENTRYNO, Case WHEN PT.PYY_CODE in ('01001','01004') then '0002'

WHEN PT.PYY_CODE in ('02001') then '0007'

WHEN PT.PYY_CODE in ('04001','03001','03002','01006') then '0008'

WHEN PT.PYY_CODE in ('01002','04003') then '0009'

WHEN PT.PYY_CODE in ('01003','02002') then '0005'

WHEN PT.PYY_CODE in ('04001','04002','04003','04004','04005') then '0028'

else '0028' end


) STX ON (

SH.POR_ORG_CODE=STX.POR_ORG_CODE and

SH.PLC_LOC_CODE=STX.PLC_LOC_CODE and

SH.PDP_DEPT_CODE =STX.PDP_DEPT_CODE and

SH.PDT_DOCTYPE=STX.PDT_DOCTYPE and

SH.GIH_DOCUMENTNO=STX.GIH_DOCUMENTNO and

SH.GIH_YEAR=STX.GIH_YEAR and

SH.GSH_ENTRYNO=STX.GSH_ENTRYNO and

stx.payee_type=b.PSP_STYPCODE)

left outer join GI_GC_UD_SURVEYORDTL svd on (

IH.POR_ORG_CODE         = svd.POR_ORG_CODE     AND

IH.PLC_LOC_CODE          = svd.PLC_LOC_CODE     AND

IH.PDP_DEPT_CODE        = svd.PDP_DEPT_CODE    AND

IH.PDT_DOCTYPE            = svd.PDT_DOCTYPE      AND

IH.GIH_DOCUMENTNO     = svd.GIH_DOCUMENTNO   AND    

IH.GIH_INTI_ENTRYNO    = svd.GIH_INTI_ENTRYNO AND

IH.GIH_YEAR                  = svd.GIH_YEAR and gud_serialno=1)

left outer join PR_GG_SR_SURVEYOR sv on (

svd.psr_surv_code=sv.psr_surv_code)

left outer join GI_GC_IC_INTIMATION_COINSURER IC ON

(

IDTL.POR_ORG_CODE         = IC.POR_ORG_CODE     AND 

IDTL.PLC_LOC_CODE         = IC.PLC_LOC_CODE     AND 

IDTL.PDP_DEPT_CODE        = IC.PDP_DEPT_CODE    AND 

IDTL.PDT_DOCTYPE          = IC.PDT_DOCTYPE         AND 

IDTL.GIH_DOCUMENTNO       = IC.GIH_DOCUMENTNO   AND 

IDTL.GIH_INTI_ENTRYNO     = IC.GIH_INTI_ENTRYNO AND 

IDTL.GIH_YEAR             = IC.GIH_YEAR         AND 

IDTL.GID_BASEDOCUMENTNO = IC.GIC_BASEDOCUMENTNO  AND

IC.GIC_CORETAG='C' AND IC.GIC_LEADERTAG='Y' )

         

WHERE

--IH.PDP_DEPT_CODE BETWEEN  {?DEPFROM}   AND  {?DEPTO}    AND {?SLINE}={?SLINE}

--AND IH.PLC_LOC_CODE BETWEEN {?BRFROM} AND {?BRTO} AND

SH.GSH_SETTLEMENTDATE BETWEEN '01-jan-2000' AND '15-may-2019' AND

b.vchdate  BETWEEN '01-jan-2018' AND '31-dec-2018' AND

H.GDH_COMMDATE BETWEEN '01-jan-2000' AND '15-may-2019'

AND IH.gih_INTIMATIONDATE BETWEEN '01-jan-2000' AND '15-may-2019'

--and ih.pps_party_code between case {?CLIENTFROM} WHEN 'All' then ih.pps_party_code else {?CLIENTFROM} end and case {?CLIENTTO} when 'All' then ih.pps_party_code else {?CLIENTTO} end 

--and ih.PDP_DEPT_COD='13'

) pd1

)group by pdp_desc,PSP_STYPCODE

order by pdp_desc,PSP_STYPCODE

--left outer join PR_GL_SP_SLTYPE s on (psp_stypcode=s.psp_stypcode)

 

--,s.PSP_STYPDESC

 

--plc_Desc,pps_Desc

;

 -----------------------------------------------------------------------------------



-----------Claim Paid Query Branch & Client wise

select plc_desc,sum(paid) from(

select plc_Desc,pdp_desc,pps_Desc,

case when TLOSS =0 THEN 0 ELSE ((((KNOCKOFF*LOSS)/TLOSS)*GIC_SHARE)/100) end as paid

from (

SELECT 

--(select distinct por_desc from pr_gn_or_organization where por_org_code='001001')cmpname,

--(select distinct plc_desc from pr_gn_lc_location where plc_loc_code={?BRFROM})br1,

--(select distinct plc_desc from pr_gn_lc_location where plc_loc_code={?BRTO})br2,

--(select distinct pdp_desc from pr_gn_dp_department where pdp_dept_code={?DEPFROM})dp1,

--(select distinct pdp_desc from pr_gn_dp_department where pdp_dept_code={?DEPTO})dp2,

--(SELECT distinct pps_desc from pr_gn_ps_party where pps_party_code={?CLIENTFROM})pps1,

--(SELECT distinct pps_desc from pr_gn_ps_party where pps_party_code={?CLIENTTO})pps2,

--PLC_LOCADESC,

case when (

(coalesce(SH.GSH_SURV_OURSHARE,'N')='Y' and b.PSP_STYPCODE='0007') or

(coalesce(SH.GSH_ADVOCATE_OURSHARE,'N')='Y' and b.PSP_STYPCODE='0008') or

(coalesce(SH.GSH_LOSS_OURSHARE,'N')='Y' and b.PSP_STYPCODE NOT IN ('0007','0008') )

) then 100 else

coalesce(ic.gic_share,100) end gic_share,

isubdtl.GIS_SAILING_DATE,coalesce(stx.payee_name,'N/A')payeename,coalesce(sv.psr_surv_name,'None')psr_surv_name,

B.VCHDATE,B.CLMREF,ih.gih_inti_entryno,COALESCE(B.KNOCKOFFAMOUNT,0)KNOCKOFF,B.PPF_PRFCCODE,B.PLC_LOCACODE,B.PVT_VCHTTYPE,B.LVH_VCHDNO,ih.GIH_OLDCLAIM_NO,piy.piy_desc,

IH.GIH_INTIMATIONDATE,idtl.gid_basedocumentno policyno,idtl.gid_commdate,idtl.gid_expirydate,idtl.gid_issuedate,

coalesce(isubDtl.GIS_REGISTRATION_NO,'N/A') regno,coalesce(isubdtl.GIS_ENGINE_NO,'N/A')engineno, coalesce(isubdtl.GIS_CHASSIS_NO,'N/A')chassis,

COALESCE(X.TLOSS,0) as TLoss  ,sv.psr_surv_name,

CASE coalesce(ISUBDTL.GIS_LOSSADJUSTED, 0)  WHEN 0 THEN      CASE coalesce(ISUBDTL.GIS_LOSSASSESSED, 0) 

              WHEN 0 THEN  CASE coalesce(ISUBDTL.GIS_LOSSCLAIMED, 0)  WHEN 0 THEN 0  ELSE coalesce(ISUBDTL.GIS_LOSSCLAIMED, 0)  END 

              ELSE coalesce (ISUBDTL.GIS_LOSSASSESSED, 0)  END 

ELSE coalesce(ISUBDTL.gIS_LOSSADJUSTED, 0) 

END * CASE  WHEN coalesce(IH.GIH_NOCLAIM_TAG,'V') = 'N' THEN 0 ELSE 1 END+

coalesce(ISUBDTL.gis_surveyoramt,0) +coalesce(ISUBDTL.gis_advocateamt,0)-coalesce(ISUBDTL.GIS_SALVAGEAMT,0) as Loss,

coalesce(isubdtl.gis_suminsured,0)gis_suminsured,

(coalesce(isubdtl.gis_lossclaimed,0)) gis_lossclaimed,

(coalesce(isubdtl.gis_lossassessed,0)) gis_lossassessed,

(coalesce(isubdtl.gis_lossadjusted,0)) gis_lossadjusted,

(coalesce(isubdtl.gis_surveyoramt,0)) gis_surveyoramt,

(coalesce(isubdtl.gis_advocateamt,0)) gis_advocateamt,

(coalesce(isubdtl.GIS_EXCESSAMOUNT,0)) GIS_EXCESSAMOUNT,

(coalesce(isubdtl.GIS_SALVAGEAMT,0)) GIS_SALVAGEAMT,

(coalesce(isubdtl.GIS_FACULTAMOUNT,0)) GIS_FACULTAMOUNT,

(coalesce(isubdtl.GIS_FOREIGNFACULT_AMOUNT,0)) GIS_FOREIGNFACULT_AMOUNT ,

(coalesce(isubdtl.GIS_CONETAMOUNT,0)) GIS_CONETAMOUNT,

(coalesce(isubdtl.GIS_TREATYAMOUNT,0)) GIS_TREATYAMOUNT ,

coalesce(h.gdh_as400_documentno,'X') old_documentno,

ih.gih_revisiondate,b.check_no,b.check_date,

IH.GIH_DATEOFLOSS,IH.PPS_PARTY_CODE,CL.POC_LOSSDESC,PP.PPS_DESC,DP.PDP_DESC,LC.PLC_DESC,b.sett_no

FROM  GI_GC_IH_INTIMATIONHD IH

inner join GI_GC_ID_INTIMATIONDTL IDTL

on

(

IH.POR_ORG_CODE         = IDTL.POR_ORG_CODE     AND

IH.PLC_LOC_CODE          = IDTL.PLC_LOC_CODE     AND

IH.PDP_DEPT_CODE        = IDTL.PDP_DEPT_CODE    AND

IH.PDT_DOCTYPE            = IDTL.PDT_DOCTYPE      AND

IH.GIH_DOCUMENTNO     = IDTL.GIH_DOCUMENTNO   AND    

IH.GIH_INTI_ENTRYNO    = IDTL.GIH_INTI_ENTRYNO AND

IH.GIH_YEAR                  = IDTL.GIH_YEAR

) INNER JOIN

PR_GG_IY_INSURANCETYPE PIY

ON

(

iH.PIY_INSUTYPE=PIY.PIY_INSUTYPE

)

left outer join

(

select por_org_code,plc_loc_code,pdp_dept_code,pdt_doctype,gih_documentno,gid_ply_serialno,

gih_inti_entryno,gih_year,GIS_SAILING_DATE,GIS_REGISTRATION_NO,GIS_ENGINE_NO,GIS_CHASSIS_NO,

sum(coalesce(gis_suminsured,0)) gis_suminsured,

sum(coalesce(gis_lossclaimed,0)) gis_lossclaimed,

sum(coalesce(gis_lossassessed,0)) gis_lossassessed,

sum(coalesce(gis_lossadjusted,0)) gis_lossadjusted,

sum(coalesce(gis_surveyoramt,0)) gis_surveyoramt,

sum(coalesce(gis_advocateamt,0)) gis_advocateamt,

sum(coalesce(GIS_EXCESSAMOUNT,0)) GIS_EXCESSAMOUNT,

sum(coalesce(GIS_SALVAGEAMT,0)) GIS_SALVAGEAMT,

sum(coalesce(GIS_FACULTAMOUNT,0)) GIS_FACULTAMOUNT,

sum(coalesce(GIS_FOREIGNFACULT_AMOUNT,0)) GIS_FOREIGNFACULT_AMOUNT ,

sum(coalesce(GIS_CONETAMOUNT,0)) GIS_CONETAMOUNT,

sum(coalesce(GIS_TREATYAMOUNT,0)) GIS_TREATYAMOUNT

 

from GI_GC_IS_INTIMATIONSUBDTL

group by 

por_org_code,plc_loc_code,pdp_dept_code,pdt_doctype,gih_documentno,gid_ply_serialno,gih_inti_entryno,gih_year,GIS_SAILING_DATE,GIS_REGISTRATION_NO,GIS_ENGINE_NO,GIS_CHASSIS_NO

)

ISUBDTL

on

( 

IDTL.POR_ORG_CODE         = ISUBDTL.POR_ORG_CODE     AND 

IDTL.PLC_LOC_CODE         = ISUBDTL.PLC_LOC_CODE     AND 

IDTL.PDP_DEPT_CODE        = ISUBDTL.PDP_DEPT_CODE    AND 

IDTL.PDT_DOCTYPE          = ISUBDTL.PDT_DOCTYPE         AND 

IDTL.GIH_DOCUMENTNO       = ISUBDTL.GIH_DOCUMENTNO   AND 

IDTL.GIH_INTI_ENTRYNO     = ISUBDTL.GIH_INTI_ENTRYNO AND 

IDTL.GIH_YEAR             = ISUBDTL.GIH_YEAR         AND 

IDTL.GID_PLY_SERIALNO     = ISUBDTL.GID_PLY_SERIALNO 

) left outer join

(select i.por_org_code,i.plc_loc_code,i.pdp_dept_code,i.pdt_doctype,i.gih_documentno,i.gih_inti_entryno,i.gih_year,

sum(CASE coalesce(ISUBDTL1.GIS_LOSSADJUSTED, 0)  WHEN 0 THEN      CASE coalesce(ISUBDTL1.GIS_LOSSASSESSED, 0) 

              WHEN 0 THEN  CASE coalesce(ISUBDTL1.GIS_LOSSCLAIMED, 0)  WHEN 0 THEN 0  ELSE coalesce(ISUBDTL1.GIS_LOSSCLAIMED, 0)  END 

              ELSE coalesce (ISUBDTL1.GIS_LOSSASSESSED, 0)  END 

ELSE coalesce(ISUBDTL1.gIS_LOSSADJUSTED, 0) 

END * CASE  WHEN coalesce(I.GIH_NOCLAIM_TAG,'V') = 'N' THEN 0 ELSE 1 END+

coalesce(ISUBDTL1.gis_surveyoramt,0) +coalesce(ISUBDTL1.gis_advocateamt,0)-coalesce(ISUBDTL1.GIS_SALVAGEAMT,0) ) as TLoss

from

GI_GC_IH_INTIMATIONHD i

left outer join

(

select por_org_code,plc_loc_code,pdp_dept_code,pdt_doctype,gih_documentno,gid_ply_serialno,

gih_inti_entryno,gih_year,

sum(coalesce(gis_lossclaimed,0)) gis_lossclaimed,sum(coalesce(gis_lossassessed,0)) gis_lossassessed,

sum(coalesce(gis_lossadjusted,0)) gis_lossadjusted,sum(coalesce(gis_surveyoramt,0)) gis_surveyoramt,

sum(coalesce(gis_advocateamt,0)) gis_advocateamt, sum(coalesce(GIS_SALVAGEAMT,0)) GIS_SALVAGEAMT

from GI_GC_IS_INTIMATIONSUBDTL

 

group by por_org_code,plc_loc_code,pdp_dept_code,pdt_doctype,gih_documentno,gid_ply_serialno,

gih_inti_entryno,gih_year

 

)ISUBDTL1 on  

I.POR_ORG_CODE         = ISUBDTL1.POR_ORG_CODE     AND 

I.PLC_LOC_CODE         = ISUBDTL1.PLC_LOC_CODE     AND 

I.PDP_DEPT_CODE        = ISUBDTL1.PDP_DEPT_CODE    AND 

I.PDT_DOCTYPE          = ISUBDTL1.PDT_DOCTYPE         AND 

I.GIH_DOCUMENTNO       = ISUBDTL1.GIH_DOCUMENTNO   AND 

I.GIH_INTI_ENTRYNO     = ISUBDTL1.GIH_INTI_ENTRYNO AND 

I.GIH_YEAR             = ISUBDTL1.GIH_YEAR  

group by

i.por_org_code,i.plc_loc_code,i.pdp_dept_code,i.pdt_doctype,i.gih_documentno,i.gih_inti_entryno,i.gih_year) X on

IH.POR_ORG_CODE         = X.POR_ORG_CODE     AND 

IH.PLC_LOC_CODE         = X.PLC_LOC_CODE     AND 

IH.PDP_DEPT_CODE        = X.PDP_DEPT_CODE    AND 

IH.PDT_DOCTYPE          = X.PDT_DOCTYPE         AND 

IH.GIH_DOCUMENTNO       = X.GIH_DOCUMENTNO   AND 

IH.GIH_INTI_ENTRYNO     = X.GIH_INTI_ENTRYNO AND 

IH.GIH_YEAR             = X.GIH_YEAR  

 

inner join gi_gu_dh_doc_header h on (idtl.gid_basedocumentno=h.gdh_doc_reference_no and h.gdh_record_type='O')

INNER JOIN CLAIM_PAID_TABLE B ON  (IH.GIH_DOC_REF_NO=B.CLMREF AND IH.GIH_INTI_ENTRYNO=B.INT_ENTRY_NO)

 

INNER JOIN GI_GC_SH_SETTELMENTHD SH ON (sh.gsh_doc_ref_no=b.clmref and sh.gih_inti_entryno=b.int_entry_no and sh.gsh_entryno=b.sett_no)

INNER JOIN PR_GN_PS_PARTY PP ON (IH.PPS_PARTY_CODE=PP.PPS_PARTY_CODE)

INNER JOIN PR_GN_DP_DEPARTMENT DP ON (IH.PDP_DEPT_CODE=DP.PDP_DEPT_CODE AND IH.PLC_LOC_CODE=DP.PLC_LOC_CODE)

INNER JOIN PR_GN_LC_LOCATION LC ON (IH.PLC_LOC_CODE=LC.PLC_LOC_CODE)

left outer JOIN  PR_GC_OC_LOSS_CAUSE CL ON ( IH.PDP_DEPT_CODE=CL.PDP_DEPT_CODE AND   IH.POC_LOSSCODE=CL.POC_LOSSCODE )

LEFT OUTER JOIN (SELECT PD.POR_ORG_CODE,PD.PLC_LOC_CODE ,PD.PDP_DEPT_CODE ,PD.PDT_DOCTYPE,  

PD.GIH_DOCUMENTNO ,PD.GIH_YEAR,PD.GSH_ENTRYNO,

Case WHEN PT.PYY_CODE in ('01001','01004') then '0002'

WHEN PT.PYY_CODE in ('02001') then '0007'

WHEN PT.PYY_CODE in ('04001','03001','03002','01006') then '0008'

WHEN PT.PYY_CODE in ('01002','04003') then '0009'

WHEN PT.PYY_CODE in ('01003','02002') then '0005'

WHEN PT.PYY_CODE in ('04001','04002','04003','04004','04005') then '0028'

else '0028' end payee_type,

MAX(Case WHEN PT.PYY_CODE in ('01001','01004') then i.pps_desc

WHEN PT.PYY_CODE in ('02001') then l.psr_surv_name

WHEN PT.PYY_CODE in ('04001','03001','03002','01006') then m.PAV_ADVOCATE_NAME

WHEN PT.PYY_CODE in ('01002','04003') then j.PWC_DESCRIPTION

WHEN PT.PYY_CODE in ('01003','02002') then i.pps_desc

WHEN PT.PYY_CODE in ('04001','04002','04003','04004','04005') then j.PWC_DESCRIPTION

else j.PWC_DESCRIPTION end) payee_name,

sum(PD.GPD_SALESTAX_AMOUNT)GSD_CO_SALESTAXAMOUNT,

sum(pd.gpd_payee_amount*(CASE WHEN PD.GPD_PAYMENT_TYPE='04' THEN -1 ELSE 1 END))GSD_LOSSPAID1

FROM GI_GC_PD_PAYMENT_DETAIL pd

INNER JOIN PR_GC_YY_PAYMENT_TYPE PT ON (

PT.PYY_CODE=PD.GPD_PAYEE_TYPE) 

left outer join PR_GN_PS_PARTY  i  on (i.PPS_PARTY_CODE = PD.GPD_PAYEE_CODE_DESC)

left outer join PR_GC_WS_WORKSHOP j on  (j.PWC_CODE = PD.GPD_PAYEE_CODE_DESC)

left outer join PR_GC_DL_DEALER k on  (k.PDL_CODE = PD.GPD_PAYEE_CODE_DESC)

left outer join PR_GG_SR_SURVEYOR l on  (l.PSR_SURV_CODE = PD.GPD_PAYEE_CODE_DESC)

left outer join PR_GC_AV_ADVOCATE m on  (m.PAV_ADVOCATE_CODE =PD.GPD_PAYEE_CODE_DESC)

group by PD.POR_ORG_CODE,PD.PLC_LOC_CODE ,PD.PDP_DEPT_CODE,PD.PDT_DOCTYPE,PD.GIH_DOCUMENTNO,

PD.GIH_YEAR,PD.GSH_ENTRYNO, Case WHEN PT.PYY_CODE in ('01001','01004') then '0002'

WHEN PT.PYY_CODE in ('02001') then '0007'

WHEN PT.PYY_CODE in ('04001','03001','03002','01006') then '0008'

WHEN PT.PYY_CODE in ('01002','04003') then '0009'

WHEN PT.PYY_CODE in ('01003','02002') then '0005'

WHEN PT.PYY_CODE in ('04001','04002','04003','04004','04005') then '0028'

else '0028' end


) STX ON (

SH.POR_ORG_CODE=STX.POR_ORG_CODE and

SH.PLC_LOC_CODE=STX.PLC_LOC_CODE and

SH.PDP_DEPT_CODE =STX.PDP_DEPT_CODE and

SH.PDT_DOCTYPE=STX.PDT_DOCTYPE and

SH.GIH_DOCUMENTNO=STX.GIH_DOCUMENTNO and

SH.GIH_YEAR=STX.GIH_YEAR and

SH.GSH_ENTRYNO=STX.GSH_ENTRYNO and

stx.payee_type=b.PSP_STYPCODE)

left outer join GI_GC_UD_SURVEYORDTL svd on (

IH.POR_ORG_CODE         = svd.POR_ORG_CODE     AND

IH.PLC_LOC_CODE          = svd.PLC_LOC_CODE     AND

IH.PDP_DEPT_CODE        = svd.PDP_DEPT_CODE    AND

IH.PDT_DOCTYPE            = svd.PDT_DOCTYPE      AND

IH.GIH_DOCUMENTNO     = svd.GIH_DOCUMENTNO   AND    

IH.GIH_INTI_ENTRYNO    = svd.GIH_INTI_ENTRYNO AND

IH.GIH_YEAR                  = svd.GIH_YEAR and gud_serialno=1)

left outer join PR_GG_SR_SURVEYOR sv on (

svd.psr_surv_code=sv.psr_surv_code)

left outer join GI_GC_IC_INTIMATION_COINSURER IC ON

(

IDTL.POR_ORG_CODE         = IC.POR_ORG_CODE     AND 

IDTL.PLC_LOC_CODE         = IC.PLC_LOC_CODE     AND 

IDTL.PDP_DEPT_CODE        = IC.PDP_DEPT_CODE    AND 

IDTL.PDT_DOCTYPE          = IC.PDT_DOCTYPE         AND 

IDTL.GIH_DOCUMENTNO       = IC.GIH_DOCUMENTNO   AND 

IDTL.GIH_INTI_ENTRYNO     = IC.GIH_INTI_ENTRYNO AND 

IDTL.GIH_YEAR             = IC.GIH_YEAR         AND 

IDTL.GID_BASEDOCUMENTNO = IC.GIC_BASEDOCUMENTNO  AND

IC.GIC_CORETAG='C' AND IC.GIC_LEADERTAG='Y' )

         

WHERE

--IH.PDP_DEPT_CODE BETWEEN  {?DEPFROM}   AND  {?DEPTO}    AND {?SLINE}={?SLINE}

--AND IH.PLC_LOC_CODE BETWEEN {?BRFROM} AND {?BRTO} AND

SH.GSH_SETTLEMENTDATE BETWEEN '01-jan-2000' AND '15-may-2019' AND

b.vchdate  BETWEEN '01-jan-2019' AND '15-may-2019' AND

H.GDH_COMMDATE BETWEEN '01-jan-2000' AND '15-may-2019'

AND IH.gih_INTIMATIONDATE BETWEEN '01-jan-2000' AND '15-may-2019'

--and ih.pps_party_code between case {?CLIENTFROM} WHEN 'All' then ih.pps_party_code else {?CLIENTFROM} end and case {?CLIENTTO} when 'All' then ih.pps_party_code else {?CLIENTTO} end 

 

)

)group by plc_Desc

;

------------------------------------------------------------------------------------


