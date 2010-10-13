COMMENT ON ccpay IS 'Track Credit Card PAYments, although really this table tracs communications with Credit Card processing companies. Records in this table may progress from preauthorizations through captures to credits, or they may simply remain in their original state if there is no further processing.';
COMMENT ON ccpay.ccpay_id IS 'Internal ID of this ccpay record.';
COMMENT ON ccpay.ccpay_ccard_id IS 'Internal ID of the Credit Card used for this transaction.';
COMMENT ON ccpay.ccpay_cust_id IS 'Internal ID of the Customer owning the Credit Card';
COMMENT ON ccpay.ccpay_amount IS 'Actual amount of this transaction.';
COMMENT ON ccpay.ccpay_auth IS 'Boolean indicator of whether this transaction started out as a pre-authorization or not.';
COMMENT ON ccpay.ccpay_status IS 'The status of the last attempted transaction for this record. Values include A = Authorized, C = Charged, D = Declined or otherwise rejected, V = Voided, X = Error.';
COMMENT ON ccpay.ccpay_type IS 'The most recent type of transaction attempted with this record. Values include A = Authorize, C = Capture or Charge, R = cRedit, V = reVerse or Void.';
COMMENT ON ccpay.ccpay_auth_charge IS 'The original type of transaction attempted with this record. Values are the same as for ccpay_type.';
COMMENT ON ccpay.ccpay_order_number IS 'The original xTuple ERP order for which this credit card transaction applies. This will usually be either a Sales Order number or Credit Memo number.';
COMMENT ON ccpay.ccpay_order_number_seq IS 'A sequence number to differentiate between different transactions for the same ccpay_order_number. For example, if a Customer makes a down payment and a final payment for a single order, there will be two distinct ccpay records with the same ccpay_order_number but different ccpay_order_number_seq values (1 and 2, respectively).';
COMMENT ON ccpay.ccpay_r_avs IS 'The Address Verification System code returned by the credit card processing company.';
COMMENT ON ccpay.ccpay_r_ordernum IS 'A transaction ID returned by the credit card processing company to be used when referring to this transaction later. It may be used for voiding, crediting, or capturing previous transactions.';
COMMENT ON ccpay.ccpay_r_error IS 'Error message, if any, describing why this record failed to be processed properly.';
COMMENT ON ccpay.ccpay_r_approved IS 'English text stating whether the transaction was approved, declined, hit an error, or was held for review. Specific values differ depending on the credit card processor.';
COMMENT ON ccpay.ccpay_r_code IS 'The transaction Approval code returned by the credit card processor. Specific values differ depending on the credit card processor.';
COMMENT ON ccpay.ccpay_r_message IS 'Additional text that describes the status of the transaction. This may be empty.';
COMMENT ON ccpay.ccpay_yp_r_time IS 'The time the transaction was posted according to the credit card processing company. May be blank.';
COMMENT ON ccpay.ccpay_r_ref IS 'An additional reference number assigned to this transaction by the credit card processing company.';
COMMENT ON ccpay.ccpay_yp_r_tdate IS 'The date the transaction was posted according to the credit card processing company. May be blank.';
COMMENT ON ccpay.ccpay_r_tax IS '[ deprecated ]';
COMMENT ON ccpay.ccpay_r_shipping IS '[ deprecated ]';
COMMENT ON ccpay.ccpay_yp_r_score IS 'A potential fraud score returned by the credit card company. May be blank.';
COMMENT ON ccpay.ccpay_transaction_datetime IS 'The date and time this record was created, unless explicitly set by the application.';
COMMENT ON ccpay.ccpay_by_username IS 'The user who created this record, unless explicitly set by the application.';
COMMENT ON ccpay.ccpay_curr_id IS 'The internal ID of the currency of the ccpay_amount.';
COMMENT ON ccpay.ccpay_ccpay_id IS 'Foreign key to another ccpay record. This will have a value if a new ccpay record is created to record a Refund for part or all of another ccpay record.';