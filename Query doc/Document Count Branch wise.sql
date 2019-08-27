
select a.PLC_DESC,sum(a.doc) "Total Doc Count" from (
select  lc.PLC_DESC  , count(h.GDH_DOC_REFERENCE_NO) doc
from gi_gu_dh_doc_header h
left join pr_gn_lc_location  lc on h.PLC_LOC_CODE=lc.PLC_LOC_CODE
where GDH_POSTING_TAG='Y' and GDH_CANCELLATION_TAG is null and PDT_DOCTYPE='T'
and GDH_ISSUEDATE between '01-Jan-2019' and '31-Mar-2019'
group by lc.PLC_DESC  , h.GDH_DOC_REFERENCE_NO) a
group by a.PLC_DESC, a.doc
;


