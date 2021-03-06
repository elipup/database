CREATE OR REPLACE FUNCTION orderitemData(TEXT, INTEGER, INTEGER) RETURNS SETOF orderitemtype
AS $$
DECLARE
  pOrdertype ALIAS FOR $1;
  pOrderheadid ALIAS FOR $2;
  pOrderitemid ALIAS FOR $3;
  _row orderitemtype%ROWTYPE;
  _set RECORD;

BEGIN

  IF(UPPER(pOrdertype)='PO') THEN
    FOR _set IN 
      SELECT poitem_id              AS orderitem_id,
             'PO'                   AS orderitem_orderhead_type,
             poitem_pohead_id       AS orderitem_orderhead_id,
             poitem_linenumber      AS orderitem_linenumber,
             poitem_status          AS orderitem_status,
             poitem_itemsite_id     AS orderitem_itemsite_id,
             poitem_date_promise    AS orderitem_scheddate,
             poitem_qty_ordered     AS orderitem_qty_ordered,
             poitem_qty_returned    AS orderitem_qty_shipped,
             poitem_qty_received    AS orderitem_qty_received,
             uom_id                 AS orderitem_qty_uom_id,
             poitem_invvenduomratio AS orderitem_qty_invuomratio,
             poitem_unitprice       AS orderitem_unitcost,
             (SELECT pohead_curr_id FROM pohead WHERE pohead_id=poitem_pohead_id)
                                    AS orderitem_unitcost_curr_id,
             poitem_freight         AS orderitem_freight,
             poitem_freight_received AS orderitem_freight_received,
             (SELECT pohead_curr_id FROM pohead WHERE pohead_id=poitem_pohead_id)
                                    AS orderitem_freight_curr_id
        FROM poitem LEFT OUTER JOIN uom ON (uom_name=poitem_vend_uom)
       WHERE(((pOrderheadid IS NULL) OR (poitem_pohead_id=pOrderheadid))
         AND ((pOrderitemid IS NULL) OR (poitem_id=pOrderitemid))) LOOP
  
      _row.orderitem_id := _set.orderitem_id;
      _row.orderitem_orderhead_type := _set.orderitem_orderhead_type;
      _row.orderitem_orderhead_id := _set.orderitem_orderhead_id;
      _row.orderitem_linenumber := _set.orderitem_linenumber;
      _row.orderitem_status := _set.orderitem_status;
      _row.orderitem_itemsite_id := _set.orderitem_itemsite_id;
      _row.orderitem_scheddate := _set.orderitem_scheddate;
      _row.orderitem_qty_ordered := _set.orderitem_qty_ordered;
      _row.orderitem_qty_shipped := _set.orderitem_qty_shipped;
      _row.orderitem_qty_received := _set.orderitem_qty_received;
      _row.orderitem_qty_uom_id := _set.orderitem_qty_uom_id;
      _row.orderitem_qty_invuomratio := _set.orderitem_qty_invuomratio;
      _row.orderitem_unitcost := _set.orderitem_unitcost;
      _row.orderitem_unitcost_curr_id := _set.orderitem_unitcost_curr_id;
      _row.orderitem_freight := _set.orderitem_freight;
      _row.orderitem_freight_received := _set.orderitem_freight_received;
      _row.orderitem_freight_curr_id := _set.orderitem_freight_curr_id;

      RETURN NEXT _row;
    END LOOP;
  ELSEIF(UPPER(pOrdertype)='SO') THEN
    FOR _set IN 
      SELECT coitem_id              AS orderitem_id,
             'SO'                   AS orderitem_orderhead_type,
             coitem_cohead_id       AS orderitem_orderhead_id,
             coitem_linenumber      AS orderitem_linenumber,
             coitem_status          AS orderitem_status,
             coitem_itemsite_id     AS orderitem_itemsite_id,
             coitem_scheddate       AS orderitem_scheddate,
             coitem_qtyord          AS orderitem_qty_ordered,
             coitem_qtyshipped      AS orderitem_qty_shipped,
             coitem_qtyreturned     AS orderitem_qty_received,
             coitem_qty_uom_id      AS orderitem_qty_uom_id,
             coitem_qty_invuomratio AS orderitem_qty_invuomratio,
             coitem_unitcost        AS orderitem_unitcost,
             basecurrid()           AS orderitem_unitcost_curr_id,
             NULL                   AS orderitem_freight,
             NULL                   AS orderitem_freight_received,
             basecurrid()           AS orderitem_freight_curr_id
        FROM coitem
       WHERE(((pOrderheadid IS NULL) OR (coitem_cohead_id=pOrderheadid))
         AND ((pOrderitemid IS NULL) OR (coitem_id=pOrderitemid))) LOOP
  
      _row.orderitem_id := _set.orderitem_id;
      _row.orderitem_orderhead_type := _set.orderitem_orderhead_type;
      _row.orderitem_orderhead_id := _set.orderitem_orderhead_id;
      _row.orderitem_linenumber := _set.orderitem_linenumber;
      _row.orderitem_status := _set.orderitem_status;
      _row.orderitem_itemsite_id := _set.orderitem_itemsite_id;
      _row.orderitem_scheddate := _set.orderitem_scheddate;
      _row.orderitem_qty_ordered := _set.orderitem_qty_ordered;
      _row.orderitem_qty_shipped := _set.orderitem_qty_shipped;
      _row.orderitem_qty_received := _set.orderitem_qty_received;
      _row.orderitem_qty_uom_id := _set.orderitem_qty_uom_id;
      _row.orderitem_qty_invuomratio := _set.orderitem_qty_invuomratio;
      _row.orderitem_unitcost := _set.orderitem_unitcost;
      _row.orderitem_unitcost_curr_id := _set.orderitem_unitcost_curr_id;
      _row.orderitem_freight := _set.orderitem_freight;
      _row.orderitem_freight_received := _set.orderitem_freight_received;
      _row.orderitem_freight_curr_id := _set.orderitem_freight_curr_id;

      RETURN NEXT _row;
    END LOOP;
  END IF;

  RETURN;
END;
$$
LANGUAGE 'plpgsql';

