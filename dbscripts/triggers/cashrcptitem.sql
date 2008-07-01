CREATE OR REPLACE FUNCTION _cashRcptItemTrigger () RETURNS TRIGGER AS '
DECLARE
  _check      BOOLEAN;
  _openAmount NUMERIC;

BEGIN

  -- Checks
  -- Start with Privileges
  IF (TG_OP = ''INSERT'') THEN
    SELECT checkPrivilege(''MaintainCashReceipts'') INTO _check;
    IF NOT (_check) THEN
      RAISE EXCEPTION ''You do not have privileges to add a new Cash Receipt Application.'';
    END IF;
  ELSE
    SELECT checkPrivilege(''MaintainCashReceipts'') INTO _check;
    IF NOT (_check) THEN
      RAISE EXCEPTION ''You do not have privileges to alter a Cash Receipt Application.'';
    END IF;
  END IF;

  -- Over Application
  IF (TG_OP = ''INSERT'') THEN
    SELECT currToCurr(aropen_curr_id, cashrcpt_curr_id,
                      aropen_amount - aropen_paid, aropen_docdate) INTO _openAmount
    FROM aropen, cashrcpt
    WHERE ( (aropen_id=NEW.cashrcptitem_aropen_id)
      AND   (cashrcpt_id=NEW.cashrcptitem_cashrcpt_id) );
  ELSE
    SELECT currToCurr(aropen_curr_id, cashrcpt_curr_id,
                      aropen_amount - aropen_paid, aropen_docdate) INTO _openAmount
    FROM aropen, cashrcpt
    WHERE ( (aropen_id=COALESCE(NEW.cashrcptitem_aropen_id, OLD.cashrcptitem_aropen_id))
      AND   (cashrcpt_id=COALESCE(NEW.cashrcptitem_cashrcpt_id, OLD.cashrcptitem_cashrcpt_id)) );
  END IF;
  IF (NEW.cashrcptitem_amount > _openAmount) THEN
    RAISE EXCEPTION ''You may not apply more than the balance of this item.'';
  END IF;

  RETURN NEW;

END;
' LANGUAGE 'plpgsql';

DROP TRIGGER cashRcptItemTrigger ON cashrcptitem;
CREATE TRIGGER cashRcptItemTrigger BEFORE INSERT OR UPDATE ON cashrcptitem FOR EACH ROW EXECUTE PROCEDURE _cashRcptItemTrigger();

CREATE OR REPLACE FUNCTION _cashRcptItemAfterTrigger () RETURNS TRIGGER AS '
DECLARE
  _total      NUMERIC;

BEGIN

  -- Checks
  -- Total Over Application Warning
  SELECT (cashrcpt_amount - SUM(COALESCE(cashrcptitem_amount, 0))) INTO _total
  FROM cashrcptitem JOIN cashrcpt ON (cashrcpt_id=cashrcptitem_cashrcpt_id)
  WHERE (cashrcptitem_cashrcpt_id=NEW.cashrcptitem_cashrcpt_id)
  GROUP BY cashrcpt_amount;
  IF (_total < 0.0) THEN
    RAISE WARNING ''Warning -- the Cash Receipt has been over applied.'';
  END IF;
  
  RETURN NEW;

END;
' LANGUAGE 'plpgsql';

DROP TRIGGER cashRcptItemAfterTrigger ON cashrcptitem;
CREATE TRIGGER cashRcptItemAfterTrigger AFTER INSERT OR UPDATE ON cashrcptitem FOR EACH ROW EXECUTE PROCEDURE _cashRcptItemAfterTrigger();
