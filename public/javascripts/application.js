Event.observe(document, 'dom:loaded', function() {
  
  var FlashHider = {
    click: function(event) {
      var element = event.element();
      var wrapper = element.wrap('div');
      wrapper.fade({ duration: 0.7 });
      event.stop();
    }
  };
  
  $$('.flash').invoke('observe', 'click', FlashHider.click);

  var Validator = {
    findForms: function() {
      Validator.forms = $$('.required').pluck('form').uniq();
      Validator.forms.invoke('observe', 'submit', Validator.performCheck)
    },

    performCheck: function(event) {
      var form = event.element();
      var requiredInputs = form.select('.required');
      if ( requiredInputs.any(Validator.blank) ) {
        requiredInputs.invoke('addClassName', 'err');
        event.stop();
      } else {
        function submittify(testElement) {
          var testElement = $(testElement);
          var title = testElement.readAttribute('title');
          if ( title != null && !title.blank() ) {
            testElement.value = title;
            testElement.setStyle({ color: '#777' })
          }
        }
        var element = event.element();
        var inputs = element.select('input[type=submit]');
        inputs.each(submittify);
      }
    },

    blank: function(element) {
      return $F(element).empty();
    }
  };
 
  Validator.findForms();
})