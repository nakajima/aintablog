var Logouter = {
  click: function(event) {
    var element = event.element();
    element.hide();
    $('confirm').show();
    event.stop();
  },
  
  confirm: function(event) {
    var element = event.element();
    var result = element.innerHTML;
    if ( result == 'No' ) {
      $('confirm').hide();
      $('logout').show();
      event.stop();
    }
  }
}

Event.observe(document, 'dom:loaded', function() {
  $('logout').observe('click', Logouter.click);
  $$('#admin #confirm a').invoke('observe', 'click', Logouter.confirm)
})