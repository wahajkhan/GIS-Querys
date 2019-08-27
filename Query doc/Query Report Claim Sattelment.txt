--CLAIM SETTLED COMPANY WISE
SELECT
    SUM(LOSS),
    SUM(SURV),
    SUM(ADV),
    SUM(SALV),
    SUM(OTH),
    SUM(GPDPAYEEAMOUNT) AS PAYEEAMT
FROM
    (
        SELECT
            SH.GSH_DOC_REF_NO
            || '-'
            || SH.GIH_INTI_ENTRYNO
            || '-'
            || PD.GSH_ENTRYNO SETTLEMENTNO,
            CASE
                WHEN PD.GPD_PAYMENT_TYPE = '01'   THEN COALESCE(PD.GPD_PAYEE_AMOUNT, 0)
                ELSE 0
            END AS LOSS,
            CASE
                WHEN PD.GPD_PAYMENT_TYPE = '02'   THEN COALESCE(PD.GPD_PAYEE_AMOUNT, 0)
                ELSE 0
            END AS SURV,
            CASE
                WHEN PD.GPD_PAYMENT_TYPE = '03'   THEN COALESCE(PD.GPD_PAYEE_AMOUNT, 0)
                ELSE 0
            END AS ADV,
            CASE
                WHEN PD.GPD_PAYMENT_TYPE = '04'   THEN COALESCE(PD.GPD_PAYEE_AMOUNT, 0)
                ELSE 0
            END AS SALV,
            CASE
                WHEN PD.GPD_PAYMENT_TYPE = '06'   THEN COALESCE(PD.GPD_PAYEE_AMOUNT, 0)
                ELSE 0
            END AS OTH,
            CASE
                WHEN PD.GPD_PAYMENT_TYPE = '04'   THEN COALESCE(PD.GPD_PAYEE_AMOUNT, 0) * - 1
                ELSE COALESCE(PD.GPD_PAYEE_AMOUNT, 0)
            END AS GPDPAYEEAMOUNT
        FROM
            GI_GC_PD_PAYMENT_DETAIL PD
            INNER JOIN GI_GC_SH_SETTELMENTHD SH ON ( PD.POR_ORG_CODE = SH.POR_ORG_CODE
                                                     AND PD.PLC_LOC_CODE = SH.PLC_LOC_CODE
                                                     AND PD.PDP_DEPT_CODE = SH.PDP_DEPT_CODE
                                                     AND PD.PDT_DOCTYPE = SH.PDT_DOCTYPE
                                                     AND PD.GIH_DOCUMENTNO = SH.GIH_DOCUMENTNO
                                                     AND PD.GIH_INTI_ENTRYNO = SH.GIH_INTI_ENTRYNO
                                                     AND PD.GIH_YEAR = SH.GIH_YEAR
                                                     AND PD.GSH_ENTRYNO = SH.GSH_ENTRYNO )
            INNER JOIN GI_GC_IH_INTIMATIONHD IH ON ( IH.POR_ORG_CODE = SH.POR_ORG_CODE
                                                     AND IH.PLC_LOC_CODE = SH.PLC_LOC_CODE
                                                     AND IH.PDP_DEPT_CODE = SH.PDP_DEPT_CODE
                                                     AND IH.GIH_DOCUMENTNO = SH.GIH_DOCUMENTNO
                                                     AND IH.GIH_INTI_ENTRYNO = SH.GIH_INTI_ENTRYNO
                                                     AND IH.GIH_YEAR = SH.GIH_YEAR )
            LEFT OUTER JOIN GI_GC_ID_INTIMATIONDTL IDTL ON ( IH.POR_ORG_CODE = IDTL.POR_ORG_CODE
                                                             AND IH.PLC_LOC_CODE = IDTL.PLC_LOC_CODE
                                                             AND IH.PDP_DEPT_CODE = IDTL.PDP_DEPT_CODE
                                                             AND IH.PDT_DOCTYPE = IDTL.PDT_DOCTYPE
                                                             AND IH.GIH_DOCUMENTNO = IDTL.GIH_DOCUMENTNO
                                                             AND IH.GIH_INTI_ENTRYNO = IDTL.GIH_INTI_ENTRYNO
                                                             AND IH.GIH_YEAR = IDTL.GIH_YEAR
                                                             AND IDTL.GID_PLY_SERIALNO = 1 )
            LEFT OUTER JOIN (
                SELECT
                    POR_ORG_CODE,
                    PLC_LOC_CODE,
                    PDP_DEPT_CODE,
                    PDT_DOCTYPE,
                    GIH_DOCUMENTNO,
                    GID_PLY_SERIALNO,
                    GIH_INTI_ENTRYNO,
                    GIH_YEAR,
                    PCO_CTRY_CODE,
                    PRS_RISK_CODE,
                    GIS_WORKING_LOCATION,
                    GIS_REGISTRATION_NO,
                    GIS_ENGINE_NO,
                    GIS_CHASSIS_NO,
                    GIS_ITEMNO,
                    PMK_DESC,
                    GIS_VOYAGE_FROM,
                    GIS_VOYAGE_TO,
                    GIS_ITEM_DESC,
                    SUM(COALESCE(GIS_SUMINSURED, 0)) GIS_SUMINSURED,
                    SUM(COALESCE(GIS_LOSSCLAIMED, 0)) GIS_LOSSCLAIMED,
                    SUM(COALESCE(GIS_LOSSASSESSED, 0)) GIS_LOSSASSESSED,
                    SUM(COALESCE(GIS_LOSSADJUSTED, 0)) GIS_LOSSADJUSTED,
                    SUM(COALESCE(GIS_SURVEYORAMT, 0)) GIS_SURVEYORAMT,
                    SUM(COALESCE(GIS_ADVOCATEAMT, 0)) GIS_ADVOCATEAMT,
                    SUM(COALESCE(GIS_EXCESSAMOUNT, 0)) GIS_EXCESSAMOUNT,
                    SUM(COALESCE(GIS_SALVAGEAMT, 0)) GIS_SALVAGEAMT,
                    SUM(COALESCE(GIS_FACULTAMOUNT, 0)) GIS_FACULTAMOUNT,
                    SUM(COALESCE(GIS_FOREIGNFACULT_AMOUNT, 0)) GIS_FOREIGNFACULT_AMOUNT,
                    SUM(COALESCE(GIS_CONETAMOUNT, 0)) GIS_CONETAMOUNT,
                    SUM(COALESCE(GIS_TREATYAMOUNT, 0)) GIS_TREATYAMOUNT
                FROM
                    GI_GC_IS_INTIMATIONSUBDTL ISB
                    LEFT OUTER JOIN PR_GT_MK_MAKE MK ON ( ISB.PMK_MAKE_CODE = MK.PMK_MAKE_CODE )
                GROUP BY
                    POR_ORG_CODE,
                    PLC_LOC_CODE,
                    PDP_DEPT_CODE,
                    PDT_DOCTYPE,
                    GIH_DOCUMENTNO,
                    GID_PLY_SERIALNO,
                    GIH_INTI_ENTRYNO,
                    GIH_YEAR,
                    PCO_CTRY_CODE,
                    PRS_RISK_CODE,
                    GIS_WORKING_LOCATION,
                    GIS_REGISTRATION_NO,
                    GIS_ENGINE_NO,
                    GIS_CHASSIS_NO,
                    PMK_DESC,
                    GIS_VOYAGE_FROM,
                    GIS_VOYAGE_TO,
                    GIS_ITEM_DESC,
                    GIS_ITEMNO
            ) ISUBDTL ON ( IDTL.POR_ORG_CODE = ISUBDTL.POR_ORG_CODE
                           AND IDTL.PLC_LOC_CODE = ISUBDTL.PLC_LOC_CODE
                           AND IDTL.PDP_DEPT_CODE = ISUBDTL.PDP_DEPT_CODE
                           AND IDTL.PDT_DOCTYPE = ISUBDTL.PDT_DOCTYPE
                           AND IDTL.GIH_DOCUMENTNO = ISUBDTL.GIH_DOCUMENTNO
                           AND IDTL.GIH_INTI_ENTRYNO = ISUBDTL.GIH_INTI_ENTRYNO
                           AND IDTL.GIH_YEAR = ISUBDTL.GIH_YEAR
                           AND IDTL.GID_PLY_SERIALNO = ISUBDTL.GID_PLY_SERIALNO
                           AND IDTL.GID_ITEMNOS = ISUBDTL.GIS_ITEMNO )
            LEFT OUTER JOIN GI_GU_DH_DOC_HEADER H ON ( IDTL.GID_BASEDOCUMENTNO = H.GDH_DOC_REFERENCE_NO
                                                       AND H.GDH_RECORD_TYPE = 'O' )
            LEFT OUTER JOIN GI_GU_AD_AGENCYDTL AG ON ( H.POR_ORG_CODE = AG.POR_ORG_CODE
                                                       AND H.PLC_LOC_CODE = AG.PLC_LOC_CODE
                                                       AND H.PDP_DEPT_CODE = AG.PDP_DEPT_CODE
                                                       AND H.PBC_BUSICLASS_CODE = AG.PBC_BUSICLASS_CODE
                                                       AND H.PIY_INSUTYPE = AG.PIY_INSUTYPE
                                                       AND H.PDT_DOCTYPE = AG.PDT_DOCTYPE
                                                       AND H.GDH_DOCUMENTNO = AG.GDH_DOCUMENTNO
                                                       AND H.GDH_RECORD_TYPE = AG.GDH_RECORD_TYPE
                                                       AND H.GDH_YEAR = AG.GDH_YEAR
                                                       AND AG.GAD_SERIALNO = 1 )
            LEFT OUTER JOIN GI_GR_VC_VOYAGE_CARD VC ON ( VC.GVC_POLICYNO = IDTL.GID_BASEDOCUMENTNO
                                                         AND VC.GVC_VOYAGECARD_NO = IDTL.GVC_VOYAGECARD_NO
                                                         AND VC.GVC_ITEMNO = IDTL.GID_ITEMNOS )
        WHERE
            SH.GSH_SETTLEMENTDATE BETWEEN '01-jan-2018' AND '31-DEC-2018'
            AND COALESCE(SH.GSH_POSTINGTAG, 'N') IN (
                CASE 'Y'
                    WHEN 'Y'   THEN 'Y'
                    WHEN 'N'   THEN 'N'
                    ELSE COALESCE(SH.GSH_POSTINGTAG, 'N')
                END
            )
    );


-- CLAIM INTIAMTION COMPANY WISE

SELECT
    COUNT(INTIMATIONNO),
    COALESCE(SUM(LOSS), 0) LOSS,
    COALESCE(SUM(SURV_FEES), 0) SURVYFEE,
    COALESCE(SUM(RECOVERY), 0) RECOV,
    COALESCE(SUM(ADV_FEES), 0) ADVFEES,
    ( COALESCE(SUM(LOSS), 0) + COALESCE(SUM(SURV_FEES), 0) + COALESCE(SUM(ADV_FEES), 0) ) - COALESCE(SUM(RECOVERY), 0) AS NETLOSS
FROM
    (
        SELECT
            L_LOSS.POR_ORG_CODE,
            L_LOSS.PLC_LOC_CODE,
            L_LOSS.PDP_DEPT_CODE,
            L_LOSS.PDT_DOCTYPE,
            L_LOSS.GIH_DOCUMENTNO,
            L_LOSS.GIH_INTI_ENTRYNO,
            L_LOSS.GIH_YEAR,
            L_LOSS.GIH_DOC_REF_NO     INTIMATIONNO,
            IDTL.GID_BASEDOCUMENTNO   POLICYNO,
            L_LOSS.PPS_PARTY_CODE,
            (
                SELECT
                    POR_ORGADESC
                FROM
                    PR_GN_OR_ORGANIZATION BR
                WHERE
                    BR.POR_ORG_CODE = L_LOSS.POR_ORG_CODE
            ) ORGAN,
            (
                SELECT
                    PLC_LOCADESC
                FROM
                    PR_GN_LC_LOCATION BR
                WHERE
                    BR.POR_ORG_CODE = L_LOSS.POR_ORG_CODE
                    AND BR.PLC_LOC_CODE = L_LOSS.PLC_LOC_CODE
            ) BR,
            (
                SELECT
                    PDP_DEPTDESC
                FROM
                    PR_GN_DP_DEPARTMENT DPT
                WHERE
                    DPT.POR_ORG_CODE = L_LOSS.POR_ORG_CODE
                    AND DPT.PLC_LOC_CODE = L_LOSS.PLC_LOC_CODE
                    AND DPT.PDP_DEPT_CODE = L_LOSS.PDP_DEPT_CODE
            ) DEPTT,
            (
                SELECT
                    PPS_SHORT_DESC
                FROM
                    PR_GN_PS_PARTY CUST
                WHERE
                    CUST.PPS_PARTY_CODE = L_LOSS.PPS_PARTY_CODE
            ) CLIENT,
            (
                SELECT
                    POC_LOSSDESC
                FROM
                    PR_GC_OC_LOSS_CAUSE LOSS
                WHERE
                    LOSS.POR_ORG_CODE = L_LOSS.POR_ORG_CODE
                    AND LOSS.PDP_DEPT_CODE = L_LOSS.PDP_DEPT_CODE
                    AND LOSS.POC_LOSSCODE = L_LOSS.POC_LOSSCODE
            ) LOSS_TYPE,
            L_LOSS.GIH_DATEOFLOSS,
            L_LOSS.GIH_INTIMATIONDATE,
            L_LOSS.GIH_REVISIONDATE,
            CASE
                WHEN L_LOSS.GIH_REVISIONDATE IS NULL THEN L_LOSS.GIH_INTIMATIONDATE
                ELSE L_LOSS.GIH_REVISIONDATE
            END TRANS_DATE,
            CASE
                WHEN L_LOSS.GIH_NOCLAIM_TAG IS NULL
                     OR L_LOSS.GIH_NOCLAIM_TAG = 'N' THEN 0
                ELSE CASE
                    WHEN COALESCE(L_LOSS.GIH_LOSSADJUSTED, 0) <> 0 THEN COALESCE(L_LOSS.GIH_LOSSADJUSTED, 0)
                    ELSE CASE
                        WHEN COALESCE(L_LOSS.GIH_LOSSASSESSED, 0) <> 0 THEN COALESCE(L_LOSS.GIH_LOSSASSESSED, 0)
                        ELSE COALESCE(L_LOSS.GIH_LOSSCLAIMED, 0)
                    END
                END
            END LOSS,
            (
                SELECT
                    MAX(CASE
                        WHEN COALESCE(A.GIH_LOSSADJUSTED, 0) <> 0 THEN COALESCE(A.GIH_LOSSADJUSTED, 0)
                        ELSE CASE
                            WHEN COALESCE(A.GIH_LOSSASSESSED, 0) <> 0 THEN COALESCE(A.GIH_LOSSASSESSED, 0)
                            ELSE COALESCE(A.GIH_LOSSCLAIMED, 0)
                        END
                    END)
                FROM
                    GI_GC_IH_INTIMATIONHD A
                WHERE
                    A.POR_ORG_CODE = L_LOSS.POR_ORG_CODE
                    AND A.PLC_LOC_CODE = L_LOSS.PLC_LOC_CODE
                    AND A.PDP_DEPT_CODE = L_LOSS.PDP_DEPT_CODE
                    AND A.GIH_DOCUMENTNO = L_LOSS.GIH_DOCUMENTNO
                    AND L_LOSS.GIH_INTI_ENTRYNO - 1 = A.GIH_INTI_ENTRYNO
                    AND A.GIH_YEAR = L_LOSS.GIH_YEAR
            ) PREVIOUS_LOSS,
            (
                SELECT
                    SUM(NVL(GSB_SALVAGE_AMOUNT, 0))
                FROM
                    GI_GC_SB_SALVAGEBREAKUP D
                WHERE
                    D.POR_ORG_CODE = L_LOSS.POR_ORG_CODE
                    AND D.PLC_LOC_CODE = L_LOSS.PLC_LOC_CODE
                    AND D.PDP_DEPT_CODE = L_LOSS.PDP_DEPT_CODE
                    AND D.GIH_DOCUMENTNO = L_LOSS.GIH_DOCUMENTNO
                    AND L_LOSS.GIH_INTI_ENTRYNO = D.GIH_INTI_ENTRYNO
                    AND D.GIH_YEAR = L_LOSS.GIH_YEAR
            ) AS RECOVERY,
            (
                SELECT
                    SUM(NVL(GSB_SALVAGE_AMOUNT, 0))
                FROM
                    GI_GC_SB_SALVAGEBREAKUP D
                WHERE
                    D.POR_ORG_CODE = L_LOSS.POR_ORG_CODE
                    AND D.PLC_LOC_CODE = L_LOSS.PLC_LOC_CODE
                    AND D.PDP_DEPT_CODE = L_LOSS.PDP_DEPT_CODE
                    AND D.GIH_DOCUMENTNO = L_LOSS.GIH_DOCUMENTNO
                    AND L_LOSS.GIH_INTI_ENTRYNO - 1 = D.GIH_INTI_ENTRYNO
                    AND D.GIH_YEAR = L_LOSS.GIH_YEAR
            ) AS PRV_RECOVERY,
            (
                SELECT
                    MAX(COALESCE(GUD_SURVEYFEECLAIMED, 0) + COALESCE(GUD_OTHERCHARGES, 0))
                FROM
                    GI_GC_UD_SURVEYORDTL B
                WHERE
                    B.POR_ORG_CODE = L_LOSS.POR_ORG_CODE
                    AND B.PLC_LOC_CODE = L_LOSS.PLC_LOC_CODE
                    AND B.PDP_DEPT_CODE = L_LOSS.PDP_DEPT_CODE
                    AND B.GIH_DOCUMENTNO = L_LOSS.GIH_DOCUMENTNO
                    AND L_LOSS.GIH_INTI_ENTRYNO = B.GIH_INTI_ENTRYNO
                    AND B.GIH_YEAR = L_LOSS.GIH_YEAR
            ) SURV_FEES,
            (
                SELECT
                    MAX(COALESCE(GUD_SURVEYFEECLAIMED, 0) + COALESCE(GUD_OTHERCHARGES, 0))
                FROM
                    GI_GC_UD_SURVEYORDTL B
                WHERE
                    B.POR_ORG_CODE = L_LOSS.POR_ORG_CODE
                    AND B.PLC_LOC_CODE = L_LOSS.PLC_LOC_CODE
                    AND B.PDP_DEPT_CODE = L_LOSS.PDP_DEPT_CODE
                    AND B.GIH_DOCUMENTNO = L_LOSS.GIH_DOCUMENTNO
                    AND L_LOSS.GIH_INTI_ENTRYNO - 1 = B.GIH_INTI_ENTRYNO
                    AND B.GIH_YEAR = L_LOSS.GIH_YEAR
            ) AS PREVIOUS_SURV_FEES,
            (
                SELECT
                    MAX(COALESCE(GVD_AMTCLAIMED, 0))
                FROM
                    GI_GC_VD_ADVOCATEDTL C
                WHERE
                    C.POR_ORG_CODE = L_LOSS.POR_ORG_CODE
                    AND C.PLC_LOC_CODE = L_LOSS.PLC_LOC_CODE
                    AND C.PDP_DEPT_CODE = L_LOSS.PDP_DEPT_CODE
                    AND C.GIH_DOCUMENTNO = L_LOSS.GIH_DOCUMENTNO
                    AND L_LOSS.GIH_INTI_ENTRYNO = C.GIH_INTI_ENTRYNO
                    AND C.GIH_YEAR = L_LOSS.GIH_YEAR
            ) AS ADV_FEES,
            (
                SELECT
                    MAX(COALESCE(GVD_AMTCLAIMED, 0))
                FROM
                    GI_GC_VD_ADVOCATEDTL D
                WHERE
                    D.POR_ORG_CODE = L_LOSS.POR_ORG_CODE
                    AND D.PLC_LOC_CODE = L_LOSS.PLC_LOC_CODE
                    AND D.PDP_DEPT_CODE = L_LOSS.PDP_DEPT_CODE
                    AND D.GIH_DOCUMENTNO = L_LOSS.GIH_DOCUMENTNO
                    AND L_LOSS.GIH_INTI_ENTRYNO - 1 = D.GIH_INTI_ENTRYNO
                    AND D.GIH_YEAR = L_LOSS.GIH_YEAR
            ) AS PREVIOUS_ADV_FEES
        FROM
            GI_GC_IH_INTIMATIONHD L_LOSS
            LEFT OUTER JOIN GI_GC_ID_INTIMATIONDTL IDTL ON ( IDTL.POR_ORG_CODE = L_LOSS.POR_ORG_CODE
                                                             AND IDTL.PLC_LOC_CODE = L_LOSS.PLC_LOC_CODE
                                                             AND IDTL.PDP_DEPT_CODE = L_LOSS.PDP_DEPT_CODE
                                                             AND IDTL.GIH_DOCUMENTNO = L_LOSS.GIH_DOCUMENTNO
                                                             AND L_LOSS.GIH_INTI_ENTRYNO - 1 = IDTL.GIH_INTI_ENTRYNO
                                                             AND IDTL.GIH_YEAR = L_LOSS.GIH_YEAR )
        WHERE
            GIH_INTIMATIONDATE BETWEEN '01-JAN-2018' AND '31-DEC-2018'
            AND GIH_POSTINGTAG = 'Y'
            AND GIH_NOCLAIM_TAG = 'V'
            AND ( COALESCE(L_LOSS.GIH_CANCELLATIONTAG, 'NO') = 'NO'
                  OR L_LOSS.GIH_CANCELLATIONTAG = '' )
            AND L_LOSS.GIH_INTI_ENTRYNO = (
                SELECT
                    MAX(GIH_INTI_ENTRYNO)
                FROM
                    GI_GC_IH_INTIMATIONHD
                WHERE
                    GIH_DOC_REF_NO = L_LOSS.GIH_DOC_REF_NO
            )
    );


-- CLAIM PAID

SELECT
    SUM(KNOCKOFF) CLAIMPAID
FROM
    (
        SELECT
            (
                SELECT DISTINCT
                    POR_DESC
                FROM
                    PR_GN_OR_ORGANIZATION
                WHERE
                    POR_ORG_CODE = '001001'
            ) CMPNAME,
            CASE
                WHEN ( ( COALESCE(SH.GSH_SURV_OURSHARE, 'N') = 'Y'
                         AND B.PSP_STYPCODE = '0007' )
                       OR ( COALESCE(SH.GSH_ADVOCATE_OURSHARE, 'N') = 'Y'
                            AND B.PSP_STYPCODE = '0008' )
                       OR ( COALESCE(SH.GSH_LOSS_OURSHARE, 'N') = 'Y'
                            AND B.PSP_STYPCODE NOT IN (
                    '0007',
                    '0008'
                ) ) ) THEN 100
                ELSE COALESCE(IC.GIC_SHARE, 100)
            END GIC_SHARE,
            ISUBDTL.GIS_SAILING_DATE,
            COALESCE(STX.PAYEE_NAME, 'N/A') PAYEENAME,
            COALESCE(SV.PSR_SURV_NAME, 'None') PSR_SURV_NAME,
            B.VCHDATE,
            B.CLMREF,
            IH.GIH_INTI_ENTRYNO,
            COALESCE(B.KNOCKOFFAMOUNT, 0) KNOCKOFF,
            B.PPF_PRFCCODE,
            B.PLC_LOCACODE,
            B.PVT_VCHTTYPE,
            B.LVH_VCHDNO,
            IH.GIH_OLDCLAIM_NO,
            PIY.PIY_DESC,
            IH.GIH_INTIMATIONDATE,
            IDTL.GID_BASEDOCUMENTNO   POLICYNO,
            IDTL.GID_COMMDATE,
            IDTL.GID_EXPIRYDATE,
            IDTL.GID_ISSUEDATE,
            COALESCE(ISUBDTL.GIS_REGISTRATION_NO, 'N/A') REGNO,
            COALESCE(ISUBDTL.GIS_ENGINE_NO, 'N/A') ENGINENO,
            COALESCE(ISUBDTL.GIS_CHASSIS_NO, 'N/A') CHASSIS,
            COALESCE(X.TLOSS, 0) AS TLOSS,
            SV.PSR_SURV_NAME,
            CASE COALESCE(ISUBDTL.GIS_LOSSADJUSTED, 0)
                WHEN 0   THEN CASE COALESCE(ISUBDTL.GIS_LOSSASSESSED, 0)
                    WHEN 0   THEN CASE COALESCE(ISUBDTL.GIS_LOSSCLAIMED, 0)
                        WHEN 0   THEN 0
                        ELSE COALESCE(ISUBDTL.GIS_LOSSCLAIMED, 0)
                    END
                    ELSE COALESCE(ISUBDTL.GIS_LOSSASSESSED, 0)
                END
                ELSE COALESCE(ISUBDTL.GIS_LOSSADJUSTED, 0)
            END * CASE
                WHEN COALESCE(IH.GIH_NOCLAIM_TAG, 'V') = 'N' THEN 0
                ELSE 1
            END + COALESCE(ISUBDTL.GIS_SURVEYORAMT, 0) + COALESCE(ISUBDTL.GIS_ADVOCATEAMT, 0) - COALESCE(ISUBDTL.GIS_SALVAGEAMT, 0
            ) AS LOSS,
            COALESCE(ISUBDTL.GIS_SUMINSURED, 0) GIS_SUMINSURED,
            ( COALESCE(ISUBDTL.GIS_LOSSCLAIMED, 0) ) GIS_LOSSCLAIMED,
            ( COALESCE(ISUBDTL.GIS_LOSSASSESSED, 0) ) GIS_LOSSASSESSED,
            ( COALESCE(ISUBDTL.GIS_LOSSADJUSTED, 0) ) GIS_LOSSADJUSTED,
            ( COALESCE(ISUBDTL.GIS_SURVEYORAMT, 0) ) GIS_SURVEYORAMT,
            ( COALESCE(ISUBDTL.GIS_ADVOCATEAMT, 0) ) GIS_ADVOCATEAMT,
            ( COALESCE(ISUBDTL.GIS_EXCESSAMOUNT, 0) ) GIS_EXCESSAMOUNT,
            ( COALESCE(ISUBDTL.GIS_SALVAGEAMT, 0) ) GIS_SALVAGEAMT,
            ( COALESCE(ISUBDTL.GIS_FACULTAMOUNT, 0) ) GIS_FACULTAMOUNT,
            ( COALESCE(ISUBDTL.GIS_FOREIGNFACULT_AMOUNT, 0) ) GIS_FOREIGNFACULT_AMOUNT,
            ( COALESCE(ISUBDTL.GIS_CONETAMOUNT, 0) ) GIS_CONETAMOUNT,
            ( COALESCE(ISUBDTL.GIS_TREATYAMOUNT, 0) ) GIS_TREATYAMOUNT,
            COALESCE(H.GDH_AS400_DOCUMENTNO, 'X') OLD_DOCUMENTNO,
            IH.GIH_REVISIONDATE,
            B.CHECK_NO,
            B.CHECK_DATE,
            IH.GIH_DATEOFLOSS,
            IH.PPS_PARTY_CODE,
            CL.POC_LOSSDESC,
            PP.PPS_DESC,
            DP.PDP_DESC,
            LC.PLC_DESC,
            B.SETT_NO
        FROM
            GI_GC_IH_INTIMATIONHD IH
            INNER JOIN GI_GC_ID_INTIMATIONDTL IDTL ON ( IH.POR_ORG_CODE = IDTL.POR_ORG_CODE
                                                        AND IH.PLC_LOC_CODE = IDTL.PLC_LOC_CODE
                                                        AND IH.PDP_DEPT_CODE = IDTL.PDP_DEPT_CODE
                                                        AND IH.PDT_DOCTYPE = IDTL.PDT_DOCTYPE
                                                        AND IH.GIH_DOCUMENTNO = IDTL.GIH_DOCUMENTNO
                                                        AND IH.GIH_INTI_ENTRYNO = IDTL.GIH_INTI_ENTRYNO
                                                        AND IH.GIH_YEAR = IDTL.GIH_YEAR )
            INNER JOIN PR_GG_IY_INSURANCETYPE PIY ON ( IH.PIY_INSUTYPE = PIY.PIY_INSUTYPE )
            LEFT OUTER JOIN (
                SELECT
                    POR_ORG_CODE,
                    PLC_LOC_CODE,
                    PDP_DEPT_CODE,
                    PDT_DOCTYPE,
                    GIH_DOCUMENTNO,
                    GID_PLY_SERIALNO,
                    GIH_INTI_ENTRYNO,
                    GIH_YEAR,
                    GIS_SAILING_DATE,
                    GIS_REGISTRATION_NO,
                    GIS_ENGINE_NO,
                    GIS_CHASSIS_NO,
                    SUM(COALESCE(GIS_SUMINSURED, 0)) GIS_SUMINSURED,
                    SUM(COALESCE(GIS_LOSSCLAIMED, 0)) GIS_LOSSCLAIMED,
                    SUM(COALESCE(GIS_LOSSASSESSED, 0)) GIS_LOSSASSESSED,
                    SUM(COALESCE(GIS_LOSSADJUSTED, 0)) GIS_LOSSADJUSTED,
                    SUM(COALESCE(GIS_SURVEYORAMT, 0)) GIS_SURVEYORAMT,
                    SUM(COALESCE(GIS_ADVOCATEAMT, 0)) GIS_ADVOCATEAMT,
                    SUM(COALESCE(GIS_EXCESSAMOUNT, 0)) GIS_EXCESSAMOUNT,
                    SUM(COALESCE(GIS_SALVAGEAMT, 0)) GIS_SALVAGEAMT,
                    SUM(COALESCE(GIS_FACULTAMOUNT, 0)) GIS_FACULTAMOUNT,
                    SUM(COALESCE(GIS_FOREIGNFACULT_AMOUNT, 0)) GIS_FOREIGNFACULT_AMOUNT,
                    SUM(COALESCE(GIS_CONETAMOUNT, 0)) GIS_CONETAMOUNT,
                    SUM(COALESCE(GIS_TREATYAMOUNT, 0)) GIS_TREATYAMOUNT
                FROM
                    GI_GC_IS_INTIMATIONSUBDTL
                GROUP BY
                    POR_ORG_CODE,
                    PLC_LOC_CODE,
                    PDP_DEPT_CODE,
                    PDT_DOCTYPE,
                    GIH_DOCUMENTNO,
                    GID_PLY_SERIALNO,
                    GIH_INTI_ENTRYNO,
                    GIH_YEAR,
                    GIS_SAILING_DATE,
                    GIS_REGISTRATION_NO,
                    GIS_ENGINE_NO,
                    GIS_CHASSIS_NO
            ) ISUBDTL ON ( IDTL.POR_ORG_CODE = ISUBDTL.POR_ORG_CODE
                           AND IDTL.PLC_LOC_CODE = ISUBDTL.PLC_LOC_CODE
                           AND IDTL.PDP_DEPT_CODE = ISUBDTL.PDP_DEPT_CODE
                           AND IDTL.PDT_DOCTYPE = ISUBDTL.PDT_DOCTYPE
                           AND IDTL.GIH_DOCUMENTNO = ISUBDTL.GIH_DOCUMENTNO
                           AND IDTL.GIH_INTI_ENTRYNO = ISUBDTL.GIH_INTI_ENTRYNO
                           AND IDTL.GIH_YEAR = ISUBDTL.GIH_YEAR
                           AND IDTL.GID_PLY_SERIALNO = ISUBDTL.GID_PLY_SERIALNO )
            LEFT OUTER JOIN (
                SELECT
                    I.POR_ORG_CODE,
                    I.PLC_LOC_CODE,
                    I.PDP_DEPT_CODE,
                    I.PDT_DOCTYPE,
                    I.GIH_DOCUMENTNO,
                    I.GIH_INTI_ENTRYNO,
                    I.GIH_YEAR,
                    SUM(CASE COALESCE(ISUBDTL1.GIS_LOSSADJUSTED, 0)
                        WHEN 0   THEN CASE COALESCE(ISUBDTL1.GIS_LOSSASSESSED, 0)
                            WHEN 0   THEN CASE COALESCE(ISUBDTL1.GIS_LOSSCLAIMED, 0)
                                WHEN 0   THEN 0
                                ELSE COALESCE(ISUBDTL1.GIS_LOSSCLAIMED, 0)
                            END
                            ELSE COALESCE(ISUBDTL1.GIS_LOSSASSESSED, 0)
                        END
                        ELSE COALESCE(ISUBDTL1.GIS_LOSSADJUSTED, 0)
                    END * CASE
                        WHEN COALESCE(I.GIH_NOCLAIM_TAG, 'V') = 'N' THEN 0
                        ELSE 1
                    END + COALESCE(ISUBDTL1.GIS_SURVEYORAMT, 0) + COALESCE(ISUBDTL1.GIS_ADVOCATEAMT, 0) - COALESCE(ISUBDTL1.GIS_SALVAGEAMT
                    , 0)) AS TLOSS
                FROM
                    GI_GC_IH_INTIMATIONHD I
                    LEFT OUTER JOIN (
                        SELECT
                            POR_ORG_CODE,
                            PLC_LOC_CODE,
                            PDP_DEPT_CODE,
                            PDT_DOCTYPE,
                            GIH_DOCUMENTNO,
                            GID_PLY_SERIALNO,
                            GIH_INTI_ENTRYNO,
                            GIH_YEAR,
                            SUM(COALESCE(GIS_LOSSCLAIMED, 0)) GIS_LOSSCLAIMED,
                            SUM(COALESCE(GIS_LOSSASSESSED, 0)) GIS_LOSSASSESSED,
                            SUM(COALESCE(GIS_LOSSADJUSTED, 0)) GIS_LOSSADJUSTED,
                            SUM(COALESCE(GIS_SURVEYORAMT, 0)) GIS_SURVEYORAMT,
                            SUM(COALESCE(GIS_ADVOCATEAMT, 0)) GIS_ADVOCATEAMT,
                            SUM(COALESCE(GIS_SALVAGEAMT, 0)) GIS_SALVAGEAMT
                        FROM
                            GI_GC_IS_INTIMATIONSUBDTL
                        GROUP BY
                            POR_ORG_CODE,
                            PLC_LOC_CODE,
                            PDP_DEPT_CODE,
                            PDT_DOCTYPE,
                            GIH_DOCUMENTNO,
                            GID_PLY_SERIALNO,
                            GIH_INTI_ENTRYNO,
                            GIH_YEAR
                    ) ISUBDTL1 ON I.POR_ORG_CODE = ISUBDTL1.POR_ORG_CODE
                                  AND I.PLC_LOC_CODE = ISUBDTL1.PLC_LOC_CODE
                                  AND I.PDP_DEPT_CODE = ISUBDTL1.PDP_DEPT_CODE
                                  AND I.PDT_DOCTYPE = ISUBDTL1.PDT_DOCTYPE
                                  AND I.GIH_DOCUMENTNO = ISUBDTL1.GIH_DOCUMENTNO
                                  AND I.GIH_INTI_ENTRYNO = ISUBDTL1.GIH_INTI_ENTRYNO
                                  AND I.GIH_YEAR = ISUBDTL1.GIH_YEAR
                GROUP BY
                    I.POR_ORG_CODE,
                    I.PLC_LOC_CODE,
                    I.PDP_DEPT_CODE,
                    I.PDT_DOCTYPE,
                    I.GIH_DOCUMENTNO,
                    I.GIH_INTI_ENTRYNO,
                    I.GIH_YEAR
            ) X ON IH.POR_ORG_CODE = X.POR_ORG_CODE
                   AND IH.PLC_LOC_CODE = X.PLC_LOC_CODE
                   AND IH.PDP_DEPT_CODE = X.PDP_DEPT_CODE
                   AND IH.PDT_DOCTYPE = X.PDT_DOCTYPE
                   AND IH.GIH_DOCUMENTNO = X.GIH_DOCUMENTNO
                   AND IH.GIH_INTI_ENTRYNO = X.GIH_INTI_ENTRYNO
                   AND IH.GIH_YEAR = X.GIH_YEAR
            INNER JOIN GI_GU_DH_DOC_HEADER H ON ( IDTL.GID_BASEDOCUMENTNO = H.GDH_DOC_REFERENCE_NO
                                                  AND H.GDH_RECORD_TYPE = 'O' )
            INNER JOIN CLAIM_PAID_TABLE B ON ( IH.GIH_DOC_REF_NO = B.CLMREF
                                               AND IH.GIH_INTI_ENTRYNO = B.INT_ENTRY_NO )
            INNER JOIN GI_GC_SH_SETTELMENTHD SH ON ( SH.GSH_DOC_REF_NO = B.CLMREF
                                                     AND SH.GIH_INTI_ENTRYNO = B.INT_ENTRY_NO
                                                     AND SH.GSH_ENTRYNO = B.SETT_NO )
            INNER JOIN PR_GN_PS_PARTY PP ON ( IH.PPS_PARTY_CODE = PP.PPS_PARTY_CODE )
            INNER JOIN PR_GN_DP_DEPARTMENT DP ON ( IH.PDP_DEPT_CODE = DP.PDP_DEPT_CODE
                                                   AND IH.PLC_LOC_CODE = DP.PLC_LOC_CODE )
            INNER JOIN PR_GN_LC_LOCATION LC ON ( IH.PLC_LOC_CODE = LC.PLC_LOC_CODE )
            LEFT OUTER JOIN PR_GC_OC_LOSS_CAUSE CL ON ( IH.PDP_DEPT_CODE = CL.PDP_DEPT_CODE
                                                        AND IH.POC_LOSSCODE = CL.POC_LOSSCODE )
            LEFT OUTER JOIN (
                SELECT
                    PD.POR_ORG_CODE,
                    PD.PLC_LOC_CODE,
                    PD.PDP_DEPT_CODE,
                    PD.PDT_DOCTYPE,
                    PD.GIH_DOCUMENTNO,
                    PD.GIH_YEAR,
                    PD.GSH_ENTRYNO,
                    CASE
                        WHEN PT.PYY_CODE IN (
                            '01001',
                            '01004'
                        ) THEN '0002'
                        WHEN PT.PYY_CODE IN (
                            '02001'
                        ) THEN '0007'
                        WHEN PT.PYY_CODE IN (
                            '04001',
                            '03001',
                            '03002',
                            '01006'
                        ) THEN '0008'
                        WHEN PT.PYY_CODE IN (
                            '01002',
                            '04003'
                        ) THEN '0009'
                        WHEN PT.PYY_CODE IN (
                            '01003',
                            '02002'
                        ) THEN '0005'
                        WHEN PT.PYY_CODE IN (
                            '04001',
                            '04002',
                            '04003',
                            '04004',
                            '04005'
                        ) THEN '0028'
                        ELSE '0028'
                    END PAYEE_TYPE,
                    MAX(CASE
                        WHEN PT.PYY_CODE IN(
                            '01001', '01004'
                        ) THEN I.PPS_DESC
                        WHEN PT.PYY_CODE IN(
                            '02001'
                        ) THEN L.PSR_SURV_NAME
                        WHEN PT.PYY_CODE IN(
                            '04001', '03001', '03002', '01006'
                        ) THEN M.PAV_ADVOCATE_NAME
                        WHEN PT.PYY_CODE IN(
                            '01002', '04003'
                        ) THEN J.PWC_DESCRIPTION
                        WHEN PT.PYY_CODE IN(
                            '01003', '02002'
                        ) THEN I.PPS_DESC
                        WHEN PT.PYY_CODE IN(
                            '04001', '04002', '04003', '04004', '04005'
                        ) THEN J.PWC_DESCRIPTION
                        ELSE J.PWC_DESCRIPTION
                    END) PAYEE_NAME,
                    SUM(PD.GPD_SALESTAX_AMOUNT) GSD_CO_SALESTAXAMOUNT,
                    SUM(PD.GPD_PAYEE_AMOUNT *(CASE
                        WHEN PD.GPD_PAYMENT_TYPE = '04'   THEN - 1
                        ELSE 1
                    END)) GSD_LOSSPAID1
                FROM
                    GI_GC_PD_PAYMENT_DETAIL PD
                    INNER JOIN PR_GC_YY_PAYMENT_TYPE PT ON ( PT.PYY_CODE = PD.GPD_PAYEE_TYPE )
                    LEFT OUTER JOIN PR_GN_PS_PARTY I ON ( I.PPS_PARTY_CODE = PD.GPD_PAYEE_CODE_DESC )
                    LEFT OUTER JOIN PR_GC_WS_WORKSHOP J ON ( J.PWC_CODE = PD.GPD_PAYEE_CODE_DESC )
                    LEFT OUTER JOIN PR_GC_DL_DEALER K ON ( K.PDL_CODE = PD.GPD_PAYEE_CODE_DESC )
                    LEFT OUTER JOIN PR_GG_SR_SURVEYOR L ON ( L.PSR_SURV_CODE = PD.GPD_PAYEE_CODE_DESC )
                    LEFT OUTER JOIN PR_GC_AV_ADVOCATE M ON ( M.PAV_ADVOCATE_CODE = PD.GPD_PAYEE_CODE_DESC )
                GROUP BY
                    PD.POR_ORG_CODE,
                    PD.PLC_LOC_CODE,
                    PD.PDP_DEPT_CODE,
                    PD.PDT_DOCTYPE,
                    PD.GIH_DOCUMENTNO,
                    PD.GIH_YEAR,
                    PD.GSH_ENTRYNO,
                    CASE
                        WHEN PT.PYY_CODE IN (
                            '01001',
                            '01004'
                        ) THEN '0002'
                        WHEN PT.PYY_CODE IN (
                            '02001'
                        ) THEN '0007'
                        WHEN PT.PYY_CODE IN (
                            '04001',
                            '03001',
                            '03002',
                            '01006'
                        ) THEN '0008'
                        WHEN PT.PYY_CODE IN (
                            '01002',
                            '04003'
                        ) THEN '0009'
                        WHEN PT.PYY_CODE IN (
                            '01003',
                            '02002'
                        ) THEN '0005'
                        WHEN PT.PYY_CODE IN (
                            '04001',
                            '04002',
                            '04003',
                            '04004',
                            '04005'
                        ) THEN '0028'
                        ELSE '0028'
                    END
            ) STX ON ( SH.POR_ORG_CODE = STX.POR_ORG_CODE
                       AND SH.PLC_LOC_CODE = STX.PLC_LOC_CODE
                       AND SH.PDP_DEPT_CODE = STX.PDP_DEPT_CODE
                       AND SH.PDT_DOCTYPE = STX.PDT_DOCTYPE
                       AND SH.GIH_DOCUMENTNO = STX.GIH_DOCUMENTNO
                       AND SH.GIH_YEAR = STX.GIH_YEAR
                       AND SH.GSH_ENTRYNO = STX.GSH_ENTRYNO
                       AND STX.PAYEE_TYPE = B.PSP_STYPCODE )
            LEFT OUTER JOIN GI_GC_UD_SURVEYORDTL SVD ON ( IH.POR_ORG_CODE = SVD.POR_ORG_CODE
                                                          AND IH.PLC_LOC_CODE = SVD.PLC_LOC_CODE
                                                          AND IH.PDP_DEPT_CODE = SVD.PDP_DEPT_CODE
                                                          AND IH.PDT_DOCTYPE = SVD.PDT_DOCTYPE
                                                          AND IH.GIH_DOCUMENTNO = SVD.GIH_DOCUMENTNO
                                                          AND IH.GIH_INTI_ENTRYNO = SVD.GIH_INTI_ENTRYNO
                                                          AND IH.GIH_YEAR = SVD.GIH_YEAR
                                                          AND GUD_SERIALNO = 1 )
            LEFT OUTER JOIN PR_GG_SR_SURVEYOR SV ON ( SVD.PSR_SURV_CODE = SV.PSR_SURV_CODE )
            LEFT OUTER JOIN GI_GC_IC_INTIMATION_COINSURER IC ON ( IDTL.POR_ORG_CODE = IC.POR_ORG_CODE
                                                                  AND IDTL.PLC_LOC_CODE = IC.PLC_LOC_CODE
                                                                  AND IDTL.PDP_DEPT_CODE = IC.PDP_DEPT_CODE
                                                                  AND IDTL.PDT_DOCTYPE = IC.PDT_DOCTYPE
                                                                  AND IDTL.GIH_DOCUMENTNO = IC.GIH_DOCUMENTNO
                                                                  AND IDTL.GIH_INTI_ENTRYNO = IC.GIH_INTI_ENTRYNO
                                                                  AND IDTL.GIH_YEAR = IC.GIH_YEAR
                                                                  AND IDTL.GID_BASEDOCUMENTNO = IC.GIC_BASEDOCUMENTNO
                                                                  AND IC.GIC_CORETAG = 'C'
                                                                  AND IC.GIC_LEADERTAG = 'Y' )
        WHERE
            SH.GSH_SETTLEMENTDATE BETWEEN '01-jan-2000' AND '31-dec-2018'
            AND B.VCHDATE BETWEEN '01-jan-2018' AND '31-dec-2018'
            AND H.GDH_COMMDATE BETWEEN '01-jan-2000' AND '31-dec-2018'
            AND IH.GIH_INTIMATIONDATE BETWEEN '01-jan-2000' AND '31-dec-2018'
    );