--Claim O/s Query
SELECT
    SUM(os),
    SUM(refno)
FROM
    (
        SELECT
            insured,
            br_code,
            br_desc,
            pdp_code,
            pdp_desc,
            SUM(os) os,
            COUNT(gih_doc_ref_no) refno
        FROM
            (
                SELECT
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
                FROM
                    (
                        SELECT DISTINCT
                            h.gis_registration_no,
                            h.gis_engine_no,
                            h.gis_sailing_date,
                            coalesce(
                                h.coinsurere,
                                'x'
                            ) coinsurere,
                            h.gis_chassis_no,
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
                                                    CASE gih_inti_entryno
                                                        WHEN '1'   THEN TO_DATE(gih_intimationdate)
                                                        ELSE TO_DATE(gih_revisiondate)
                                                    END
                                                BETWEEN '01-Apr-2017' AND '31-Mar-2019'
                                            AND
                                                TO_DATE(gih_intimationdate) BETWEEN '01-Jan-2000' AND '31-Mar-2019'
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
                                            dh.gdh_record_type in ('O','D')
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
                                                        TO_DATE(shd.gsh_settlementdate) BETWEEN TO_DATE(shd.gsh_settlementdate) AND '31-Mar-2019'
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
                                ih.PIY_INSUTYPE in ('D','O') 
                                And
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
                                                    TO_DATE(netoff_date) < '31-mar-2019'
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
            )
            where pdp_code=11
        GROUP BY
            insured,
            br_code,
            br_desc,
            pdp_code,
            pdp_desc,
            gih_doc_ref_no
    )
GROUP BY
    refno

--order by br_desc
    ;