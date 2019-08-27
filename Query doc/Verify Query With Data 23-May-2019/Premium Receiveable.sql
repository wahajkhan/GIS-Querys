SELECT
    plc_desc,
    pdp_desc,
    client,
    SUM(os)
FROM
    ( 
        SELECT DISTINCT 
            outstanding.seq AS seq,
            outstanding.gcd_share,
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
            coalesce(
                outstanding.np1,
                0
            ) AS np1,
            coalesce(
                outstanding.np,
                0
            ) AS np,
            coalesce(
                outstanding.gp_our,
                0
            ) AS gp_our,
            coalesce(
                outstanding.gp100,
                0
            ) AS gp100,
            outstanding.ggd_leaderreference AS ggd_leaderreference,
            outstanding.agent AS agent,
            outstanding.folio AS folio,
            outstanding.pdo_devoffcode AS pdo_devoffcode,
            outstanding.pdo_devoffdesc AS pdo_devoffdesc,
            coalesce(
                outstanding.knockoff,
                0
            ) AS knockoff,
            coalesce(
                outstanding.opening,
                0
            ) AS opening,
            coalesce(
                outstanding.advances,
                0
            ) AS advances,
            coalesce(
                outstanding.np1,
                0
            ) - coalesce(
                outstanding.knockoff,
                0
            ) AS os
        FROM
            (
                SELECT
                    1 AS seq,
                    1 gcd_share,
                    op.pps_party_code AS client_code,
                    'A1' pdt_doctype,
                    op.pps_desc AS client,
                    op.loc AS plc_loc_code,
                    br.plc_desc AS plc_desc,
                    NULL AS pdp_dept_code,
                    NULL AS pdp_desc,
                    NULL AS docrefno,
                    NULL AS docref,
                    NULL AS agent_code,
                    NULL AS basedocumentno,
                    NULL AS gdh_as400_documentno,
                    NULL AS folio_code,
                    NULL AS gdh_individual_client,
                    NULL AS posttag,
                    NULL AS commdate,
                    NULL AS issuedate,
                    NULL AS expdate,
                    0 AS np1,
                    0 AS np,
                    0 AS gp_our,
                    0 AS gp100,
                    NULL AS ggd_leaderreference,
                    NULL AS agent,
                    NULL AS folio,
                    NULL AS pdo_devoffcode,
                    NULL AS pdo_devoffdesc,
                    0 AS knockoff,
                    SUM(coalesce(
                        op.open_bal,
                        0
                    ) ) AS opening,
                    0 AS advances
                FROM
                    (
                        SELECT
                            q.pps_party_code,
                            q.pps_desc,
                            q.vchddate vchddate,
                            ( coalesce(
                                q.a1,
                                0
                            ) - coalesce(
                                q.b1,
                                0
                            ) ) open_bal,
                            q.org,
                            q.loc
                        FROM
                            (
                                SELECT
                                    a.org,
                                    a.loc,
                                    a.pps_party_code,
                                    a.pps_desc,
                                    a.vchddate,
                                    SUM(
                                        CASE a.pad_advtcode
                                            WHEN 'ORBA'   THEN coalesce(
                                                a.bal,
                                                0
                                            )
                                            ELSE 0
                                        END
                                    ) a1,
                                    SUM(
                                        CASE a.pad_advtcode
                                            WHEN 'OPBA'   THEN coalesce(
                                                a.bal,
                                                0
                                            )
                                            ELSE 0
                                        END
                                    ) b1
                                FROM
                                    (
                                        SELECT
                                            sb.por_orgacode org,
                                            sb.plc_locacode loc,
                                            sl.psa_sactaccount pps_party_code,
                                            pp.pps_desc,
                                            sb.lpm_rmstdate vchddate,
                                            sl.pad_advtcode,
                                            coalesce(
                                                sl.lsl_sldramtbc,
                                                0
                                            ) --,COALESCE (sl.lsl_sldrknockoffamtbc,0),
                                             - coalesce(
                                                (
                                                    SELECT
                                                        abs(SUM(coalesce(
                                                            vd.lvd_vcdtcramtbc,
                                                            0
                                                        ) - coalesce(
                                                            vd.lvd_vcdtdramtbc,
                                                            0
                                                        ) ) )
                                                    FROM
                                                        ac_gl_vd_vchdetail vd,
                                                        ac_gl_vh_voucher v
                                                    WHERE
                                                            vd.por_orgacode = v.por_orgacode
                                                        AND
                                                            vd.plc_locacode = v.plc_locacode
                                                        AND
                                                            vd.pvt_vchttype = v.pvt_vchttype
                                                        AND
                                                            vd.pfs_acntyear = v.pfs_acntyear
                                                        AND
                                                            vd.lvh_vchdno = v.lvh_vchdno
                                                        AND
                                                            coalesce(
                                                                v.lvh_vchdstatus,
                                                                'N'
                                                            ) <> 'C'
                                                        AND
                                                            v.lvh_vchddate <= '15-MAY-2019'
                                                        AND
                                                            vd.plc_locacode = sl.plc_locacode
                                                        AND
                                                            vd.lvd_vcdtnarration1 = sl.pfs_acntyear
                                                             || '-'
                                                             || sl.pad_advtcode
                                                             || '-'
                                                             || sl.lpm_rmstno
                                                             || '-'
                                                             || sl.lpd_rdtlsrno
                                                             || '-'
                                                             || sl.lsl_sldrno
                                                ),
                                                0
                                            ) bal
                                        FROM
                                            ac_gl_sl_subledger sl
                                            INNER JOIN pr_gn_ps_party pp ON (
                                                pp.pps_party_code = sl.psa_sactaccount
                                            )
                                            INNER JOIN ac_gl_pm_rcppymmaster sb ON (
                                                    sb.por_orgacode = sl.por_orgacode
                                                AND
                                                    sb.plc_locacode = sl.plc_locacode
                                                AND
                                                    sb.pad_advtcode = sl.pad_advtcode
                                                AND
                                                    sb.pfs_acntyear = sl.pfs_acntyear
                                                AND
                                                    sb.lpm_rmstno = sl.lpm_rmstno
                                            )
                                        WHERE
                                                sl.pad_advtcode IN (
                                                    'ORBA','OPBA'
                                                )
                                            AND
                                                coalesce(
                                                    sb.lpm_rmststatus,
                                                    'N'
                                                ) <> 'C'
                                    ) a
                                GROUP BY
                                    a.org,
                                    a.loc,
                                    a.pps_party_code,
                                    a.pps_desc,
                                    a.vchddate
                            ) q
                    ) op
                    INNER JOIN pr_gn_lc_location br ON (
                            op.org = br.por_orgacode
                        AND
                            op.loc = br.plc_locacode
                    )
                    INNER JOIN pr_gn_ps_party p ON (
                        p.pps_party_code = substring(
                            op.pps_party_code,
                            1,
                            CASE '10'
                                WHEN '0'   THEN '20'
                                ELSE '10'
                            END
                        )
                    )
                WHERE
                        op.vchddate <= '15-MAY-2019'
                    AND
                        p.pps_nature = 'C'

--                      AND op.loc BETWEEN {?BRANCHFROM} AND {?BRANCHTO}

--                      AND 'Y' = {?WithOpBalance}

--                     AND substring(P.pps_party_code,1,CASE '10' WHEN '0' THEN '20' ELSE '10' END) BETWEEN

--case {?CLIENTFROM} when 'All' then substring(P.pps_party_code,1,CASE '10' WHEN '0' THEN '20' ELSE '10' END)  else {?CLIENTFROM} end AND

--case {?CLIENTTO} when 'All' then substring(P.pps_party_code,1,CASE '10' WHEN '0' THEN '20' ELSE '10' END)  else {?CLIENTTO} end

--and {?PARA_HIDE}={?PARA_HIDE}
                GROUP BY
                    op.pps_party_code,
                    op.pps_desc,
                    op.loc,
                    br.plc_desc
                HAVING
                    SUM(coalesce(
                        op.open_bal,
                        0
                    ) ) <> 0
                UNION
                SELECT
                    2 AS seq,
                        CASE own_share_tag
                            WHEN 'Y'   THEN 100
                            ELSE coalesce(
                                cd.gcd_share,
                                100
                            )
                        END
                    gcd_share,
                        CASE
                            WHEN
                                own_share_tag = 'Y'
                            AND
                                h.piy_insutype = 'I'
                            THEN coalesce(
                                h.client_code,
                                'N'
                            )
                            ELSE coalesce(
                                h.folio_code,
                                'N'
                            )
                        END
                    AS client_code,
                    h.pdt_doctype,
                    pt.pps_desc client,
                    h.plc_loc_code AS plc_loc_code,
                    lc.plc_desc AS plc_desc,
                    h.pdp_dept_code AS pdp_dept_code,
                    dp.pdp_desc AS pdp_desc,
                    h.docrefno AS docrefno,
                    cl.docref AS docref,
                    h.agent_code AS agent_code,
                    h.basedocumentno AS basedocumentno,
                    h.gdh_as400_documentno AS gdh_as400_documentno,
                    h.folio_code AS folio_code,
                    h.gdh_individual_client AS gdh_individual_client,
                    h.posttag AS posttag,
                    h.commdate AS commdate,
                    h.issuedate AS issuedate,
                    h.expdate AS expdate,
                        CASE own_share_tag
                            WHEN 'Y'   THEN coalesce(
                                h.netprem,
                                0
                            )
                            ELSE h.np100
                        END
                    AS np1,
                    coalesce(
                        h.netprem,
                        0
                    ) AS np,
                    h.grossprem AS gp_our,
                        CASE own_share_tag
                            WHEN 'Y'   THEN coalesce(
                                h.grossprem,
                                0
                            )
                            ELSE h.gp100
                        END
                    AS gp100,
                    h.ggd_leaderreference AS ggd_leaderreference,
                    agt.pps_desc AS agent,
                    pft.pps_desc AS folio,
                    coalesce(
                        h.pdo_devoffcode,
                        '12XX'
                    ) pdo_devoffcode,
                    coalesce(
                        do.pdo_devoffdesc,
                        'All'
                    ) AS pdo_devoffdesc,
                    coalesce(
                        cl.koff,
                        0
                    ) AS knockoff,
                    0 AS opening,
                    0 AS advances
                FROM
                    premium_view h
                    LEFT OUTER JOIN (
                        SELECT
                            docref,
                            policy_no,
                            coalesce(
                                SUM(knockoffamount),
                                0
                            ) koff
                        FROM
                            collection_table
                        WHERE
                            vchdate <= '15-MAY-2019'

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
                        GROUP BY
                            docref,
                            policy_no
                    ) cl ON (
                            h.docrefno = cl.docref
                        AND
                            (
                                CASE h.pdt_doctype
                                    WHEN 'E'   THEN h.basedocumentno
                                    ELSE 'n'
                                END
                            ) = (
                                CASE h.pdt_doctype
                                    WHEN 'E'   THEN cl.policy_no
                                    ELSE 'n'
                                END
                            )
                    )
                    LEFT OUTER JOIN pr_gg_do_devofficer do ON (
                        h.pdo_devoffcode = do.pdo_devoffcode
                    )
                    INNER JOIN pr_gn_dp_department dp ON (
                            h.plc_loc_code = dp.plc_loc_code
                        AND
                            h.pdp_dept_code = dp.pdp_dept_code
                    )
                    LEFT OUTER JOIN gi_gu_dh_doc_header eh ON (
                            h.basedocumentno = eh.gdh_doc_reference_no
                        AND
                            h.gdh_record_type = eh.gdh_record_type
                    )
                    INNER JOIN pr_gn_lc_location lc ON (
                        h.plc_loc_code = lc.plc_loc_code
                    )
                    LEFT OUTER JOIN pr_gn_ps_party agt ON (
                        h.agent_code = agt.pps_party_code
                    )
                    LEFT OUTER JOIN pr_gn_ps_party pt ON (
                            CASE own_share_tag
                                WHEN 'Y'   THEN coalesce(
                                    h.client_code,
                                    'N'
                                )
                                ELSE coalesce(
                                    h.folio_code,
                                    'N'
                                )
                            END
                        = pt.pps_party_code
                    )
                    LEFT OUTER JOIN pr_gn_ps_party pft ON (
                        h.folio_code = pft.pps_party_code
                    )
                    LEFT OUTER JOIN pr_gg_bc_business_class bc ON (
                        h.pbc_busiclass_code = bc.pbc_busiclass_code
                    )
                    LEFT OUTER JOIN gi_gu_cd_coinsurerdtl cd ON (
                            h.por_org_code = cd.por_org_code
                        AND
                            h.plc_loc_code = cd.plc_loc_code
                        AND
                            h.pdp_dept_code = cd.pdp_dept_code
                        AND
                            h.pbc_busiclass_code = cd.pbc_busiclass_code
                        AND
                            h.piy_insutype = cd.piy_insutype
                        AND
                            h.pdt_doctype = cd.pdt_doctype
                        AND
                            h.gdh_documentno = cd.gdh_documentno
                        AND
                            h.gdh_record_type = cd.gdh_record_type
                        AND
                            h.gdh_year = cd.gdh_year
                        AND
                            cd.gcd_leadertag = 'Y'
                    )
                WHERE
                        coalesce(
                            h.gdh_oldmaster_ref_no,
                            'N'
                        ) <> 'net off pb cases'
                    AND
                        h.por_org_code = '001001' 


                    AND h.PIY_INSUTYPE in ('D','O')
                    AND
                        h.issuedate BETWEEN '01-JAN-2000' AND '15-MAY-2019'
                    AND
                            CASE pbc_openpolicy_financialimpact
                                WHEN 'Y'   THEN 'P'
                                ELSE
                                    CASE h.pdt_doctype
                                        WHEN 'E'   THEN eh.pdt_doctype
                                        ELSE h.pdt_doctype
                                    END
                            END
                        <> 'O'
                    AND
                            CASE own_share_tag
                                WHEN 'Y'   THEN 'D'
                                ELSE h.piy_insutype
                            END
                        NOT IN (
                            'I','A'
                        )

 

--                    AND COALESCE (h.pdo_devoffcode,'12XX')

--                           BETWEEN CASE 'All'

--                           WHEN {?DOFROM}

--                              THEN COALESCE (h.pdo_devoffcode,'12XX')

--                           ELSE 'All'

--                        END

--                               AND CASE 'All'

--                           WHEN {?DOTO}

--                              THEN COALESCE (h.pdo_devoffcode,'12XX')

--                           ELSE 'All'

--                        END

 

 

                     --AND COALESCE(H.POSTTAG,'N')=CASE {?POSTED} WHEN 'Y' THEN 'Y' WHEN 'N' THEN 'N' ELSE COALESCE(H.POSTTAG,'N') END 

 

   

-- and CASE WHEN own_share_tag = 'Y'  AND  h.piy_insutype='I'   THEN COALESCE(H.CLIENT_CODE,'N') ELSE  COALESCE(H.FOLIO_CODE,'N') end

 --between

--case {?CLIENTFROM} when 'All' then CASE WHEN own_share_tag = 'Y'  AND  h.piy_insutype='I'  THEN COALESCE(H.CLIENT_CODE,'N') ELSE  COALESCE(H.FOLIO_CODE,'N') end  else {?CLIENTFROM} end and

--case {?CLIENTTO} when 'All' then CASE WHEN own_share_tag = 'Y'  AND  h.piy_insutype='I'  THEN COALESCE(H.CLIENT_CODE,'N') ELSE  COALESCE(H.FOLIO_CODE,'N') end  else {?CLIENTTO} end

--and {?SLINE}={?SLINE}
                    AND
                        (
                            CASE own_share_tag
                                WHEN 'Y'   THEN coalesce(
                                    h.netprem,
                                    0
                                )
                                ELSE h.np100
                            END
                        - coalesce(
                            cl.koff,
                            0
                        ) ) <> 0
                UNION
                SELECT
                    adv.seq AS seq,
                    1 gcd_share,
                    adv.client_code AS client_code,
                    adv.pdt_doctype,
                    ins.pps_desc AS client,
                    adv.plc_locacode AS plc_locacode,
                    br.plc_desc AS plc_desc,
                    NULL AS pdp_dept_code,
                    NULL AS pdp_desc,
                    NULL AS docrefno,
                    NULL AS docref,
                    NULL AS agent_code,
                    NULL AS basedocumentno,
                    NULL AS gdh_as400_documentno,
                    NULL AS folio_code,
                    NULL AS gdh_individual_client,
                    NULL AS posttag,
                    NULL AS commdate,
                    NULL AS issuedate,
                    NULL AS expdate,
                    0 AS np1,
                    0 AS np,
                    0 AS gp_our,
                    0 AS gp100,
                    NULL AS ggd_leaderreference,
                    NULL AS agent,
                    NULL AS folio,
                    NULL AS pdo_devoffcode,
                    NULL AS pdo_devoffdesc,
                    0 AS knockoff,
                    0 AS opening,
                    SUM(coalesce(
                        adv.advances,
                        0
                    ) ) AS advances
                FROM
                    (
                        SELECT
                            3 AS seq,
                            submas.psa_sactaccount AS client_code,
                            'A1' pdt_doctype,
                            submas.plc_locacode AS plc_locacode,
                            coalesce(
                                submas.lsm_smstbalcrbc,
                                0
                            ) - coalesce(
                                submas.lsm_smstbaldrbc,
                                0
                            ) AS advances
                        FROM
                            ac_gl_sm_submaster submas
                        WHERE

--       submas.plc_locacode between {?BRANCHFROM} and {?BRANCHTO}

--and substring(submas.PSA_SACTACCOUNT,1,CASE '10' WHEN '0' THEN '20' ELSE '10' END) BETWEEN

--case {?CLIENTFROM} when 'All' then substring(submas.PSA_SACTACCOUNT,1,CASE '10' WHEN '0' THEN '20' ELSE '10' END)  else {?CLIENTFROM} end AND

--case {?CLIENTTO} when 'All' then substring(submas.PSA_SACTACCOUNT,1,CASE '10' WHEN '0' THEN '20' ELSE '10' END)  else {?CLIENTTO} end

 

/*and   substring(submas.PFS_ACNTYEAR,1,4)  =  to_char(to_date( '15-MAY-2019' ,'DD/MM/YYYY'),'YYYY')  */

--AND
                                substring(
                                    submas.pfs_acntyear,
                                    1,
                                    4
                                ) = '2019'
                            AND
                                submas.pca_glaccode IN (
                                    SELECT
                                        m_code
                                    FROM
                                        gias_prm_mapping
                                    WHERE
                                        m_type = 55
                                )
                            AND
                                submas.ppd_perdno = 0
                        UNION
                        SELECT
                            3 AS seq,
                            sd.psa_sactaccount AS client_code,
                            'A1' pdt_doctype,
                            sd.plc_locacode AS plc_locacode,
                            ( SUM(coalesce(
                                sd.lsb_sdtlcramtbc,
                                0
                            ) ) - SUM(coalesce(
                                sd.lsb_sdtldramtbc,
                                0
                            ) ) ) AS advances
                        FROM
                            ac_gl_vh_voucher vh
                            INNER JOIN ac_gl_vd_vchdetail vd ON (
                                    vh.por_orgacode = vd.por_orgacode
                                AND
                                    vh.plc_locacode = vd.plc_locacode
                                AND
                                    vh.pvt_vchttype = vd.pvt_vchttype
                                AND
                                    vh.pfs_acntyear = vd.pfs_acntyear
                                AND
                                    vh.lvh_vchdno = vd.lvh_vchdno
                            )
                            INNER JOIN ac_gl_sb_subdetail sd ON (
                                    vd.por_orgacode = sd.por_orgacode
                                AND
                                    vd.plc_locacode = sd.plc_locacode
                                AND
                                    vd.pvt_vchttype = sd.pvt_vchttype
                                AND
                                    vd.pfs_acntyear = sd.pfs_acntyear
                                AND
                                    vd.lvh_vchdno = sd.lvh_vchdno
                                AND
                                    vd.lvd_vcdtvouchsr = sd.lvd_vcdtvouchsr
                            )
                            INNER JOIN pr_gn_ps_party p ON (
                                substring(
                                    sd.psa_sactaccount,
                                    1,
                                    CASE '10'
                                        WHEN '0'   THEN '20'
                                        ELSE '10'
                                    END
                                ) = p.pps_party_code
                            )
                        WHERE
                                vh.lvh_vchdstatus IN (
                                    'P','V'
                                )
                            AND
                                vh.lvh_vchddate <= '15-MAY-2019'

                      --and {?SUMMARY}={?SUMMARY}  AND {?REPORTTYPE}={?REPORTTYPE}
                            AND
                                TO_CHAR(
                                    vh.lvh_vchddate,
                                    'YYYY'
                                ) = '2019'
                            AND
                                coalesce(
                                    vh.lvh_vchdautomanual,
                                    'M'
                                ) IN (
                                    'A','M'
                                )
                            AND
                                vd.pca_glaccode IN (
                                    SELECT
                                        m_code
                                    FROM
                                        gias_prm_mapping
                                    WHERE
                                        m_type = 55
                                )
                            AND
                                p.pps_nature = 'C'

                      

--                      AND sd.plc_locacode BETWEEN {?BRANCHFROM} AND {?BRANCHTO} 

--                     

--and substring(p.pps_party_code,1,CASE '10' WHEN '0' THEN '20' ELSE '10' END) BETWEEN

--case {?CLIENTFROM} when 'All' then substring(p.pps_party_code,1,CASE '10' WHEN '0' THEN '20' ELSE '10' END)  else {?CLIENTFROM} end AND

--case {?CLIENTTO} when 'All' then substring(p.pps_party_code,1,CASE '10' WHEN '0' THEN '20' ELSE '10' END)  else {?CLIENTTO} end

--
                        GROUP BY
                            sd.psa_sactaccount,
                            p.pps_desc,
                            sd.plc_locacode
                        HAVING
                            ( SUM(coalesce(
                                sd.lsb_sdtlcramtbc,
                                0
                            ) ) - SUM(coalesce(
                                sd.lsb_sdtldramtbc,
                                0
                            ) ) ) <> 0
                    ) adv
                    INNER JOIN pr_gn_ps_party ins ON (
                            ins.pps_party_code = substring(
                                adv.client_code,
                                1,
                                CASE '10'
                                    WHEN '0'   THEN '20'
                                    ELSE '10'
                                END
                            )
                        AND
                            ins.pps_nature = 'C'
                    )
                    INNER JOIN pr_gn_lc_location br ON (
                        br.plc_locacode = adv.plc_locacode
                    )
                GROUP BY
                    adv.seq,
                    adv.client_code,
                    adv.pdt_doctype,
                    ins.pps_desc,
                    adv.plc_locacode,
                    br.plc_desc
            ) outstanding
        ORDER BY outstanding.seq
    )
GROUP BY
    plc_desc,
    pdp_desc,
    client;