select * from(SELECT
    a.plc_loc_code,
    lc.plc_desc,
    a.client_code,
    pp.pps_desc client,
    a.pdp_dept_code,
--    a.pdo_devoffcode,
--    dv.pdo_devoffdesc,
        CASE
            WHEN dp.pdp_desc = 'Health'   THEN 'Miscellaneous'
            ELSE dp.pdp_desc
        END
    dept,
    year(a.issuedate) yr,
    month(a.issuedate) mt,
        CASE
            WHEN year(a.issuedate) = '2019'   THEN COUNT(docrefno)
            ELSE 0
        END
    AS doc_ref_curr,
        CASE
            WHEN year(a.issuedate) = '2019'   THEN SUM(coalesce(
                a.suminsured,
                0
            ) )
            ELSE 0
        END
    AS suminsured_curr,
        CASE
            WHEN year(a.issuedate) = '2019'   THEN SUM(coalesce(
                a.grossprem,
                0
            ) ) + SUM(coalesce(
                a.admin,
                0
            ) )
            ELSE 0
        END
    AS curr_grosspremium
FROM
    premium_view a
    LEFT OUTER JOIN pr_gn_lc_location lc ON (
        a.plc_loc_code = lc.plc_loc_code
    )
    LEFT OUTER JOIN pr_gn_dp_department dp ON (
            dp.pdp_dept_code = a.pdp_dept_code
        AND
            dp.plc_loc_code = a.plc_loc_code
    )
    LEFT OUTER JOIN pr_gn_ps_party pp ON (
        a.client_code = pp.pps_party_code
    )
    LEFT OUTER JOIN pr_gg_do_devofficer dv ON (
        a.pdo_devoffcode = dv.pdo_devoffcode
    )
WHERE
        year(a.issuedate) <= '2019'
    AND
        year(a.issuedate) >= '2019'
    AND
        month(a.issuedate) BETWEEN '01' AND '03'
    AND
        a.pdp_dept_code BETWEEN '01' AND '99'
    AND
        a.plc_loc_code BETWEEN '00001' AND '99999'
    AND
        'A' = 'A'
    AND
        a.client_code BETWEEN
            CASE 'All'
                WHEN 'All'   THEN a.client_code
                ELSE 'All'
            END
        AND
            CASE 'All'
                WHEN 'All'   THEN a.client_code
                ELSE 'All'
            END
    AND
        a.pdt_doctype IN (
            'O','E','P'
        )
GROUP BY
    a.plc_loc_code,
    lc.plc_desc,
    a.client_code,
    pp.pps_desc,
    a.pdp_dept_code,
    dp.pdp_desc,
    year(a.issuedate),
    month(a.issuedate),
    a.pdo_devoffcode,
    dv.pdo_devoffdesc) res
ORDER BY
res.mt asc;
    