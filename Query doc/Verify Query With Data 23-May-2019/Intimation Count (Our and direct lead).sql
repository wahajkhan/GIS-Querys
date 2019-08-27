SELECT
    lc.PLC_LOCADESC,
    dp.PDP_DEPTDESC,
    PP.PPS_DESC,
    COUNT(gih_documentno)
FROM
    hil.gi_gc_ih_intimationhd i
       LEFT OUTER JOIN pr_gn_lc_location lc ON (
        lc.PLC_LOC_CODE = i.PLC_LOC_CODE
    )
    LEFT OUTER JOIN pr_gn_dp_department dp ON (
            dp.PDP_DEPT_CODE = i.PDP_DEPT_CODE
        AND
        dp.PLC_LOC_CODE = i.PLC_LOC_CODE
    )
    LEFT OUTER JOIN pr_gn_ps_party pp ON (
        pp.PPS_PARTY_CODE = i.PPS_PARTY_CODE
    )
     
WHERE
        i.gih_intimationdate BETWEEN '16-May-2018' AND '15-MAY-2019'
    AND
     i.PIY_INSUTYPE in ('D','O')
    and 
        i.gih_inti_entryno = '1'
    AND
        i.gih_postingtag = 'Y'
    AND
        i.gih_cancellationtag IS NULL
GROUP BY
    lc.PLC_LOCADESC,
    dp.PDP_DEPTDESC,
    pp.PPS_DESC
    ;
--ORDER BY pdp_dept_code;