var Validator = {
  findForms: function() {
    Validator.forms = $$('.required').map(function(input) { return input.form; }).uniq();
    Validator.forms.invoke('observe', 'submit', Validator.performCheck)
  },
  
  performCheck: function(event) {
    var form = event.element();
    var requiredInputs = form.select('.required');
    if ( requiredInputs.any(Validator.blank) ) {
      requiredInputs.invoke('addClassName', 'err');
      event.stop();
    }
  },
  
  blank: function(element) {
    return $F(element).empty();
  }
}

Event.observe(document, 'dom:loaded', Validator.findForms)