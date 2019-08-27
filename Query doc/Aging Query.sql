/* Formatted on 2019/04/30 09:53 (Formatter Plus v4.8.8) */
SELECT   CAST (90 AS NUMBER) slabend1, CAST (180 AS NUMBER) slabend2,
         CAST (270 AS NUMBER) slabend3, CAST (360 AS NUMBER) slabend4,
         CAST (450 AS NUMBER) slabend5, 0 slabstart1, 90 + 1 slabstart2,
         180 + 1 slabstart3, 270 + 1 slabstart4, 360 + 1 slabstart5,
         (SELECT DISTINCT por_desc
                     FROM pr_gn_or_organization
                    WHERE por_org_code = '001001') cmpname,
         (SELECT DISTINCT pdp_desc
                     FROM pr_gn_dp_department) dep,
         (SELECT DISTINCT plc_desc
                     FROM pr_gn_lc_location) AS br_desc1,
         (SELECT DISTINCT plc_desc
                     FROM pr_gn_lc_location) AS br_desc2,
         (SELECT DISTINCT pps_desc
                     FROM pr_gn_ps_party) cl1, h.gis_registration_no,
         h.pdp_dept_code, h.gis_engine_no, h.gis_chassis_no,
         COALESCE (h.coinsurere, 'x') coinsurere, h.plc_loc_code AS br_code,
         h.zonecode, h.zonedesc, h.branch AS br_desc, h.piy_desc,
         h.pdp_dept_code AS pdp_code, h.pdp_dept_code,
         h.department AS pdp_desc, h.gih_oldclaim_no, h.gih_doc_ref_no,
         h.gih_documentno, h.gih_year, h.intimationno AS intimationno,
         h.gih_dateofloss AS dateofloss, h.poc_lossdesc AS lossdesc,
         h.gid_basedocumentno AS basedocno, h.client_code,
         h.insured AS insured, h.remarks, h.place, h.gid_commdate AS commdate,
         CASE 'N'
            WHEN 'G'
               THEN   COALESCE (h.gis_suminsured, 0)
                    * COALESCE (h.fc_rate, 1)
            ELSE COALESCE (h.gis_suminsured, 0)
         END AS suminsured,
         CASE 'N'
            WHEN 'G'
               THEN   COALESCE (h.totloss, 0)
                    * COALESCE (h.fc_rate, 1)
            ELSE COALESCE (h.totloss, 0)
         END AS totalloss,
         CASE 'N'
            WHEN 'G'
               THEN   COALESCE (h.totloss_os, 0)
                    * COALESCE (h.fc_rate, 1)
            ELSE COALESCE (h.totloss_os, 0)
         END AS totalloss_os,
         COALESCE (h.losspay, 0) AS losspay,
         COALESCE (h.suryorpay, 0) AS survpay,
         COALESCE (h.advocatepay, 0) AS advocatepay,
         COALESCE (salvage, 0) AS salvage, COALESCE (h.totalpaid,
                                                     0) totalpaid,
         COALESCE (h.totalpaid_os, 0) totalpaid_os,
         h.gih_intimationdate AS intimationdate, h.rev_date,
         h.gid_expirydate AS expiry, COALESCE (h.gic_share, 100) gic_share
    FROM (SELECT ihd.pdp_dept_code, ihd.gih_intimationdate, ihd.plc_loc_code,
                 gih_oldclaim_no oldclaimno, isubdtl.gis_sailing_date,
                 dh.gdh_as400_documentno, ihd.gih_oldclaim_no,
                 ihd.gih_doc_ref_no, ihd.gih_documentno, ihd.gih_year,
                 ZONE.plc_loc_code zonecode, ZONE.plc_desc zonedesc,
                 piy.piy_desc, COALESCE (ic.gic_share, 1) AS pshare,
                 ihd.gih_dateofloss, idtl.gid_basedocumentno,
                 COALESCE (cat.pce_desc, 'N') pce_desc,
                 ihd.gih_inti_entryno AS intimationno,
                 ihd.gih_remarks AS remarks, ihd.gih_placeoftheft place,
                 ihd.gih_revisiondate rev_date, lc.poc_lossdesc,
                 CASE
                    WHEN COALESCE (brcurr.plc_loc_code, 'N') <> 'N'
                       THEN COALESCE (ihd.gih_fc_exchrate, 1)
                    ELSE 1
                 END fc_rate,
                 idtl.gid_expirydate, COALESCE (ic.gic_share, 100) gic_share,
                 COALESCE (ihd.pps_party_code, 'None') client_code,
                 COALESCE (p.pps_desc, 'None') AS insured,
                 coi.pps_desc coinsurere, isubdtl.gis_registration_no,
                 isubdtl.gis_engine_no, isubdtl.gis_chassis_no,
                 dp.pdp_desc department, lc1.plc_locadesc AS branch,
                 CASE ihd.pdp_dept_code
                    WHEN '11'
                       THEN rs.prs_desc
                    WHEN '12'
                       THEN idtl.gvc_voyagecard_no
                    ELSE isubdtl.gis_working_location
                 END AS riskcode,
                 vc.pvc_desc, isubdtl.gis_subjectmatter,
                 isubdtl.gis_voyage_from, isubdtl.gis_voyage_to,
                 p.pps_pargpcode AS gp, idtl.gid_commdate,
                 CASE
                    WHEN 'N' = 'Y'
                    AND COALESCE (brcurr.plc_loc_code, 'N') <> 'N'
                       THEN   COALESCE (isubdtl.gis_suminsured, 0)
                            * COALESCE (ihd.gih_fc_exchrate, 1)
                    ELSE COALESCE (isubdtl.gis_suminsured, 0)
                 END AS gis_suminsured,
                 CASE
                    WHEN 'N' = 'Y'
                    AND COALESCE (brcurr.plc_loc_code, 'N') <> 'N'
                       THEN   (  (    CASE COALESCE (isubdtl.gis_lossadjusted,
                                                     0
                                                    )
                                         WHEN 0
                                            THEN CASE COALESCE
                                                        (isubdtl.gis_lossassessed,
                                                         0
                                                        )
                                                   WHEN 0
                                                      THEN CASE COALESCE
                                                                  (isubdtl.gis_lossclaimed,
                                                                   0
                                                                  )
                                                             WHEN 0
                                                                THEN 0
                                                             ELSE COALESCE
                                                                    (isubdtl.gis_lossclaimed,
                                                                     0
                                                                    )
                                                          END
                                                   ELSE COALESCE
                                                          (isubdtl.gis_lossassessed,
                                                           0
                                                          )
                                                END
                                         ELSE COALESCE
                                                    (isubdtl.gis_lossadjusted,
                                                     0
                                                    )
                                      END
                                    * CASE
                                         WHEN COALESCE (ihd.gih_noclaim_tag,
                                                        'V'
                                                       ) = 'N'
                                            THEN 0
                                         ELSE 1
                                      END
                                  + COALESCE (isubdtl.gis_surveyoramt, 0)
                                  + COALESCE (isubdtl.gis_advocateamt, 0)
                                  - CASE 'Y'
                                       WHEN 'Y'
                                          THEN COALESCE
                                                      (isubdtl.gis_salvageamt,
                                                       0
                                                      )
                                       ELSE 0
                                    END
                                 )
                               - (COALESCE (isubdtl.gis_salestaxamt, 0))
                              )
                            * COALESCE (ihd.gih_fc_exchrate, 1)
                    ELSE   (    CASE COALESCE (isubdtl.gis_lossadjusted, 0)
                                   WHEN 0
                                      THEN CASE COALESCE
                                                    (isubdtl.gis_lossassessed,
                                                     0
                                                    )
                                             WHEN 0
                                                THEN CASE COALESCE
                                                            (isubdtl.gis_lossclaimed,
                                                             0
                                                            )
                                                       WHEN 0
                                                          THEN 0
                                                       ELSE COALESCE
                                                              (isubdtl.gis_lossclaimed,
                                                               0
                                                              )
                                                    END
                                             ELSE COALESCE
                                                    (isubdtl.gis_lossassessed,
                                                     0
                                                    )
                                          END
                                   ELSE COALESCE (isubdtl.gis_lossadjusted, 0)
                                END
                              * CASE
                                   WHEN COALESCE (ihd.gih_noclaim_tag, 'V') =
                                                                           'N'
                                      THEN 0
                                   ELSE 1
                                END
                            + COALESCE (isubdtl.gis_surveyoramt, 0)
                            + COALESCE (isubdtl.gis_advocateamt, 0)
                            - CASE 'Y'
                                 WHEN 'Y'
                                    THEN COALESCE (isubdtl.gis_salvageamt, 0)
                                 ELSE 0
                              END
                           )
                         - (COALESCE (isubdtl.gis_salestaxamt, 0))
                 END AS totloss,
                 CASE
                    WHEN 'N' = 'Y'
                    AND COALESCE (brcurr.plc_loc_code, 'N') <> 'N'
                       THEN ((    CASE COALESCE (isubdtl.gis_lossadjusted, 0)
                                     WHEN 0
                                        THEN CASE COALESCE
                                                    (isubdtl.gis_lossassessed,
                                                     0
                                                    )
                                               WHEN 0
                                                  THEN CASE COALESCE
                                                              (isubdtl.gis_lossclaimed,
                                                               0
                                                              )
                                                         WHEN 0
                                                            THEN 0
                                                         ELSE COALESCE
                                                                (isubdtl.gis_lossclaimed,
                                                                 0
                                                                )
                                                      END
                                               ELSE COALESCE
                                                      (isubdtl.gis_lossassessed,
                                                       0
                                                      )
                                            END
                                     ELSE COALESCE (isubdtl.gis_lossadjusted,
                                                    0
                                                   )
                                  END
                                * CASE
                                     WHEN COALESCE (ihd.gih_noclaim_tag, 'V') =
                                                                           'N'
                                        THEN 0
                                     ELSE 1
                                  END
                              + COALESCE (isubdtl.gis_surveyoramt, 0)
                              + COALESCE (isubdtl.gis_advocateamt, 0)
                              - CASE 'Y'
                                   WHEN 'Y'
                                      THEN COALESCE (isubdtl.gis_salvageamt,
                                                     0)
                                   ELSE 0
                                END
                             )
                            )
                    ELSE (    CASE COALESCE (isubdtl.gis_lossadjusted, 0)
                                 WHEN 0
                                    THEN CASE COALESCE
                                                    (isubdtl.gis_lossassessed,
                                                     0
                                                    )
                                           WHEN 0
                                              THEN CASE COALESCE
                                                          (isubdtl.gis_lossclaimed,
                                                           0
                                                          )
                                                     WHEN 0
                                                        THEN 0
                                                     ELSE COALESCE
                                                            (isubdtl.gis_lossclaimed,
                                                             0
                                                            )
                                                  END
                                           ELSE COALESCE
                                                    (isubdtl.gis_lossassessed,
                                                     0
                                                    )
                                        END
                                 ELSE COALESCE (isubdtl.gis_lossadjusted, 0)
                              END
                            * CASE
                                 WHEN COALESCE (ihd.gih_noclaim_tag, 'V') =
                                                                           'N'
                                    THEN 0
                                 ELSE 1
                              END
                          + COALESCE (isubdtl.gis_surveyoramt, 0)
                          + COALESCE (isubdtl.gis_advocateamt, 0)
                          - CASE 'Y'
                               WHEN 'Y'
                                  THEN COALESCE (isubdtl.gis_salvageamt, 0)
                               ELSE 0
                            END
                         )
                 END AS totloss_os,
                 (losspay * CASE
                     WHEN gih_noclaim_tag = 'N'
                        THEN 0
                     ELSE 1
                  END
                 ) AS losspay,
                 (suryorpay) AS suryorpay, (advocatepay) AS advocatepay,
                 (CASE 'Y'
                     WHEN 'Y'
                        THEN salvage
                     ELSE 0
                  END) AS salvage,
                 CASE
                    WHEN 'N' = 'Y'
                       THEN COALESCE (losspaid, 0)
                    ELSE COALESCE (losspaid, 0)
                 END AS gsd_losspaid1,
                 CASE
                    WHEN 'N' = 'Y'
                       THEN (  losspay
                             + suryorpay
                             + advocatepay
                             + (CASE 'Y'
                                   WHEN 'Y'
                                      THEN salvage
                                   ELSE 0
                                END)
                            )
                    ELSE (  losspay
                          + suryorpay
                          + advocatepay
                          + (CASE 'Y'
                                WHEN 'Y'
                                   THEN salvage
                                ELSE 0
                             END)
                         )
                 END AS totalpaid,
                 (  losspay_foros
                  + suryorpay_our
                  + advocatepay_our
                  + (CASE 'Y'
                        WHEN 'Y'
                           THEN salvage_our
                        ELSE 0
                     END)
                 ) AS totalpaid_os
            FROM gi_gc_ih_intimationhd ihd
                 INNER JOIN
                 (SELECT   gih_doc_ref_no, MAX (gih_inti_entryno * 1) entryno
                      FROM gi_gc_ih_intimationhd
                     WHERE CASE gih_inti_entryno
                              WHEN '1'
                                 THEN gih_intimationdate
                              ELSE gih_revisiondate
                           END BETWEEN CASE 'O'
                                  WHEN 'P'
                                     THEN TO_DATE (gih_intimationdate)
                                  ELSE TO_DATE ('01-jan-2000')
                               END
                                   AND TO_DATE ('22-Apr-19')
                       AND gih_intimationdate BETWEEN '01-Jan-2000'
                                                  AND '22-Apr-2019'
                  GROUP BY gih_doc_ref_no) hd
                 ON (    hd.gih_doc_ref_no = ihd.gih_doc_ref_no
                     AND hd.entryno = ihd.gih_inti_entryno
                    )
                 LEFT OUTER JOIN gi_gc_id_intimationdtl idtl
                 ON (    ihd.por_org_code = idtl.por_org_code
                     AND ihd.plc_loc_code = idtl.plc_loc_code
                     AND ihd.pdp_dept_code = idtl.pdp_dept_code
                     AND ihd.pdt_doctype = idtl.pdt_doctype
                     AND ihd.gih_documentno = idtl.gih_documentno
                     AND ihd.gih_inti_entryno = idtl.gih_inti_entryno
                     AND ihd.gih_year = idtl.gih_year
                    )
                 LEFT OUTER JOIN pr_gc_oc_loss_cause lc
                 ON (    ihd.por_org_code = lc.por_org_code
                     AND ihd.pdp_dept_code = lc.pdp_dept_code
                     AND ihd.poc_losscode = lc.poc_losscode
                    )
                 INNER JOIN pr_gn_dp_department dp
                 ON (    ihd.plc_loc_code = dp.plc_loc_code
                     AND ihd.pdp_dept_code = dp.pdp_dept_code
                    )
                 LEFT OUTER JOIN gi_gu_dh_doc_header dh
                 ON (    idtl.gid_basedocumentno = dh.gdh_doc_reference_no
                     AND dh.gdh_record_type = 'O'
                    )
                 LEFT OUTER JOIN pr_gn_ps_party p
                 ON (ihd.pps_party_code = p.pps_party_code)
                 INNER JOIN pr_gn_lc_location ZONE
                 ON (ZONE.plc_loc_code =
                        SUBSTR (ihd.plc_loc_code,
                                1,
                                (SELECT SUM (ppl_width)
                                   FROM pr_gn_pl_paralevels a INNER JOIN pr_gn_pc_paracontrol b
                                        ON (b.ppc_para_type = a.ppc_para_type
                                           )
                                  WHERE b.ppc_para_type = 'LOC'
                                    AND a.ppl_lvl_type <= b.ppc_levels - 2)
                               )
                    )
                 LEFT OUTER JOIN pr_gn_lc_location lc1
                 ON (ihd.plc_loc_code = lc1.plc_loc_code)
                 INNER JOIN pr_gg_iy_insurancetype piy
                 ON (ihd.piy_insutype = piy.piy_insutype)
                 LEFT OUTER JOIN pr_gn_ps_party coi
                 ON (    coi.por_org_code = ihd.por_org_code
                     AND coi.pps_party_code = ihd.pps_insu_code
                    )
                 LEFT OUTER JOIN
                 (SELECT   por_org_code, plc_loc_code, pdp_dept_code,
                           pdt_doctype, gih_documentno, gid_ply_serialno,
                           gih_inti_entryno, gih_year, pco_ctry_code,
                           prs_risk_code, gis_working_location,
                           gis_sailing_date, gis_subjectmatter, pvc_code,
                           gis_voyage_from, gis_voyage_to,
                           gis_registration_no, gis_engine_no, gis_chassis_no,
                           SUM (COALESCE (gis_suminsured, 0)) gis_suminsured,
                           SUM (COALESCE (gis_lossclaimed, 0))
                                                              gis_lossclaimed,
                           SUM (COALESCE (gis_lossassessed, 0)
                               ) gis_lossassessed,
                           SUM (COALESCE (gis_lossadjusted, 0)
                               ) gis_lossadjusted,
                           SUM (COALESCE (gis_surveyoramt, 0))
                                                              gis_surveyoramt,
                           SUM (COALESCE (gis_advocateamt, 0))
                                                              gis_advocateamt,
                           SUM (COALESCE (gis_excessamount, 0)
                               ) gis_excessamount,
                           SUM (COALESCE (gis_salvageamt, 0)) gis_salvageamt,
                           SUM (COALESCE (gis_facultamount, 0)
                               ) gis_facultamount,
                           SUM
                              (COALESCE (gis_foreignfacult_amount, 0)
                              ) gis_foreignfacult_amount,
                           SUM (COALESCE (gis_conetamount, 0))
                                                              gis_conetamount,
                           SUM (COALESCE (gis_treatyamount, 0)
                               ) gis_treatyamount,
                           SUM (COALESCE (gis_picamount, 0)) gis_picamount,
                           COALESCE (SUM (gis_salestaxamt),
                                     0) gis_salestaxamt,
                           COALESCE
                                 (SUM (gis_co_salestaxamt),
                                  0
                                 ) gis_co_salestaxamt
                      FROM gi_gc_is_intimationsubdtl
                  GROUP BY por_org_code,
                           plc_loc_code,
                           pdp_dept_code,
                           pdt_doctype,
                           gih_documentno,
                           gid_ply_serialno,
                           gih_inti_entryno,
                           gih_year,
                           pco_ctry_code,
                           gis_sailing_date,
                           prs_risk_code,
                           gis_working_location,
                           gis_subjectmatter,
                           pvc_code,
                           gis_voyage_from,
                           gis_voyage_to,
                           gis_registration_no,
                           gis_engine_no,
                           gis_chassis_no) isubdtl
                 ON (    idtl.por_org_code = isubdtl.por_org_code
                     AND idtl.plc_loc_code = isubdtl.plc_loc_code
                     AND idtl.pdp_dept_code = isubdtl.pdp_dept_code
                     AND idtl.pdt_doctype = isubdtl.pdt_doctype
                     AND idtl.gih_documentno = isubdtl.gih_documentno
                     AND idtl.gih_inti_entryno = isubdtl.gih_inti_entryno
                     AND idtl.gih_year = isubdtl.gih_year
                     AND idtl.gid_ply_serialno = isubdtl.gid_ply_serialno
                    )
                 LEFT OUTER JOIN pr_gm_vc_vessel_classification vc
                 ON (isubdtl.pvc_code = vc.pvc_code)
                 LEFT OUTER JOIN pr_gg_rs_risk_location rs
                 ON (    isubdtl.prs_risk_code = rs.prs_risk_code
                     AND isubdtl.pco_ctry_code = rs.pco_ctry_code
                    )
                 LEFT OUTER JOIN gi_gc_ud_surveyordtl svd
                 ON (    ihd.por_org_code = svd.por_org_code
                     AND ihd.plc_loc_code = svd.plc_loc_code
                     AND ihd.pdp_dept_code = svd.pdp_dept_code
                     AND ihd.pdt_doctype = svd.pdt_doctype
                     AND ihd.gih_documentno = svd.gih_documentno
                     AND ihd.gih_inti_entryno = svd.gih_inti_entryno
                     AND ihd.gih_year = svd.gih_year
                     AND gud_serialno = 1
                    )
                 LEFT OUTER JOIN pr_gg_sr_surveyor sv
                 ON (svd.psr_surv_code = sv.psr_surv_code)
                 LEFT OUTER JOIN pr_gg_branchcurrency_mapping brcurr
                 ON (ihd.plc_loc_code = brcurr.plc_loc_code)
--PAYMENT DETAIL
                 LEFT OUTER JOIN
                 (SELECT   pd1.por_org_code, pd1.plc_loc_code,
                           pd1.pdp_dept_code, pd1.pdt_doctype,
                           pd1.gsh_postingtag, pd1.gih_documentno,
                           pd1.gih_year, gsd_serialno,
                           SUM (losspay) AS losspay,
                           SUM (losspay_foros) AS losspay_foros,
                           SUM (suryorpay_our) AS suryorpay_our,
                           SUM (advocatepay_our) AS advocatepay_our,
                           SUM (salvage_our) salvage_our,
                           SUM (suryorpay) AS suryorpay,
                           SUM (advocatepay) AS advocatepay,
                           SUM (salvage) salvage, SUM (treaty) losstreaty,
                           SUM (fac) lossfac,
                           SUM (foreign_fac) lossforeign_fac,
                           SUM (excess) lossexcess,
                           SUM (gsd_picamount) gsd_picamount,
                           SUM (paid) AS losspaid
                      FROM (SELECT shd.por_org_code, shd.plc_loc_code,
                                   shd.pdp_dept_code, shd.pdt_doctype,
                                   shd.gih_documentno, shd.gih_inti_entryno,
                                   shd.gih_year, sdtl.gsd_serialno,
                                   shd.gsh_postingtag,
                                   CASE pyy_code
                                      WHEN '01'
                                         THEN CASE
                                                WHEN 'N' = 'Y'
                                                AND COALESCE
                                                         (brcurr.plc_loc_code,
                                                          'N'
                                                         ) <> 'N'
                                                   THEN   (  COALESCE
                                                                (gsd_losspaid,
                                                                 0
                                                                )
                                                           - CASE
                                                                WHEN 'O' = 'O'
                                                                   THEN COALESCE
                                                                          (sdtl.gsd_salestax_amount,
                                                                           0
                                                                          )
                                                                ELSE 0
                                                             END
                                                          )
                                                        * COALESCE
                                                             (shd.gsh_fc_exchrate,
                                                              1
                                                             )
                                                ELSE   COALESCE (gsd_losspaid,
                                                                 0
                                                                )
                                                     - CASE
                                                          WHEN 'O' = 'O'
                                                             THEN COALESCE
                                                                    (sdtl.gsd_salestax_amount,
                                                                     0
                                                                    )
                                                          ELSE 0
                                                       END
                                             END
                                      ELSE 0
                                   END AS losspay,
                                   CASE pyy_code
                                      WHEN '02'
                                         THEN CASE
                                                WHEN 'N' = 'Y'
                                                AND COALESCE
                                                         (brcurr.plc_loc_code,
                                                          'N'
                                                         ) <> 'N'
                                                   THEN   (  COALESCE
                                                                (gsd_losspaid,
                                                                 0
                                                                )
                                                           - COALESCE
                                                                (sdtl.gsd_salestax_amount,
                                                                 0
                                                                )
                                                          )
                                                        * COALESCE
                                                             (shd.gsh_fc_exchrate,
                                                              1
                                                             )
                                                ELSE   COALESCE (gsd_losspaid,
                                                                 0
                                                                )
                                                     - COALESCE
                                                          (sdtl.gsd_salestax_amount,
                                                           0
                                                          )
                                             END
                                      ELSE 0
                                   END AS suryorpay,
                                   CASE pyy_code
                                      WHEN '03'
                                         THEN CASE
                                                WHEN 'N' = 'Y'
                                                AND COALESCE
                                                         (brcurr.plc_loc_code,
                                                          'N'
                                                         ) <> 'N'
                                                   THEN   (  COALESCE
                                                                (gsd_losspaid,
                                                                 0
                                                                )
                                                           - COALESCE
                                                                (sdtl.gsd_salestax_amount,
                                                                 0
                                                                )
                                                          )
                                                        * COALESCE
                                                             (shd.gsh_fc_exchrate,
                                                              1
                                                             )
                                                ELSE   COALESCE (gsd_losspaid,
                                                                 0
                                                                )
                                                     - COALESCE
                                                          (sdtl.gsd_salestax_amount,
                                                           0
                                                          )
                                             END
                                      ELSE 0
                                   END AS advocatepay,
                                   CASE pyy_code
                                      WHEN '04'
                                         THEN CASE
                                                WHEN 'N' = 'Y'
                                                AND COALESCE
                                                         (brcurr.plc_loc_code,
                                                          'N'
                                                         ) <> 'N'
                                                   THEN   (  (  COALESCE
                                                                   (gsd_losspaid,
                                                                    0
                                                                   )
                                                              - COALESCE
                                                                   (sdtl.gsd_salestax_amount,
                                                                    0
                                                                   )
                                                             )
                                                           * -1
                                                          )
                                                        * COALESCE
                                                             (shd.gsh_fc_exchrate,
                                                              1
                                                             )
                                                ELSE   (  COALESCE
                                                                (gsd_losspaid,
                                                                 0
                                                                )
                                                        - COALESCE
                                                             (sdtl.gsd_salestax_amount,
                                                              0
                                                             )
                                                       )
                                                     * -1
                                             END
                                      ELSE 0
                                   END AS salvage,
                                   CASE pyy_code
                                      WHEN '01'
                                         THEN CASE
                                                WHEN 'N' =
                                                         'Y'
                                                AND COALESCE
                                                         (brcurr.plc_loc_code,
                                                          'N'
                                                         ) <> 'N'
                                                   THEN (COALESCE
                                                                (gsd_losspaid,
                                                                 0
                                                                )
                                                        )
                                                ELSE COALESCE (gsd_losspaid,
                                                               0)
                                             END
                                      ELSE 0
                                   END AS losspay_foros,
                                   CASE pyy_code
                                      WHEN '02'
                                         THEN CASE
                                                WHEN 'N' =
                                                         'Y'
                                                AND COALESCE
                                                         (brcurr.plc_loc_code,
                                                          'N'
                                                         ) <> 'N'
                                                   THEN COALESCE
                                                                (gsd_losspaid,
                                                                 0
                                                                )
                                                ELSE COALESCE (gsd_losspaid,
                                                               0)
                                             END
                                      ELSE 0
                                   END AS suryorpay_our,
                                   CASE pyy_code
                                      WHEN '03'
                                         THEN CASE
                                                WHEN 'N' =
                                                       'Y'
                                                AND COALESCE
                                                         (brcurr.plc_loc_code,
                                                          'N'
                                                         ) <> 'N'
                                                   THEN COALESCE
                                                                (gsd_losspaid,
                                                                 0
                                                                )
                                                ELSE COALESCE (gsd_losspaid,
                                                               0)
                                             END
                                      ELSE 0
                                   END AS advocatepay_our,
                                   CASE pyy_code
                                      WHEN '04'
                                         THEN CASE
                                                WHEN 'N' = 'Y'
                                                AND COALESCE
                                                         (brcurr.plc_loc_code,
                                                          'N'
                                                         ) <> 'N'
                                                   THEN (  COALESCE
                                                                (gsd_losspaid,
                                                                 0
                                                                )
                                                         * -1
                                                        )
                                                ELSE   COALESCE (gsd_losspaid,
                                                                 0
                                                                )
                                                     * -1
                                             END
                                      ELSE 0
                                   END AS salvage_our,
                                     COALESCE (gsd_treatyamount, 0)
                                   * CASE pyy_code
                                        WHEN '04'
                                           THEN -1
                                        ELSE 1
                                     END treaty,
                                     COALESCE (gsd_facultamount, 0)
                                   * CASE pyy_code
                                        WHEN '04'
                                           THEN -1
                                        ELSE 1
                                     END fac,
                                     COALESCE
                                        (gsd_foreignfacult_amount,
                                         0
                                        )
                                   * CASE pyy_code
                                        WHEN '04'
                                           THEN -1
                                        ELSE 1
                                     END foreign_fac,
                                     COALESCE (gsd_picamount,
                                               0)
                                   * CASE pyy_code
                                        WHEN '04'
                                           THEN -1
                                        ELSE 1
                                     END gsd_picamount,
                                     COALESCE (gsd_excessamount, 0)
                                   * CASE pyy_code
                                        WHEN '04'
                                           THEN -1
                                        ELSE 1
                                     END excess,
                                     gsd_losspaid
                                   * CASE pyy_code
                                        WHEN '04'
                                           THEN -1
                                        ELSE 1
                                     END paid
                              FROM gi_gc_sh_settelmenthd shd INNER JOIN gi_gc_sd_settelmentdtl sdtl
                                   ON (    sdtl.por_org_code =
                                                              shd.por_org_code
                                       AND sdtl.plc_loc_code =
                                                              shd.plc_loc_code
                                       AND sdtl.pdp_dept_code =
                                                             shd.pdp_dept_code
                                       AND sdtl.pdt_doctype = shd.pdt_doctype
                                       AND sdtl.gih_documentno =
                                                            shd.gih_documentno
                                       AND sdtl.gih_inti_entryno =
                                                          shd.gih_inti_entryno
                                       AND sdtl.gih_year = shd.gih_year
                                       AND sdtl.gsh_entryno = shd.gsh_entryno
                                      )
                                   LEFT OUTER JOIN gi_gc_ic_intimation_coinsurer ic
                                   ON (    sdtl.por_org_code = ic.por_org_code
                                       AND sdtl.plc_loc_code = ic.plc_loc_code
                                       AND sdtl.pdp_dept_code =
                                                              ic.pdp_dept_code
                                       AND sdtl.pdt_doctype = ic.pdt_doctype
                                       AND sdtl.gih_documentno =
                                                             ic.gih_documentno
                                       AND sdtl.gih_inti_entryno =
                                                           ic.gih_inti_entryno
                                       AND sdtl.gih_year = ic.gih_year
                                       AND sdtl.gsd_basedocno =
                                                         ic.gic_basedocumentno
                                       AND ic.gic_coretag = 'C'
                                       AND ic.gic_leadertag = 'Y'
                                      )
                                   LEFT OUTER JOIN pr_gg_branchcurrency_mapping brcurr
                                   ON (shd.plc_loc_code = brcurr.plc_loc_code
                                      )
                             WHERE shd.pdp_dept_code = '13'
                               AND (   (    shd.gsh_settlementdate
                                               BETWEEN shd.gsh_settlementdate
                                                   AND '22-Apr-2019'
                                        AND 'O' <> 'P'
                                       )
                                    OR (    shd.gsh_settlementdate
                                               BETWEEN '01-Jan-2000'
                                                   AND '22-Apr-2019'
                                        AND 'O' = 'P'
                                       )
                                   )
                               AND COALESCE (shd.gsh_postingtag, 'N') =
                                      CASE 'Y'
                                         WHEN 'Y'
                                            THEN 'Y'
                                         WHEN 'N'
                                            THEN 'N'
                                         ELSE COALESCE (shd.gsh_postingtag,
                                                        'N'
                                                       )
                                      END) pd1
                  GROUP BY pd1.por_org_code,
                           pd1.plc_loc_code,
                           pd1.pdp_dept_code,
                           pd1.pdt_doctype,
                           pd1.gih_documentno,
                           pd1.gih_year,
                           gsd_serialno,
                           pd1.gsh_postingtag) pd
                 ON (    pd.por_org_code = ihd.por_org_code
                     AND pd.plc_loc_code = ihd.plc_loc_code
                     AND pd.pdp_dept_code = ihd.pdp_dept_code
                     AND pd.pdt_doctype = ihd.pdt_doctype
                     AND pd.gih_documentno = ihd.gih_documentno
                     AND pd.gih_year = ihd.gih_year
                     AND pd.gsd_serialno = idtl.gid_ply_serialno
                    )
                 LEFT OUTER JOIN gi_gc_ic_intimation_coinsurer ic
                 ON (    idtl.por_org_code = ic.por_org_code
                     AND idtl.plc_loc_code = ic.plc_loc_code
                     AND idtl.pdp_dept_code = ic.pdp_dept_code
                     AND idtl.pdt_doctype = ic.pdt_doctype
                     AND idtl.gih_documentno = ic.gih_documentno
                     AND idtl.gih_inti_entryno = ic.gih_inti_entryno
                     AND idtl.gih_year = ic.gih_year
                     AND idtl.gid_basedocumentno = ic.gic_basedocumentno
                     AND ic.gic_coretag = 'C'
                     AND ic.gic_leadertag = 'Y'
                    )
                 LEFT OUTER JOIN pr_gc_ce_catastrophic_events cat
                 ON (ihd.pce_code = cat.pce_code)
           WHERE
--   {?AGING}={?AGING}
--AND
--IHD.PLC_LOC_CODE between {?BRANCHFROM}  and {?BRANCHTO}
--and
--CASE {?INSFROM} WHEN 'All' then 1 else  CHARINDEX (iHd.PIY_INSUTYPE,{?INSFROM}) end >0
--AND
--ihd.PPS_PARTY_CODE BETWEEN CASE {?CLIENTFROM} WHEN 'All' THEN ihd.PPS_PARTY_CODE ELSE {?CLIENTFROM} END
--and
--CASE {?CLIENTTO} WHEN 'All' THEN ihd.PPS_PARTY_CODE ELSE {?CLIENTTO} END
--and
--{?SLINE}={?SLINE}
--and
                 CASE 'O'
                    WHEN 'I'
                       THEN COALESCE (ihd.gih_postingtag, 'N')
                    WHEN 'P'
                       THEN COALESCE (pd.gsh_postingtag, 'N')
                    ELSE COALESCE (ihd.gih_postingtag, 'N')
                 END =
                    CASE 'Y'
                       WHEN 'Y'
                          THEN 'Y'
                       WHEN 'N'
                          THEN 'N'
                       ELSE CASE 'O'
                       WHEN 'I'
                          THEN COALESCE (ihd.gih_postingtag, 'N')
                       WHEN 'P'
                          THEN COALESCE (pd.gsh_postingtag, 'N')
                       ELSE COALESCE (ihd.gih_postingtag, 'N')
                    END
                    END
             AND CASE ihd.pdp_dept_code
                    WHEN '12'
                       THEN '01-Jan-2000'
                    ELSE dh.gdh_commdate
                 END BETWEEN '01-Jan-2000' AND '22-Apr-2019'
             AND CASE 'O'
                    WHEN 'P'
                       THEN CASE 'Y'
                              WHEN 'Y'
                                 THEN COALESCE (ihd.gih_cancellationtag, 'N')
                              ELSE 'N'
                           END
                    ELSE COALESCE (ihd.gih_cancellationtag, 'N')
                 END =
                    CASE 'N'
                       WHEN 'Y'
                          THEN COALESCE (ihd.gih_cancellationtag, 'N')
                       ELSE 'N'
                    END
             AND NOT EXISTS (
                    SELECT 'x'
                      FROM gi_gc_ih_intimationhd
                     WHERE gih_doc_ref_no = ihd.gih_doc_ref_no
                       AND COALESCE (old_party_code, 'N') = 'net off pb cases'
                       AND netoff_date < '22-Apr-2019')) h
ORDER BY h.plc_loc_code,
         h.pdp_dept_code,
         substring (h.intimationno, 1, 4),
         substring (h.intimationno, len (h.intimationno) - 7, 8);