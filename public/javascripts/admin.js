Event.observe(document, 'dom:loaded', function() {
  var Logouter = {
    click: function(event) {
      $('logout').hide();
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

  var Editable = Class.create({
    editFieldTag: 'textarea',
  
    initialize: function(element, options) {
      Object.extend(this, options);
      this.element = $(element);
      this.field = this.element.identify();
      this.value = this.element.innerHTML;
      this.setupForm();
      this.setupBehaviors();
    },
  
    setupForm: function() {
      this.editForm = new Element('form', { 'action': this.element.readAttribute('href'), 'style':'display:none', 'class':'editor' })
      this.editInput = new Element(this.editFieldTag, { 'name':this.field });
      this.editInput.update(this.element.innerHTML);
      var saveInput = new Element('input', { 'type':'submit', 'value':'Save' });
      this.cancelLink = new Element('a', { 'href':'#' }); this.cancelLink.update('Cancel');
      var methodInput = new Element('input', { 'type':'hidden', 'value':'put', 'name':'_method' })
      this.editForm.insert(this.editInput);
      this.editForm.insert(this.cancelLink);
      this.editForm.insert(saveInput);
      this.editForm.insert(methodInput);
      this.element.insert({after: this.editForm });
    },
  
    setupBehaviors: function() {
      this.behaviors = { };
      this.behaviors['edit'] = this.edit.bindAsEventListener(this);
      this.behaviors['save'] = this.save.bindAsEventListener(this);
      this.behaviors['cancel'] = this.cancel.bindAsEventListener(this);
      this.element.observe('click', this.behaviors['edit']);
      this.editForm.observe('submit', this.behaviors['save']);
      this.cancelLink.observe('click', this.behaviors['cancel']);
    },
  
    edit: function(event) {
      this.element.hide();
      this.editForm.show();
      this.editInput.activate();
      event.stop();
    },
  
    save: function(event) {
      var form = event.element();
      var pars = form.serialize();
      var url = form.readAttribute('action');
      form.disable();
      new Ajax.Request(url, {
        method: 'put',
        parameters: pars,
        onSuccess: function(transport) {
          var json = transport.responseText.evalJSON();
          var attr = this.field.replace(/\w+\[(\w+)\]/, '$1');
          this.value = json[attr];
          this.editInput.update(json[attr]);
          this.element.update(json[attr]);
          form.enable();
          this.cancel();
        }.bind(this),
        onFailure: function(transport) {
          this.cancel();
          alert("Your change could not be saved.");
        }.bind(this)
      })
      event.stop();
    },
  
    cancel: function(event) {
      this.element.show();
      this.editInput.update(this.value);
      this.editForm.hide();
      event.stop();
    }
  })
 
  Editable.create = function(element) {
    new Editable(element);
  }
 
  $$('.editable').each(Editable.create);
  $$('#logout').invoke('observe', 'click', Logouter.click);
  $$('#admin #confirm a').invoke('observe', 'click', Logouter.confirm);
});
