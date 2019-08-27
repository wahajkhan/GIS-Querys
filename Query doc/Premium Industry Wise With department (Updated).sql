SELECT
    COUNT(p.docrefno),
     i.pcd_code,
    i.pcd_desc,
    SUM(p.suminsured) suminsured,
    SUM(p.grossprem + p.admin) grossprem
FROM
    hil.premium_view p
    LEFT OUTER JOIN hicl_comp_industry i ON (
        i.pcd_code = p.pcd_code
    )
WHERE
        p.pdp_dept_code = 11
    AND
        p.issuedate BETWEEN '01-Jan-2018' AND '31-Dec-2018'
GROUP BY
    i.pcd_code,
    i.pcd_desc
ORDER BY i.pcd_desc;








SELECT
    i.pcd_code,
    i.compindustry,
    i.pcd_desc,
    COUNT(p.docrefno) docrefnocount,
    SUM(p.suminsured) suminsured,
    SUM(p.grossprem + p.admin) grossprem
FROM
    premium_view p
    LEFT OUTER JOIN hicl_comp_industry i ON (
        i.pcd_code = p.pcd_code
    )
WHERE
    p.pcd_code = i.pcd_code
    and 
        p.pdp_dept_code = 11
    AND
        p.issuedate BETWEEN '01-Jan-2018' AND '31-Dec-2018'
GROUP BY
    i.pcd_code,
    i.pcd_desc,
    i.compindustry
ORDER BY i.pcd_desc;