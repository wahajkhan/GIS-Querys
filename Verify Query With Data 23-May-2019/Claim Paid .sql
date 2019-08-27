--select PSP_STYPDESC,pd from (
SELECT
    pdp_desc,
--    psp_stypcode,

plc_desc,pps_Desc,
    SUM(paid) ClaimPaid
FROM
    (
        SELECT
            plc_desc,
            pdp_desc,
            pps_desc,
            psp_stypcode,
                CASE
                    WHEN tloss = 0  THEN 0
                    ELSE ( ( ( ( knockoff * loss ) / tloss ) * gic_share ) / 100 )
                END
            AS paid
        FROM
            (
                SELECT 
 
PLC_LOCADESC,
                    psp_stypcode,
                        CASE
                            WHEN (
                                (
                                        coalesce(
                                            sh.gsh_surv_ourshare,
                                            'N'
                                        ) = 'Y'
                                    AND
                                        b.psp_stypcode = '0007'
                                ) OR (
                                        coalesce(
                                            sh.gsh_advocate_ourshare,
                                            'N'
                                        ) = 'Y'
                                    AND
                                        b.psp_stypcode = '0008'
                                ) OR (
                                        coalesce(
                                            sh.gsh_loss_ourshare,
                                            'N'
                                        ) = 'Y'
                                    AND
                                        b.psp_stypcode NOT IN (
                                            '0007','0008'
                                        )
                                )
                            ) THEN 100
                            ELSE coalesce(
                                ic.gic_share,
                                100
                            )
                        END
                    gic_share,
                    isubdtl.gis_sailing_date,
                    coalesce(
                        stx.payee_name,
                        'N/A'
                    ) payeename,
                    coalesce(
                        sv.psr_surv_name,
                        'None'
                    ) psr_surv_name,
                    b.vchdate,
                    b.clmref,
                    ih.gih_inti_entryno,
                    coalesce(
                        b.knockoffamount,
                        0
                    ) knockoff,
                    b.ppf_prfccode,
                    b.plc_locacode,
                    b.pvt_vchttype,
                    b.lvh_vchdno,
                    ih.gih_oldclaim_no,
                    piy.piy_desc,
                    ih.gih_intimationdate,
                    idtl.gid_basedocumentno policyno,
                    idtl.gid_commdate,
                    idtl.gid_expirydate,
                    idtl.gid_issuedate,
                    coalesce(
                        isubdtl.gis_registration_no,
                        'N/A'
                    ) regno,
                    coalesce(
                        isubdtl.gis_engine_no,
                        'N/A'
                    ) engineno,
                    coalesce(
                        isubdtl.gis_chassis_no,
                        'N/A'
                    ) chassis,
                    coalesce(
                        x.tloss,
                        0
                    ) AS tloss,
                    sv.psr_surv_name,
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
                            WHEN coalesce(
                                ih.gih_noclaim_tag,
                                'V'
                            ) = 'N' THEN 0
                            ELSE 1
                        END
                    + coalesce(
                        isubdtl.gis_surveyoramt,
                        0
                    ) + coalesce(
                        isubdtl.gis_advocateamt,
                        0
                    ) - coalesce(
                        isubdtl.gis_salvageamt,
                        0
                    ) AS loss,
                    coalesce(
                        isubdtl.gis_suminsured,
                        0
                    ) gis_suminsured,
                    ( coalesce(
                        isubdtl.gis_lossclaimed,
                        0
                    ) ) gis_lossclaimed,
                    ( coalesce(
                        isubdtl.gis_lossassessed,
                        0
                    ) ) gis_lossassessed,
                    ( coalesce(
                        isubdtl.gis_lossadjusted,
                        0
                    ) ) gis_lossadjusted,
                    ( coalesce(
                        isubdtl.gis_surveyoramt,
                        0
                    ) ) gis_surveyoramt,
                    ( coalesce(
                        isubdtl.gis_advocateamt,
                        0
                    ) ) gis_advocateamt,
                    ( coalesce(
                        isubdtl.gis_excessamount,
                        0
                    ) ) gis_excessamount,
                    ( coalesce(
                        isubdtl.gis_salvageamt,
                        0
                    ) ) gis_salvageamt,
                    ( coalesce(
                        isubdtl.gis_facultamount,
                        0
                    ) ) gis_facultamount,
                    ( coalesce(
                        isubdtl.gis_foreignfacult_amount,
                        0
                    ) ) gis_foreignfacult_amount,
                    ( coalesce(
                        isubdtl.gis_conetamount,
                        0
                    ) ) gis_conetamount,
                    ( coalesce(
                        isubdtl.gis_treatyamount,
                        0
                    ) ) gis_treatyamount,
                    coalesce(
                        h.gdh_as400_documentno,
                        'X'
                    ) old_documentno,
                    ih.gih_revisiondate,
                    b.check_no,
                    b.check_date,
                    ih.gih_dateofloss,
                    ih.pps_party_code,
                    cl.poc_lossdesc,
                    pp.pps_desc,
                    dp.pdp_desc,
                    lc.plc_desc,
                    b.sett_no
                FROM
                    gi_gc_ih_intimationhd ih
                    INNER JOIN gi_gc_id_intimationdtl idtl ON (
                            ih.por_org_code = idtl.por_org_code
                        AND
                            ih.plc_loc_code = idtl.plc_loc_code
                        AND
                            ih.pdp_dept_code = idtl.pdp_dept_code
                        AND
                            ih.pdt_doctype = idtl.pdt_doctype
                        AND
                            ih.gih_documentno = idtl.gih_documentno
                        AND
                            ih.gih_inti_entryno = idtl.gih_inti_entryno
                        AND
                            ih.gih_year = idtl.gih_year
                    )
                    INNER JOIN pr_gg_iy_insurancetype piy ON (
                        ih.piy_insutype = piy.piy_insutype
                    )
                    LEFT OUTER JOIN (
                        SELECT
                            por_org_code,
                            plc_loc_code,
                            pdp_dept_code,
                            pdt_doctype,
                            gih_documentno,
                            gid_ply_serialno,
                            gih_inti_entryno,
                            gih_year,
                            gis_sailing_date,
                            gis_registration_no,
                            gis_engine_no,
                            gis_chassis_no,
                            SUM(coalesce(
                                gis_suminsured,
                                0
                            ) ) gis_suminsured,
                            SUM(coalesce(
                                gis_lossclaimed,
                                0
                            ) ) gis_lossclaimed,
                            SUM(coalesce(
                                gis_lossassessed,
                                0
                            ) ) gis_lossassessed,
                            SUM(coalesce(
                                gis_lossadjusted,
                                0
                            ) ) gis_lossadjusted,
                            SUM(coalesce(
                                gis_surveyoramt,
                                0
                            ) ) gis_surveyoramt,
                            SUM(coalesce(
                                gis_advocateamt,
                                0
                            ) ) gis_advocateamt,
                            SUM(coalesce(
                                gis_excessamount,
                                0
                            ) ) gis_excessamount,
                            SUM(coalesce(
                                gis_salvageamt,
                                0
                            ) ) gis_salvageamt,
                            SUM(coalesce(
                                gis_facultamount,
                                0
                            ) ) gis_facultamount,
                            SUM(coalesce(
                                gis_foreignfacult_amount,
                                0
                            ) ) gis_foreignfacult_amount,
                            SUM(coalesce(
                                gis_conetamount,
                                0
                            ) ) gis_conetamount,
                            SUM(coalesce(
                                gis_treatyamount,
                                0
                            ) ) gis_treatyamount
                        FROM
                            gi_gc_is_intimationsubdtl
                        GROUP BY
                            por_org_code,
                            plc_loc_code,
                            pdp_dept_code,
                            pdt_doctype,
                            gih_documentno,
                            gid_ply_serialno,
                            gih_inti_entryno,
                            gih_year,
                            gis_sailing_date,
                            gis_registration_no,
                            gis_engine_no,
                            gis_chassis_no
                    ) isubdtl ON (
                            idtl.por_org_code = isubdtl.por_org_code
                        AND
                            idtl.plc_loc_code = isubdtl.plc_loc_code
                        AND
                            idtl.pdp_dept_code = isubdtl.pdp_dept_code
                        AND
                            idtl.pdt_doctype = isubdtl.pdt_doctype
                        AND
                            idtl.gih_documentno = isubdtl.gih_documentno
                        AND
                            idtl.gih_inti_entryno = isubdtl.gih_inti_entryno
                        AND
                            idtl.gih_year = isubdtl.gih_year
                        AND
                            idtl.gid_ply_serialno = isubdtl.gid_ply_serialno
                    )
                    LEFT OUTER JOIN (
                        SELECT
                            i.por_org_code,
                            i.plc_loc_code,
                            i.pdp_dept_code,
                            i.pdt_doctype,
                            i.gih_documentno,
                            i.gih_inti_entryno,
                            i.gih_year,
                            SUM(
                                CASE coalesce(
                                    isubdtl1.gis_lossadjusted,
                                    0
                                )
                                    WHEN 0   THEN
                                        CASE coalesce(
                                            isubdtl1.gis_lossassessed,
                                            0
                                        )
                                            WHEN 0   THEN
                                                CASE coalesce(
                                                    isubdtl1.gis_lossclaimed,
                                                    0
                                                )
                                                    WHEN 0   THEN 0
                                                    ELSE coalesce(
                                                        isubdtl1.gis_lossclaimed,
                                                        0
                                                    )
                                                END
                                            ELSE coalesce(
                                                isubdtl1.gis_lossassessed,
                                                0
                                            )
                                        END
                                    ELSE coalesce(
                                        isubdtl1.gis_lossadjusted,
                                        0
                                    )
                                END
                            *
                                CASE
                                    WHEN coalesce(
                                        i.gih_noclaim_tag,
                                        'V'
                                    ) = 'N' THEN 0
                                    ELSE 1
                                END
                            + coalesce(
                                isubdtl1.gis_surveyoramt,
                                0
                            ) + coalesce(
                                isubdtl1.gis_advocateamt,
                                0
                            ) - coalesce(
                                isubdtl1.gis_salvageamt,
                                0
                            ) ) AS tloss
                        FROM
                            gi_gc_ih_intimationhd i
                            LEFT OUTER JOIN (
                                SELECT
                                    por_org_code,
                                    plc_loc_code,
                                    pdp_dept_code,
                                    pdt_doctype,
                                    gih_documentno,
                                    gid_ply_serialno,
                                    gih_inti_entryno,
                                    gih_year,
                                    SUM(coalesce(
                                        gis_lossclaimed,
                                        0
                                    ) ) gis_lossclaimed,
                                    SUM(coalesce(
                                        gis_lossassessed,
                                        0
                                    ) ) gis_lossassessed,
                                    SUM(coalesce(
                                        gis_lossadjusted,
                                        0
                                    ) ) gis_lossadjusted,
                                    SUM(coalesce(
                                        gis_surveyoramt,
                                        0
                                    ) ) gis_surveyoramt,
                                    SUM(coalesce(
                                        gis_advocateamt,
                                        0
                                    ) ) gis_advocateamt,
                                    SUM(coalesce(
                                        gis_salvageamt,
                                        0
                                    ) ) gis_salvageamt
                                FROM
                                    gi_gc_is_intimationsubdtl
                                GROUP BY
                                    por_org_code,
                                    plc_loc_code,
                                    pdp_dept_code,
                                    pdt_doctype,
                                    gih_documentno,
                                    gid_ply_serialno,
                                    gih_inti_entryno,
                                    gih_year
                            ) isubdtl1 ON
                                i.por_org_code = isubdtl1.por_org_code
                            AND
                                i.plc_loc_code = isubdtl1.plc_loc_code
                            AND
                                i.pdp_dept_code = isubdtl1.pdp_dept_code
                            AND
                                i.pdt_doctype = isubdtl1.pdt_doctype
                            AND
                                i.gih_documentno = isubdtl1.gih_documentno
                            AND
                                i.gih_inti_entryno = isubdtl1.gih_inti_entryno
                            AND
                                i.gih_year = isubdtl1.gih_year
                        GROUP BY
                            i.por_org_code,
                            i.plc_loc_code,
                            i.pdp_dept_code,
                            i.pdt_doctype,
                            i.gih_documentno,
                            i.gih_inti_entryno,
                            i.gih_year
                    ) x ON
                        ih.por_org_code = x.por_org_code
                    AND
                        ih.plc_loc_code = x.plc_loc_code
                    AND
                        ih.pdp_dept_code = x.pdp_dept_code
                    AND
                        ih.pdt_doctype = x.pdt_doctype
                    AND
                        ih.gih_documentno = x.gih_documentno
                    AND
                        ih.gih_inti_entryno = x.gih_inti_entryno
                    AND
                        ih.gih_year = x.gih_year
                    INNER JOIN gi_gu_dh_doc_header h ON (
                            idtl.gid_basedocumentno = h.gdh_doc_reference_no
                        AND
                            h.gdh_record_type = 'O'
                    )
                    INNER JOIN claim_paid_table b ON (
                            ih.gih_doc_ref_no = b.clmref
                        AND
                            ih.gih_inti_entryno = b.int_entry_no
                    )
                    INNER JOIN gi_gc_sh_settelmenthd sh ON (
                            sh.gsh_doc_ref_no = b.clmref
                        AND
                            sh.gih_inti_entryno = b.int_entry_no
                        AND
                            sh.gsh_entryno = b.sett_no
                    )
                    INNER JOIN pr_gn_ps_party pp ON (
                        ih.pps_party_code = pp.pps_party_code
                    )
                    INNER JOIN pr_gn_dp_department dp ON (
                            ih.pdp_dept_code = dp.pdp_dept_code
                        AND
                            ih.plc_loc_code = dp.plc_loc_code
                    )
                    INNER JOIN pr_gn_lc_location lc ON (
                        ih.plc_loc_code = lc.plc_loc_code
                    )
                    LEFT OUTER JOIN pr_gc_oc_loss_cause cl ON (
                            ih.pdp_dept_code = cl.pdp_dept_code
                        AND
                            ih.poc_losscode = cl.poc_losscode
                    )
                    LEFT OUTER JOIN (
                        SELECT
                            pd.por_org_code,
                            pd.plc_loc_code,
                            pd.pdp_dept_code,
                            pd.pdt_doctype,
                            pd.gih_documentno,
                            pd.gih_year,
                            pd.gsh_entryno,
                                CASE
                                    WHEN pt.pyy_code IN (
                                        '01001','01004'
                                    ) THEN '0002'
                                    WHEN pt.pyy_code IN (
                                        '02001'
                                    ) THEN '0007'
                                    WHEN pt.pyy_code IN (
                                        '04001','03001','03002','01006'
                                    ) THEN '0008'
                                    WHEN pt.pyy_code IN (
                                        '01002','04003'
                                    ) THEN '0009'
                                    WHEN pt.pyy_code IN (
                                        '01003','02002'
                                    ) THEN '0005'
                                    WHEN pt.pyy_code IN (
                                        '04001','04002','04003','04004','04005'
                                    ) THEN '0028'
                                    ELSE '0028'
                                END
                            payee_type,
                            MAX(
                                CASE
                                    WHEN pt.pyy_code IN(
                                        '01001','01004'
                                    ) THEN i.pps_desc
                                    WHEN pt.pyy_code IN(
                                        '02001'
                                    ) THEN l.psr_surv_name
                                    WHEN pt.pyy_code IN(
                                        '04001','03001','03002','01006'
                                    ) THEN m.pav_advocate_name
                                    WHEN pt.pyy_code IN(
                                        '01002','04003'
                                    ) THEN j.pwc_description
                                    WHEN pt.pyy_code IN(
                                        '01003','02002'
                                    ) THEN i.pps_desc
                                    WHEN pt.pyy_code IN(
                                        '04001','04002','04003','04004','04005'
                                    ) THEN j.pwc_description
                                    ELSE j.pwc_description
                                END
                            ) payee_name,
                            SUM(pd.gpd_salestax_amount) gsd_co_salestaxamount,
                            SUM(pd.gpd_payee_amount * (
                                CASE
                                    WHEN pd.gpd_payment_type = '04'   THEN -1
                                    ELSE 1
                                END
                            ) ) gsd_losspaid1
                        FROM
                            gi_gc_pd_payment_detail pd
                            INNER JOIN pr_gc_yy_payment_type pt ON (
                                pt.pyy_code = pd.gpd_payee_type
                            )
                            LEFT OUTER JOIN pr_gn_ps_party i ON (
                                i.pps_party_code = pd.gpd_payee_code_desc
                            )
                            LEFT OUTER JOIN pr_gc_ws_workshop j ON (
                                j.pwc_code = pd.gpd_payee_code_desc
                            )
                            LEFT OUTER JOIN pr_gc_dl_dealer k ON (
                                k.pdl_code = pd.gpd_payee_code_desc
                            )
                            LEFT OUTER JOIN pr_gg_sr_surveyor l ON (
                                l.psr_surv_code = pd.gpd_payee_code_desc
                            )
                            LEFT OUTER JOIN pr_gc_av_advocate m ON (
                                m.pav_advocate_code = pd.gpd_payee_code_desc
                            )
                        GROUP BY
                            pd.por_org_code,
                            pd.plc_loc_code,
                            pd.pdp_dept_code,
                            pd.pdt_doctype,
                            pd.gih_documentno,
                            pd.gih_year,
                            pd.gsh_entryno,
                            CASE
                                WHEN pt.pyy_code IN (
                                    '01001','01004'
                                ) THEN '0002'
                                WHEN pt.pyy_code IN (
                                    '02001'
                                ) THEN '0007'
                                WHEN pt.pyy_code IN (
                                    '04001','03001','03002','01006'
                                ) THEN '0008'
                                WHEN pt.pyy_code IN (
                                    '01002','04003'
                                ) THEN '0009'
                                WHEN pt.pyy_code IN (
                                    '01003','02002'
                                ) THEN '0005'
                                WHEN pt.pyy_code IN (
                                    '04001','04002','04003','04004','04005'
                                ) THEN '0028'
                                ELSE '0028'
                            END
                    ) stx ON (
                            sh.por_org_code = stx.por_org_code
                        AND
                            sh.plc_loc_code = stx.plc_loc_code
                        AND
                            sh.pdp_dept_code = stx.pdp_dept_code
                        AND
                            sh.pdt_doctype = stx.pdt_doctype
                        AND
                            sh.gih_documentno = stx.gih_documentno
                        AND
                            sh.gih_year = stx.gih_year
                        AND
                            sh.gsh_entryno = stx.gsh_entryno
                        AND
                            stx.payee_type = b.psp_stypcode
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
                            gud_serialno = 1
                    )
                    LEFT OUTER JOIN pr_gg_sr_surveyor sv ON (
                        svd.psr_surv_code = sv.psr_surv_code
                    )
                    LEFT OUTER JOIN gi_gc_ic_intimation_coinsurer ic ON (
                            idtl.por_org_code = ic.por_org_code
                        AND
                            idtl.plc_loc_code = ic.plc_loc_code
                        AND
                            idtl.pdp_dept_code = ic.pdp_dept_code
                        AND
                            idtl.pdt_doctype = ic.pdt_doctype
                        AND
                            idtl.gih_documentno = ic.gih_documentno
                        AND
                            idtl.gih_inti_entryno = ic.gih_inti_entryno
                        AND
                            idtl.gih_year = ic.gih_year
                        AND
                            idtl.gid_basedocumentno = ic.gic_basedocumentno
                        AND
                            ic.gic_coretag = 'C'
                        AND
                            ic.gic_leadertag = 'Y'
                    )
                WHERE
 
                        sh.gsh_settlementdate BETWEEN '01-jan-2000' AND '23-May-2019'
                    AND
                        b.vchdate BETWEEN '01-Jan-2019' AND '23-May-2019'
                    AND
                        h.gdh_commdate BETWEEN '01-jan-2000' AND '23-may-2019'
                    AND
                        ih.gih_intimationdate BETWEEN '01-jan-2000' AND '23-may-2019'
 
--                    AND 
--                        ih.PDP_DEPT_COD='13'
            ) pd1
    )
GROUP BY
    pdp_desc,
    plc_desc,pps_Desc
--    psp_stypcode
ORDER BY
    pdp_desc
    
--    psp_stypcode

--left outer join PR_GL_SP_SLTYPE s on (psp_stypcode=s.psp_stypcode)

 

--,s.PSP_STYPDESC

 

--plc_Desc,pps_Desc
    ;