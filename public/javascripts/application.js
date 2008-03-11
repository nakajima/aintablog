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

var ElementExtensions = {
  spanify: function(element) {
    var element = $(element);
    var text = element.innerHTML;
    var span = new Element('span');
    span.innerHTML = text;
    element.update(span);
    return element;
  }
}

var PostForm = {
  Types: {
    article: function(event) {
      
    },
    
    snippet: function(event) {
      
    },
    
    quote: function(event) {
      
    },
    
    link: function(event) {
      
    }
  }
}

Event.observe(document, 'dom:loaded', function() {
  $$('.spanify').each(ElementExtensions.spanify);
  $('logout').observe('click', Logouter.click);
  $$('#admin #confirm a').invoke('observe', 'click', Logouter.confirm);
})