UPDATE hil.gi_gr_si_treatyfaculthd g
    SET
        gsi_postingtag = NULL
WHERE
        gsi_commdate BETWEEN '01-JAN-2019' AND '31-MAR-2019'

--aND  PLC_LOC_CODE <> '10103'
    AND
        pdp_dept_code = '13'
    AND
        gdh_year = '2019'
    AND
        EXISTS (
            SELECT
                'x'
            FROM
                gi_gu_dh_doc_header h
            WHERE
                    pps_party_code IN (
                        '1114703404','1114703426','1114703434','1114703435','1114703476','1114703497','1200000767','1300019811','1300020782','1300020912'

                    )
                AND
                    gdh_commdate BETWEEN '01-JAN-2019' AND '31-MAR-2019'
                AND
                    gdh_record_type = 'O'
                AND
                    g.gsi_doc_reference_no = h.gdh_doc_reference_no
        );