SELECT
    gm.CLIENTGROUP,
    pv.EXPDATE,
    dp.PDP_DESC, 
    pv.DOCREFNO,
    gm.CLIENTNAME,
                pv.suminsured,

                pv.grossprem,
                pv.admin

FROM
    premium_view pv
    left outer join HICL_GROUPMAPPING gm
    on(
        pv.CLIENT_CODE=gm.CLIENTCODE
    )
    LEFT OUTER JOIN pr_gn_dp_department dp ON (
            dp.pdp_dept_code = pv.pdp_dept_code
        )
    where gm.CLIENTGROUP like('%Mehmood%')
    and year(pv.EXPDATE) between '2018' and '2019' 
    and       pv.pdt_doctype IN (
           'P'
        )