// Setup datepicker for statistics query
$(document).ready(function(){
  $('#start_date').datepicker({
    format: "yyyy-mm-dd",
    todayHighlight: true
  });
  $('#end_date').datepicker({
    format: "yyyy-mm-dd",
    todayHighlight: true
  });
});
