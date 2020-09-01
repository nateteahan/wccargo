ruleset com.mastunited.tracking {
  meta {
    use module io.picolabs.wrangler alias wrangler
    use module com.mastunited.html alias html
    shares __testing, orders, index
  }
  global {
    __testing = { "queries":
      [ { "name": "__testing" }
      , { "name": "orders", "args": [ "id" ] }
      ] , "events":
      [ //{ "domain": "d1", "type": "t1" }
      //, { "domain": "d2", "type": "t2", "attrs": [ "a1", "a2" ] }
      ]
    }
    orders = function(id){
      id => wrangler:children(id).head() | wrangler:children().map(function(o){o.get("name")})
    }
    index = function(id){
// form to accept order number
      id.isnull() =>
        html:header("Cargo Tracking -- Mast United")
        + <<<p>CARGO TRACKING</p>
>>
        + <<<form id="orderno"><input name="id" placeholder="Order#"></form>
>>
        + <<six digit number, including leading zeros
<script type="text/javascript">
document.getElementById('orderno').id.focus()
</script>
>>
        + html:footer()
// order number unknown
      | orders(id).isnull() => html:header("Cargo Tracking -- Mast United")
        + <<<p>Order #{id} not found</p>
>>
        +html:footer()
// get page from order pico
      | wrangler:skyQuery(orders(id).get("eci"),"com.mastunited.order","index")
    }
  }
}