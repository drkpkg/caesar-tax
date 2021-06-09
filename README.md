[![Gem Version](https://badge.fury.io/rb/caesar-tax.svg)](https://badge.fury.io/rb/caesar-tax)

# Caesar taxes
Bring Caesar what is for the Caesar, and for developers the glory

## NOTE
This version is for Ruby >=2.6.x. For Ruby 3 compatibility check ruby-3.0-support branch

### History
The useless Impuestos internos from Bolivia made me do that.

Specification: https://www.impuestos.gob.bo/page/257

### Usage

```ruby
caesar = Caesar.new.authorization_number(29040011007)
     .invoice_number(1503)
     .client_document(4189179011)
     .transaction_date(Date.strptime("2007-07-02", "%Y-%m-%d"))
     .amount_total(2500.00)
     .seed("9rCB7Sv4X29d)5k7N%3ab89p-3(5[A")
     .build_control_code
     .control_code #6A-DC-53-05-14
```

### Testing?
Yes, the tests are for the 5000 cases from the documentation, all correct.

### Contribute

If you have a pr, observations or suggestions, send one, I'm always active
