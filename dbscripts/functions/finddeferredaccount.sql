
CREATE OR REPLACE FUNCTION findDeferredAccount(INTEGER) RETURNS INTEGER STABLE AS $$
-- Copyright (c) 1999-2011 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  pCustid ALIAS FOR $1;
  _accntid INTEGER;

BEGIN

--  Check for a Customer Type specific Account
  SELECT araccnt_deferred_accnt_id INTO _accntid
  FROM araccnt, cust
  WHERE ( (araccnt_custtype_id=cust_custtype_id)
   AND (cust_id=pCustid) );
  IF (FOUND) THEN
    RETURN _accntid;
  END IF;

--  Check for a Customer Type pattern
  SELECT araccnt_deferred_accnt_id INTO _accntid
  FROM araccnt, cust, custtype
  WHERE ( (custtype_code ~ araccnt_custtype)
   AND (cust_custtype_id=custtype_id)
   AND (araccnt_custtype_id=-1)
   AND (cust_id=pCustid) );
  IF (FOUND) THEN
    RETURN _accntid;
  END IF;

  RETURN -1;

END;
$$ LANGUAGE 'plpgsql';

